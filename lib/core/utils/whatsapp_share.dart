import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_strings.dart';
import '../../models/booking_model.dart';
import '../../models/invoice_model.dart';
import 'date_utils.dart';
import 'invoice_pdf.dart';

/// Opens WhatsApp chat with the customer's number and a ready-to-send message.
/// Owner still taps Send in WhatsApp. Free. Not automatic.
abstract final class WhatsAppShare {
  static const _androidChannel = MethodChannel('com.quikgarage.quikgarage/whatsapp');
  static String? waDigits(String? phone) {
    final digits = (phone ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return null;
    if (digits.length == 10) return '91$digits';
    if (digits.length == 11 && digits.startsWith('0')) {
      return '91${digits.substring(1)}';
    }
    if (digits.length == 12 && digits.startsWith('91')) return digits;
    if (digits.length > 10) return digits;
    return null;
  }

  static String bookingMessage(
    BookingModel booking,
    AppStrings s, {
    String? locale,
  }) {
    final name = booking.customerDetail?.name.trim();
    final vehicle = booking.vehicleDetail;
    final garage = booking.garageDetail?.garageName ?? 'QuikGarage';
    final when = AppDateUtils.formatBookingDateTime(
      booking.bookingDate,
      booking.timeSlot,
      locale: locale,
    );
    final hello = (name != null && name.isNotEmpty) ? 'Hi $name,' : 'Hi,';
    return '''
QuikGarage — $garage

$hello
Your booking details:

Vehicle: ${vehicle?.displayName ?? s.vehicleLabel} (${vehicle?.vehicleNumber ?? '-'})
Service: ${s.serviceType(booking.serviceType)}
Schedule: $when
Status: ${s.bookingStatus(booking.status)}
'''.trim();
  }

  static String invoiceMessage(
    InvoiceModel invoice,
    AppStrings s, {
    String? locale,
  }) {
    final booking = invoice.bookingDetail;
    final base = booking == null
        ? 'QuikGarage invoice'
        : bookingMessage(booking, s, locale: locale);
    return '''
$base

Invoice #${invoice.id}
${s.serviceCost}: ₹${invoice.serviceCost}
${s.partsCost}: ₹${invoice.partsCost}
${s.total}: ₹${invoice.totalAmount}
Payment: ${s.paymentStatus(invoice.paymentStatus)}
'''.trim();
  }

  static Future<void> send({
    required BuildContext context,
    required String? phone,
    required String message,
  }) async {
    final s = AppStrings.of(context);
    final digits = waDigits(phone);
    if (digits == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.whatsappNoCustomerPhone)),
      );
      return;
    }
    final uri = Uri.parse(
      'https://wa.me/$digits?text=${Uri.encodeComponent(message)}',
    );
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.whatsappOpenFailed)),
      );
    }
  }

  /// Builds an invoice PDF and opens the share sheet so the owner can
  /// send the file on WhatsApp (free). wa.me cannot attach files.
  static Future<void> sendInvoicePdf({
    required BuildContext context,
    required InvoiceModel invoice,
  }) async {
    final s = AppStrings.of(context);
    final locale = Localizations.localeOf(context).toString();
    final phone = invoice.bookingDetail?.customerDetail?.phone;
    if (waDigits(phone) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.whatsappNoCustomerPhone)),
      );
      return;
    }

    try {
      final bytes = await InvoicePdfBuilder.build(invoice, s);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/QuikGarage_Invoice_${invoice.id}.pdf');
      await file.writeAsBytes(bytes, flush: true);

      if (!context.mounted) return;
      final digits = waDigits(phone)!;
      final caption = invoiceMessage(invoice, s, locale: locale);

      if (Platform.isAndroid) {
        try {
          await _androidChannel.invokeMethod<bool>('sharePdf', {
            'path': file.path,
            'phone': digits,
            'text': caption,
          });
          return;
        } on PlatformException {
          // Fall back to the share sheet if WhatsApp intent is blocked.
        }
      }

      if (!context.mounted) return;

      final box = context.findRenderObject() as RenderBox?;
      final origin = box == null
          ? const Rect.fromLTWH(0, 0, 1, 1)
          : box.localToGlobal(Offset.zero) & box.size;

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/pdf')],
          text: invoiceMessage(invoice, s, locale: locale),
          title: s.whatsappPickToSendPdf,
          sharePositionOrigin: origin,
        ),
      );
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(s.invoicePdfFailed)),
        );
      }
    }
  }
}

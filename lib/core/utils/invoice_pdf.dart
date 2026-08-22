import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../l10n/app_strings.dart';
import '../../models/invoice_model.dart';
import 'date_utils.dart';

abstract final class InvoicePdfBuilder {
  static Future<List<int>> build(InvoiceModel invoice, AppStrings s) async {
    final booking = invoice.bookingDetail;
    final garage = booking?.garageDetail;
    final customer = booking?.customerDetail;
    final vehicle = booking?.vehicleDetail;
    final date = invoice.createdAt ?? DateTime.now();
    final dateLabel = DateFormat('d MMM yyyy').format(date.toLocal());
    final schedule = booking == null
        ? '-'
        : AppDateUtils.formatBookingDateTime(
            booking.bookingDate,
            booking.timeSlot,
          );

    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'QuikGarage',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromInt(0xFF0B7A3A),
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                garage?.garageName ?? 'Vehicle service invoice',
                style: const pw.TextStyle(fontSize: 14),
              ),
              if (garage != null && garage.address.isNotEmpty)
                pw.Text(
                  garage.address,
                  style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'INVOICE #${invoice.id}',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(dateLabel),
                ],
              ),
              pw.Divider(),
              pw.SizedBox(height: 12),
              _kv('Bill to', (customer?.name.isNotEmpty == true)
                  ? customer!.name
                  : (customer?.phone ?? '-')),
              _kv('Phone', customer?.phone ?? '-'),
              _kv(
                'Vehicle',
                vehicle == null
                    ? '-'
                    : '${vehicle.displayName}  ${vehicle.vehicleNumber}',
              ),
              if (booking != null)
                _kv('Service', s.serviceType(booking.serviceType)),
              _kv('Schedule', schedule),
              if (booking != null)
                _kv('Booking status', s.bookingStatus(booking.status)),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFFFFD200),
                ),
                cellAlignment: pw.Alignment.centerLeft,
                headers: const ['Description', 'Amount (INR)'],
                data: [
                  [s.serviceCost, invoice.serviceCost],
                  [s.partsCost, invoice.partsCost],
                  [s.total, invoice.totalAmount],
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                'Payment: ${s.paymentStatus(invoice.paymentStatus)}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Spacer(),
              pw.Divider(),
              pw.Text(
                'Thank you for choosing QuikGarage.',
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
              ),
              pw.Text(
                'Support: info@digiaarambh.com  |  +91 8605864047  |  +91 7020681301',
                style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
              ),
            ],
          );
        },
      ),
    );
    return doc.save();
  }

  static pw.Widget _kv(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              label,
              style: const pw.TextStyle(color: PdfColors.grey700, fontSize: 11),
            ),
          ),
          pw.Expanded(
            child: pw.Text(value, style: const pw.TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

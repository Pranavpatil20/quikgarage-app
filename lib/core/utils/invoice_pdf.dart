import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../l10n/app_strings.dart';
import '../../models/invoice_model.dart';
import '../constants/parts_catalog.dart';
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

    final lines = <ServiceLineItem>[];
    if (invoice.lineItems.isNotEmpty) {
      lines.addAll(
        invoice.lineItems
            .map((e) => ServiceLineItem.fromJson(Map<String, dynamic>.from(e))),
      );
    } else {
      lines.add(
        ServiceLineItem(
          name: s.serviceCost,
          category: 'labour',
          rate: double.tryParse(invoice.serviceCost) ?? 0,
        ),
      );
      lines.add(
        ServiceLineItem(
          name: s.partsCost,
          category: 'parts',
          rate: double.tryParse(invoice.partsCost) ?? 0,
        ),
      );
    }
    if (!lines.any((e) => e.category.toLowerCase() == 'labour')) {
      final serviceAmt = double.tryParse(invoice.serviceCost) ?? 0;
      final rawType = booking?.serviceType.trim() ?? '';
      lines.insert(
        0,
        ServiceLineItem(
          name: rawType.isNotEmpty ? rawType : s.serviceCost,
          category: 'labour',
          rate: serviceAmt,
        ),
      );
    }

    final tableData = lines
        .map(
          (l) => [
            l.name,
            l.category,
            l.qty.toStringAsFixed(l.qty == l.qty.roundToDouble() ? 0 : 1),
            l.rate.toStringAsFixed(2),
            l.amount.toStringAsFixed(2),
          ],
        )
        .toList();

    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (context) {
          return [
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
            pw.SizedBox(height: 16),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'INVOICE #${invoice.id}',
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(dateLabel),
              ],
            ),
            pw.Divider(),
            pw.SizedBox(height: 10),
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
              _kv('Service', s.serviceType(
                booking.serviceType,
                vehicleType: vehicle?.vehicleType,
              )),
            _kv('Schedule', schedule),
            if (booking != null)
              _kv('Booking status', s.bookingStatus(booking.status)),
            pw.SizedBox(height: 16),
            pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColor.fromInt(0xFFFFD200),
              ),
              cellStyle: const pw.TextStyle(fontSize: 9),
              cellAlignment: pw.Alignment.centerLeft,
              headers: const [
                'Description',
                'Cat',
                'Qty',
                'Rate',
                'Amount',
              ],
              data: tableData,
            ),
            pw.SizedBox(height: 12),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Labour / Service: Rs.${invoice.serviceCost}'),
                  pw.Text('Parts / Lubricant: Rs.${invoice.partsCost}'),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    '${s.total}: Rs.${invoice.totalAmount}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 12),
            pw.Text(
              'Payment: ${s.paymentStatus(invoice.paymentStatus)}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 24),
            pw.Divider(),
            pw.Text(
              'Thank you for choosing QuikGarage.',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            ),
            pw.Text(
              'Support: info@digiaarambh.com  |  +91 8605864047  |  +91 7020681301',
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            ),
          ];
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

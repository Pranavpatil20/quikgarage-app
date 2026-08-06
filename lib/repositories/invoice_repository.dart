import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/api_constants.dart';
import '../models/invoice_model.dart';
import '../services/api_client.dart';

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  return InvoiceRepository(ref.watch(dioProvider));
});

class InvoiceRepository {
  InvoiceRepository(this._dio);

  final Dio _dio;

  Future<List<InvoiceModel>> getInvoices({String? paymentStatus}) async {
    final response = await _dio.get(
      ApiConstants.invoices,
      queryParameters: paymentStatus != null ? {'payment_status': paymentStatus} : null,
    );
    final data = response.data;
    if (data is Map && data['results'] is List) {
      return (data['results'] as List)
          .map((e) => InvoiceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (data is List) {
      return data.map((e) => InvoiceModel.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<InvoiceModel> createInvoice(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiConstants.invoices, data: data);
    return InvoiceModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<InvoiceModel> updateInvoice(int id, Map<String, dynamic> data) async {
    final response = await _dio.patch('${ApiConstants.invoices}$id/', data: data);
    return InvoiceModel.fromJson(response.data as Map<String, dynamic>);
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/invoice_model.dart';
import '../../repositories/invoice_repository.dart';
import 'auth_provider.dart';

final invoicesProvider = FutureProvider.autoDispose
    .family<List<InvoiceModel>, String?>((ref, paymentStatus) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return [];
  return ref.watch(invoiceRepositoryProvider).getInvoices(paymentStatus: paymentStatus);
});

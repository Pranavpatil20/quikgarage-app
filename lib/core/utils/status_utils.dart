import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../constants/app_constants.dart';

abstract final class StatusUtils {
  static String label(String status) {
    return AppConstants.bookingStatusLabels[status] ??
        AppConstants.paymentStatusLabels[status] ??
        status.replaceAll('_', ' ');
  }

  static Color statusColor(String status, {Brightness brightness = Brightness.light}) {
    final isDark = brightness == Brightness.dark;
    switch (status) {
      case 'pending':
        return isDark ? const Color(0xFFFBBF24) : AppColors.statusPending;
      case 'confirmed':
        return isDark ? const Color(0xFF60A5FA) : AppColors.statusConfirmed;
      case 'in_progress':
        return isDark ? const Color(0xFFA78BFA) : AppColors.statusInProgress;
      case 'completed':
      case 'paid':
        return isDark ? const Color(0xFF4ADE80) : AppColors.statusCompleted;
      case 'cancelled':
      case 'refunded':
        return isDark ? const Color(0xFFF87171) : AppColors.statusCancelled;
      case 'partial':
        return isDark ? const Color(0xFFFBBF24) : AppColors.statusPending;
      default:
        return isDark ? AppColors.darkOnSurfaceVariant : AppColors.onSurfaceVariant;
    }
  }

  static Color statusBackground(String status, {Brightness brightness = Brightness.light}) =>
      statusColor(status, brightness: brightness).withValues(alpha: brightness == Brightness.dark ? 0.22 : 0.12);

  static String serviceLabel(String type) =>
      AppConstants.serviceTypeLabels[type] ?? type;
}

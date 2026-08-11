import 'package:flutter/material.dart';

import '../../l10n/app_strings.dart';
import '../../models/booking_model.dart';
import '../utils/date_utils.dart';
import 'glass_card.dart';
import 'status_chip.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.booking,
    this.onTap,
    this.trailing,
  });

  final BookingModel booking;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = AppStrings.of(context);
    final locale = Localizations.localeOf(context).toString();
    final vehicle = booking.vehicleDetail;
    final customer = booking.customerDetail;
    final dateTimeText =
        '${AppDateUtils.formatDisplayDate(AppDateUtils.parseApiDate(booking.bookingDate), locale: locale)} · ${AppDateUtils.formatTime(booking.timeSlot, locale: locale)}';
    final serviceLabel = s.serviceType(booking.serviceType);

    return GlassCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle?.displayName ?? s.vehicleLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (vehicle != null)
                      Text(
                        vehicle.vehicleNumber,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    if (customer != null)
                      Text(
                        customer.name.isNotEmpty ? customer.name : customer.phone,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(child: StatusChip(status: booking.status)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  dateTimeText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  serviceLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: theme.textTheme.labelSmall,
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 4),
                trailing!,
              ],
            ],
          ),
        ],
      ),
    );
  }
}

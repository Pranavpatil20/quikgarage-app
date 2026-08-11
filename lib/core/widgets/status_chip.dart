import 'package:flutter/material.dart';

import '../../l10n/app_strings.dart';
import '../utils/status_utils.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status, this.icon});

  final String status;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final color = StatusUtils.statusColor(status, brightness: brightness);
    final s = AppStrings.of(context);
    final label = s.bookingStatus(status);
    final paymentFallback = s.paymentStatus(status);
    final display = label != status
        ? label
        : (paymentFallback != status ? paymentFallback : StatusUtils.label(status));

    return Container(
      constraints: const BoxConstraints(maxWidth: 140),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: StatusUtils.statusBackground(status, brightness: brightness),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              display,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

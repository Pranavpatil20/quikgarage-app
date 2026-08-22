import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/notification_provider.dart';
import '../../theme/app_colors.dart';

class NotificationBellButton extends ConsumerWidget {
  const NotificationBellButton({
    super.key,
    required this.onPressed,
    this.color = AppColors.onYellow,
  });

  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadCountProvider);
    return IconButton(
      visualDensity: VisualDensity.compact,
      onPressed: onPressed,
      icon: Badge(
        isLabelVisible: unread > 0,
        label: Text(unread > 9 ? '9+' : '$unread'),
        backgroundColor: AppColors.brandGreen,
        child: Icon(Icons.notifications_outlined, color: color),
      ),
    );
  }
}

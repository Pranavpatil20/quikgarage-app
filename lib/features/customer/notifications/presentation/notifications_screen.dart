import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/notification_provider.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../l10n/app_strings.dart';
import '../../../../repositories/notification_repository.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key, this.isOwner = false});

  final bool isOwner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final theme = Theme.of(context);
    final s = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.notifications),
        automaticallyImplyLeading: false,
        leading: isOwner
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/owner'),
              )
            : null,
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(notificationRepositoryProvider).markAllRead();
              ref.invalidate(notificationsProvider);
            },
            child: Text(s.markAllRead),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(notificationsProvider),
        ),
        data: (notifications) {
          if (notifications.isEmpty) {
            return Center(child: Text(s.noNotifications));
          }
          final isDark = theme.brightness == Brightness.dark;
          return ListView.separated(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              isOwner ? 16 : AppBottomNavBar.contentBottomPadding(context),
            ),
            itemCount: notifications.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final n = notifications[index];
              final unread = !n.readStatus;
              final scheme = theme.colorScheme;
              final cardColor = unread
                  ? scheme.primaryContainer.withValues(alpha: isDark ? 0.45 : 0.55)
                  : scheme.surfaceContainerHighest.withValues(alpha: isDark ? 0.35 : 0.65);
              final border = unread
                  ? scheme.primary.withValues(alpha: 0.55)
                  : scheme.outlineVariant.withValues(alpha: 0.7);

              return GlassCard(
                color: cardColor,
                borderColor: border,
                onTap: () async {
                  if (unread) {
                    await ref.read(notificationRepositoryProvider).markRead(n.id);
                    ref.invalidate(notificationsProvider);
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: unread ? scheme.primary : scheme.outlineVariant,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  n.title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight:
                                        unread ? FontWeight.w700 : FontWeight.w500,
                                    color: unread
                                        ? scheme.onPrimaryContainer
                                        : scheme.onSurface.withValues(alpha: 0.75),
                                  ),
                                ),
                              ),
                              if (unread)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: scheme.primary,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    'New',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: scheme.onPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            n.message,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: unread
                                  ? scheme.onSurface
                                  : scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

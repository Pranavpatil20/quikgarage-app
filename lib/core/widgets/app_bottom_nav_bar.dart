import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class AppBottomNavItem {
  const AppBottomNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.badgeCount = 0,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int badgeCount;
}

/// Floating pill nav — only the rounded capsule is opaque; no full-width back plate.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<AppBottomNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  /// Height of the floating capsule itself (excluding safe-area inset).
  static const double barHeight = 60;

  /// Extra scroll padding so last content clears the floating pill.
  static double contentBottomPadding(BuildContext context) {
    return barHeight + MediaQuery.viewPaddingOf(context).bottom + 28;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final barColor = isDark ? const Color(0xFF1A2332) : Colors.white;
    final borderColor = isDark
        ? AppColors.darkOutlineVariant.withValues(alpha: 0.8)
        : AppColors.primary.withValues(alpha: 0.10);
    final muted = isDark
        ? AppColors.darkOnSurfaceVariant
        : AppColors.onSurfaceVariant.withValues(alpha: 0.75);
    final selectedFg = isDark ? AppColors.onYellow : Colors.white;
    final selectedBg = isDark ? AppColors.brandYellow : AppColors.brandGreen;

    // No Material / no full-width colored SafeArea — only the inset pill paints.
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        0,
        16,
        MediaQuery.viewPaddingOf(context).bottom > 0
            ? MediaQuery.viewPaddingOf(context).bottom
            : 10,
      ),
      child: SizedBox(
        height: barHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final selected = index == selectedIndex;
              return Expanded(
                child: _NavTapTarget(
                  selected: selected,
                  label: item.label,
                  icon: selected ? item.selectedIcon : item.icon,
                  badgeCount: item.badgeCount,
                  selectedBg: selectedBg,
                  selectedFg: selectedFg,
                  muted: muted,
                  onTap: () => onSelected(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavTapTarget extends StatelessWidget {
  const _NavTapTarget({
    required this.selected,
    required this.label,
    required this.icon,
    required this.selectedBg,
    required this.selectedFg,
    required this.muted,
    required this.onTap,
    this.badgeCount = 0,
  });

  final bool selected;
  final String label;
  final IconData icon;
  final Color selectedBg;
  final Color selectedFg;
  final Color muted;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          height: AppBottomNavBar.barHeight,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              width: selected ? 52 : 40,
              height: 36,
              decoration: BoxDecoration(
                color: selected ? selectedBg : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Badge(
                isLabelVisible: badgeCount > 0,
                label: Text(badgeCount > 9 ? '9+' : '$badgeCount'),
                backgroundColor: AppColors.brandGreen,
                child: Icon(
                  icon,
                  size: 24,
                  color: selected ? selectedFg : muted,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.showBack = false,
  });

  final String? title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> actions;
  final bool showBack;

  @override
  Size get preferredSize => Size.fromHeight(subtitle != null ? 72 : 64);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      toolbarHeight: preferredSize.height,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).maybePop(),
            )
          : leading,
      title: title != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title!,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onYellow,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.onYellow.withValues(alpha: 0.7),
                    ),
                  ),
              ],
            )
          : null,
      actions: actions,
      centerTitle: false,
    );
  }
}

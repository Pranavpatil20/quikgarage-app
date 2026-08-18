import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// QuikGarage mark — Blinkit yellow badge with the garage + bolt logo.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 72,
    this.showWordmark = false,
    this.darkText = true,
  });

  final double size;
  final bool showWordmark;
  final bool darkText;

  @override
  Widget build(BuildContext context) {
    final mark = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.brandYellow,
        borderRadius: BorderRadius.circular(size * 0.22),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/images/app_logo.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.high,
        errorBuilder: (_, _, _) => ColoredBox(
          color: AppColors.brandYellow,
          child: Icon(
            Icons.garage_rounded,
            size: size * 0.56,
            color: AppColors.brandGreenDark,
          ),
        ),
      ),
    );

    if (!showWordmark) return mark;

    final titleColor = darkText ? AppColors.onYellow : Colors.white;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        mark,
        SizedBox(height: size * 0.18),
        Text(
          'QuikGarage',
          style: TextStyle(
            fontSize: size * 0.32,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
            color: titleColor,
          ),
        ),
      ],
    );
  }
}

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/user_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../theme/app_colors.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Wake the API early so login/signup are less likely to hit a cold-start timeout.
    unawaited(_warmApi());

    // Wait until auth finishes initial load (max ~3s), then route once.
    final deadline = DateTime.now().add(const Duration(seconds: 3));
    while (mounted &&
        ref.read(authStateProvider).isLoading &&
        DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }
    // Short brand beat — keep splash snappy.
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (!mounted || _navigated) return;
    _goNext();
  }

  Future<void> _warmApi() async {
    try {
      final base = ApiConstants.baseUrl;
      final origin = base.replaceFirst(RegExp(r'/api/v1/?$'), '');
      await Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 90),
          receiveTimeout: const Duration(seconds: 90),
        ),
      ).get('$origin/health/');
    } catch (_) {
      // Best-effort warm-up only.
    }
  }

  void _goNext() {
    if (_navigated || !mounted) return;
    _navigated = true;
    final auth = ref.read(authStateProvider);
    final user = auth.valueOrNull;
    if (user == null) {
      context.go('/login');
    } else if (user.isOwner) {
      context.go(ownerHomeRoute(user));
    } else {
      context.go('/customer');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If auth resolves while splash is visible, navigate once.
    ref.listen(authStateProvider, (prev, next) {
      if (!next.isLoading && !_navigated) {
        _goNext();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.brandYellow,
      body: Stack(
        children: [
          CustomPaint(
            painter: _DotPatternPainter(),
            size: Size.infinite,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: Tween(begin: 0.7, end: 1.0).animate(_controller),
                  child: const AppLogo(size: 104),
                ),
                const SizedBox(height: 20),
                Text(
                  'QuikGarage',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppColors.onYellow,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppConstants.tagline,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onYellow.withValues(alpha: 0.72),
                      ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.brandGreen.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.brandGreen.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt_rounded, size: 16, color: AppColors.brandGreenDark),
                      const SizedBox(width: 8),
                      Text(
                        'FAST VEHICLE SERVICE',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.brandGreenDark,
                              letterSpacing: 1.4,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 48,
                  child: LinearProgressIndicator(
                    backgroundColor: AppColors.brandGreen.withValues(alpha: 0.18),
                    color: AppColors.brandGreen,
                    minHeight: 3,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.brandGreen.withValues(alpha: 0.08);
    const spacing = 32.0;
    for (var x = 0.0; x < size.width; x += spacing) {
      for (var y = 0.0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

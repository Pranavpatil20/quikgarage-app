import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class BikeServiceCarousel extends StatefulWidget {
  const BikeServiceCarousel({
    super.key,
    required this.images,
    this.height = 210,
  });

  const BikeServiceCarousel.customer({super.key, this.height = 210})
      : images = const [
          'assets/images/bike_service_1.jpg',
          'assets/images/bike_service_2.jpg',
          'assets/images/bike_service_3.jpg',
          'assets/images/bike_service_4.jpg',
        ];

  const BikeServiceCarousel.owner({super.key, this.height = 210})
      : images = const [
          'assets/images/owner_garage_2.jpg',
          'assets/images/owner_garage_3.jpg',
          'assets/images/owner_garage_1.jpg',
          'assets/images/owner_garage_4.jpg',
        ];

  final List<String> images;
  final double height;

  @override
  State<BikeServiceCarousel> createState() => _BikeServiceCarouselState();
}

class _BikeServiceCarouselState extends State<BikeServiceCarousel> {
  final _pageController = PageController();
  int _index = 0;
  Timer? _timer;

  List<String> get _images => widget.images;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_pageController.hasClients || _images.isEmpty) return;
      final next = (_index + 1) % _images.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: widget.height,
            width: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _images.length,
              onPageChanged: (i) => setState(() => _index = i),
              itemBuilder: (context, i) {
                return Image.asset(
                  _images[i],
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => ColoredBox(
                    color: theme.colorScheme.primaryContainer,
                    child: Icon(
                      Icons.two_wheeler,
                      size: 64,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_images.length, (i) {
            final active = i == _index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 8,
              width: active ? 22 : 8,
              decoration: BoxDecoration(
                color: active
                    ? AppColors.brandGreen
                    : theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(8),
              ),
            );
          }),
        ),
      ],
    );
  }
}

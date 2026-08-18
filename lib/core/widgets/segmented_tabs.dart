import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Production-style filter chips: single-line labels, horizontal scroll.
/// First chip stays left-aligned (no empty left gap). Later chips scroll
/// toward center so previous/next remain tappable.
class SegmentedTabs extends StatefulWidget {
  const SegmentedTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  State<SegmentedTabs> createState() => _SegmentedTabsState();
}

class _SegmentedTabsState extends State<SegmentedTabs> {
  final ScrollController _scrollController = ScrollController();
  late List<GlobalKey> _itemKeys;

  @override
  void initState() {
    super.initState();
    _itemKeys = List.generate(widget.tabs.length, (_) => GlobalKey());
    WidgetsBinding.instance.addPostFrameCallback((_) => _alignSelected());
  }

  @override
  void didUpdateWidget(covariant SegmentedTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabs.length != widget.tabs.length) {
      _itemKeys = List.generate(widget.tabs.length, (_) => GlobalKey());
    }
    if (oldWidget.selectedIndex != widget.selectedIndex ||
        oldWidget.tabs != widget.tabs) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _alignSelected());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _alignSelected() async {
    if (!mounted) return;
    final index = widget.selectedIndex;
    if (index < 0 || index >= _itemKeys.length) return;

    // First chip: keep flush left — no center scroll / no left empty space.
    if (index == 0) {
      if (_scrollController.hasClients) {
        await _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
        );
      }
      return;
    }

    final ctx = _itemKeys[index].currentContext;
    if (ctx == null) return;

    // Middle/last chips: bring into center so neighbors stay visible.
    await Scrollable.ensureVisible(
      ctx,
      alignment: 0.5,
      alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _onTap(int index) {
    widget.onChanged(index);
    WidgetsBinding.instance.addPostFrameCallback((_) => _alignSelected());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        // No large left inset — first chip sits at the start.
        // Light right inset so last chips can still scroll into view.
        padding: const EdgeInsets.only(right: 48),
        itemCount: widget.tabs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = index == widget.selectedIndex;
          return KeyedSubtree(
            key: _itemKeys[index],
            child: Material(
              color: selected ? AppColors.brandGreen : scheme.surfaceContainerHighest,
              elevation: selected ? 1 : 0,
              shadowColor: scheme.primary.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(22),
              child: InkWell(
                onTap: () => _onTap(index),
                borderRadius: BorderRadius.circular(22),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  child: Text(
                    widget.tabs[index],
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                      letterSpacing: 0.1,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

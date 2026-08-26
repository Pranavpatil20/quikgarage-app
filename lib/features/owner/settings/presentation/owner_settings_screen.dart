import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/support_contact.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/garage_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/app_overlays.dart';
import '../../../../core/widgets/brand_header.dart';
import '../../../../core/widgets/support_contact_card.dart';
import '../../../../l10n/app_strings.dart';
import '../../../../theme/app_colors.dart';
import '../../../../models/garage_model.dart';
import '../../../../core/widgets/mic_text_field.dart';
import '../../../../repositories/garage_repository.dart';
import '../../../../repositories/user_repository.dart';
import 'rates_settings_screen.dart';

class OwnerSettingsScreen extends ConsumerStatefulWidget {
  const OwnerSettingsScreen({super.key});

  @override
  ConsumerState<OwnerSettingsScreen> createState() => _OwnerSettingsScreenState();
}

class _OwnerSettingsScreenState extends ConsumerState<OwnerSettingsScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _garageNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _serviceCostController = TextEditingController();
  TimeOfDay _opening = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _closing = const TimeOfDay(hour: 18, minute: 0);
  /// Per weekday: open flag + optional day-specific hours.
  final Map<String, _DayAvailability> _weekly = {
    for (final key in kWeekdayKeys) key: _DayAvailability(open: true),
  };
  bool _saving = false;
  bool _savingProfile = false;
  bool _fieldsHydrated = false;
  int? _hydratedUserId;
  int? _hydratedGarageId;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _garageNameController.dispose();
    _addressController.dispose();
    _serviceCostController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_hydrateProfile);
  }

  void _hydrateProfile() {
    final user = ref.read(authStateProvider).value;
    if (user == null || !mounted) return;
    setState(() {
      _nameController.text = user.name;
      _phoneController.text = user.phone;
      _hydratedUserId = user.id;
    });
  }

  void _hydrateGarage(GarageModel garage) {
    _garageNameController.text = garage.garageName;
    _addressController.text = garage.address;
    _opening = _parseTime(garage.openingTime);
    _closing = _parseTime(garage.closingTime);
    _serviceCostController.text = garage.displayServiceCost;
    for (final key in kWeekdayKeys) {
      final day = garage.weeklyHours[key];
      if (day is Map) {
        final open = day['open'];
        final isOpen = open is bool
            ? open
            : !(open is String &&
                (open.toLowerCase() == 'false' || open == '0'));
        _weekly[key] = _DayAvailability(
          open: isOpen,
          opening: day['opening_time'] != null
              ? _parseTime(day['opening_time'].toString())
              : null,
          closing: day['closing_time'] != null
              ? _parseTime(day['closing_time'].toString())
              : null,
        );
      } else {
        _weekly[key] = _DayAvailability(open: true);
      }
    }
    _fieldsHydrated = true;
    _hydratedGarageId = garage.id;
  }

  Map<String, dynamic> _weeklyHoursPayload() {
    final map = <String, dynamic>{};
    for (final key in kWeekdayKeys) {
      final day = _weekly[key]!;
      if (!day.open) {
        map[key] = {'open': false};
        continue;
      }
      final entry = <String, dynamic>{'open': true};
      final open = day.opening ?? _opening;
      final close = day.closing ?? _closing;
      // Only send day-specific times when they differ from garage defaults
      // or when explicitly set.
      if (day.opening != null || day.closing != null) {
        entry['opening_time'] = _formatApiTime(open);
        entry['closing_time'] = _formatApiTime(close);
      }
      map[key] = entry;
    }
    return map;
  }

  TimeOfDay _parseTime(String value) {
    final parts = value.split(':');
    if (parts.length < 2) return const TimeOfDay(hour: 9, minute: 0);
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 9,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }

  String _formatApiTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00';

  String _normalizeCost(String raw) {
    final parsed = double.tryParse(raw.trim().replaceAll(',', ''));
    if (parsed == null) return '';
    return parsed.toStringAsFixed(2);
  }

  Future<void> _saveProfile() async {
    final s = AppStrings.of(context);
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.enterName)));
      return;
    }
    setState(() => _savingProfile = true);
    try {
      final user = await ref.read(userRepositoryProvider).updateProfile(name: name);
      ref.read(authStateProvider.notifier).setUser(user);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.profileUpdated)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _savingProfile = false);
    }
  }

  Future<void> _createGarage() async {
    final s = AppStrings.of(context);
    final name = _garageNameController.text.trim();
    final address = _addressController.text.trim();
    final cost = _normalizeCost(_serviceCostController.text);
    if (name.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.enterGarageDetails)));
      return;
    }
    if (cost.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.enterValidAmount)));
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(garageRepositoryProvider).createGarage({
        'garage_name': name,
        'address': address,
        'opening_time': _formatApiTime(_opening),
        'closing_time': _formatApiTime(_closing),
        'weekly_hours': _weeklyHoursPayload(),
        'default_service_cost': cost,
      });
      _fieldsHydrated = false;
      ref.invalidate(myGarageProvider);
      ref.invalidate(garagesProvider);
      if (mounted) {
        Navigator.of(context).maybePop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.garageCreated)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _saveGarage(int id) async {
    final s = AppStrings.of(context);
    final name = _garageNameController.text.trim();
    final address = _addressController.text.trim();
    final cost = _normalizeCost(_serviceCostController.text);
    if (name.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.enterGarageDetails)));
      return;
    }
    if (cost.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.enterValidAmount)));
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(garageRepositoryProvider).updateGarage(id, {
        'garage_name': name,
        'address': address,
        'opening_time': _formatApiTime(_opening),
        'closing_time': _formatApiTime(_closing),
        'weekly_hours': _weeklyHoursPayload(),
        'default_service_cost': cost,
      });
      _fieldsHydrated = false;
      ref.invalidate(myGarageProvider);
      ref.invalidate(garagesProvider);
      if (mounted) {
        Navigator.of(context).maybePop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.garageUpdated)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _showLanguagePicker() async {
    final s = AppStrings.of(context);
    final current = ref.read(localeProvider);
    await showAppModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Text(s.selectLanguage, style: Theme.of(ctx).textTheme.titleMedium),
                ),
                ...AppLanguage.values.map((lang) {
                  return ListTile(
                    leading: Icon(
                      current == lang ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: Theme.of(ctx).colorScheme.primary,
                    ),
                    title: Text(lang.label),
                    onTap: () async {
                      await ref.read(localeProvider.notifier).setLanguage(lang);
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                  );
                }),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showEditProfileSheet() async {
    final s = AppStrings.of(context);
    final theme = Theme.of(context);
    await showAppModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.viewInsetsOf(ctx).bottom + 24,
            top: 8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(s.editProfile, style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              MicTextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: s.yourName,
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                enabled: false,
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: s.phone,
                  prefixIcon: const Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _savingProfile
                    ? null
                    : () async {
                        await _saveProfile();
                        if (ctx.mounted) Navigator.pop(ctx);
                      },
                child: _savingProfile
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(s.saveProfile),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showGarageEditor({GarageModel? garage}) async {
    final s = AppStrings.of(context);
    final theme = Theme.of(context);
    final isCreate = garage == null;

    if (garage != null) {
      _hydrateGarage(garage);
    } else if (!_fieldsHydrated) {
      _garageNameController.clear();
      _addressController.clear();
      _serviceCostController.text = '899';
      _opening = const TimeOfDay(hour: 9, minute: 0);
      _closing = const TimeOfDay(hour: 20, minute: 0);
      for (final key in kWeekdayKeys) {
        _weekly[key] = _DayAvailability(open: true);
      }
    }

    await showAppModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.viewInsetsOf(ctx).bottom + 24,
                top: 8,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      isCreate ? s.createYourGarage : s.editGarage,
                      style: theme.textTheme.titleLarge,
                    ),
                    if (isCreate) ...[
                      const SizedBox(height: 8),
                      Text(
                        s.createGarageHint,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    MicTextField(
                      controller: _garageNameController,
                      decoration: InputDecoration(
                        labelText: s.garageName,
                        prefixIcon: const Icon(Icons.store),
                      ),
                    ),
                    const SizedBox(height: 12),
                    MicTextField(
                      controller: _addressController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: s.address,
                        prefixIcon: const Icon(Icons.location_on),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _serviceCostController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      decoration: InputDecoration(
                        labelText: s.generalServiceAmount,
                        helperText: s.generalServiceHint,
                        prefixText: '₹ ',
                        prefixIcon: const Icon(Icons.payments_outlined),
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(s.openingTime),
                      subtitle: Text(_opening.format(ctx)),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final t = await showTimePicker(context: ctx, initialTime: _opening);
                        if (t != null) setSheetState(() => _opening = t);
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(s.closingTime),
                      subtitle: Text(_closing.format(ctx)),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final t = await showTimePicker(context: ctx, initialTime: _closing);
                        if (t != null) setSheetState(() => _closing = t);
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Weekly availability',
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      'Turn off a day to block customer bookings. You can set different hours per day.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...kWeekdayKeys.map((key) {
                      final day = _weekly[key]!;
                      final openTime = day.opening ?? _opening;
                      final closeTime = day.closing ?? _closing;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(kWeekdayLabels[key] ?? key),
                              subtitle: Text(
                                day.open
                                    ? '${openTime.format(ctx)} – ${closeTime.format(ctx)}'
                                    : 'Closed — customers cannot book',
                              ),
                              value: day.open,
                              onChanged: (v) => setSheetState(() {
                                _weekly[key] = day.copyWith(open: v);
                              }),
                            ),
                            if (day.open)
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () async {
                                        final t = await showTimePicker(
                                          context: ctx,
                                          initialTime: openTime,
                                        );
                                        if (t != null) {
                                          setSheetState(() {
                                            final current = _weekly[key]!;
                                            _weekly[key] =
                                                current.copyWith(opening: t);
                                          });
                                        }
                                      },
                                      child: Text('Open ${openTime.format(ctx)}'),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () async {
                                        final t = await showTimePicker(
                                          context: ctx,
                                          initialTime: closeTime,
                                        );
                                        if (t != null) {
                                          setSheetState(() {
                                            final current = _weekly[key]!;
                                            _weekly[key] =
                                                current.copyWith(closing: t);
                                          });
                                        }
                                      },
                                      child: Text('Close ${closeTime.format(ctx)}'),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _saving
                          ? null
                          : () {
                              if (isCreate) {
                                _createGarage();
                              } else {
                                _saveGarage(garage.id);
                              }
                            },
                      child: _saving
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(isCreate ? s.createGarage : s.saveGarage),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSupport() {
    final s = AppStrings.of(context);
    showAppDialog<void>(
      context: context,
      builder: (ctx) {
        final width = MediaQuery.sizeOf(ctx).width;
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          title: Text(s.supportFeedback),
          content: SizedBox(
            width: width,
            child: const SingleChildScrollView(child: SupportContactCard()),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(s.cancel)),
          ],
        );
      },
    );
  }

  Widget _sectionLabel(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          letterSpacing: 1.2,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _settingsCard({required List<Widget> children}) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerLowest,
      elevation: 0.5,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }

  Widget _settingsRow({
    required Color iconBg,
    required Color iconColor,
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? titleColor,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: titleColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.outlineVariant,
                ),
          ],
        ),
      ),
    );
  }

  Widget _garageProfileCard(GarageModel garage, AppStrings s, ThemeData theme) {
    return _settingsCard(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.outlineVariant),
                      color: theme.colorScheme.surfaceContainerHigh,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Icon(
                        Icons.garage_outlined,
                        size: 40,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -6,
                    bottom: -6,
                    child: Material(
                      color: theme.colorScheme.primary,
                      shape: const CircleBorder(),
                      elevation: 2,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => _showGarageEditor(garage: garage),
                        child: const SizedBox(
                          width: 32,
                          height: 32,
                          child: Icon(Icons.edit, size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      garage.garageName,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _pill(
                          theme,
                          icon: Icons.schedule,
                          label: garage.formattedHours,
                        ),
                        _pill(
                          theme,
                          icon: Icons.payments_outlined,
                          label: s.avgServiceCost(garage.displayServiceCost),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _pill(ThemeData theme, {required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyGarageCard(AppStrings s, ThemeData theme) {
    return _settingsCard(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(Icons.storefront_outlined, size: 40, color: theme.colorScheme.primary),
              const SizedBox(height: 12),
              Text(s.noGarageYet, style: theme.textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(
                s.setUpGarageCta,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _showGarageEditor(),
                child: Text(s.createGarage),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    final garageAsync = ref.watch(myGarageProvider);
    final themeMode = ref.watch(themeModeProvider);
    final language = ref.watch(localeProvider);
    final theme = Theme.of(context);
    final s = AppStrings.of(context);

    if (user != null) {
      final shouldHydrate = _hydratedUserId != user.id ||
          (_nameController.text.isEmpty && user.name.isNotEmpty);
      if (shouldHydrate) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() {
            _nameController.text = user.name;
            _phoneController.text = user.phone;
            _hydratedUserId = user.id;
          });
        });
      }
    }

    return Scaffold(
      body: Column(
        children: [
          BrandHeader(
            child: Row(
              children: [
                const AppLogo(size: 32),
                const SizedBox(width: 10),
                Text(
                  s.appName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.onYellow,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.brandGreen.withValues(alpha: 0.18),
                  child: Text(
                    (user?.name.isNotEmpty == true)
                        ? user!.name.trim()[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: AppColors.brandGreenDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  AppBottomNavBar.contentBottomPadding(context),
                ),
                children: [
                  _sectionLabel(s.garageProfile, theme),
                  garageAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (_, _) => _emptyGarageCard(s, theme),
                    data: (garage) {
                      if (!_fieldsHydrated || _hydratedGarageId != garage.id) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!mounted) return;
                          setState(() => _hydrateGarage(garage));
                        });
                      }
                      return _garageProfileCard(garage, s, theme);
                    },
                  ),
                  const SizedBox(height: 28),
                  _sectionLabel(s.appSettings, theme),
                  _settingsCard(
                    children: [
                      _settingsRow(
                        iconBg: theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
                        iconColor: theme.colorScheme.primary,
                        icon: Icons.currency_rupee,
                        title: 'Rates',
                        subtitle: 'Default prices for services & parts',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const RatesSettingsScreen(),
                            ),
                          );
                        },
                      ),
                      Divider(height: 1, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35)),
                      _settingsRow(
                        iconBg: theme.colorScheme.primaryContainer.withValues(alpha: 0.35),
                        iconColor: theme.colorScheme.primary,
                        icon: Icons.translate,
                        title: s.language,
                        subtitle: s.languageSubtitle,
                        onTap: _showLanguagePicker,
                      ),
                      Divider(height: 1, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35)),
                      _settingsRow(
                        iconBg: const Color(0xFFFFDF93),
                        iconColor: const Color(0xFF765B00),
                        icon: Icons.dark_mode_outlined,
                        title: s.appearance,
                        subtitle: s.appearanceSubtitle,
                        trailing: Switch(
                          value: themeMode == AppThemeMode.dark,
                          onChanged: (enabled) {
                            ref.read(themeModeProvider.notifier).setDark(enabled);
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 8),
                    child: Text(
                      language.label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _sectionLabel(s.account, theme),
                  _settingsCard(
                    children: [
                      _settingsRow(
                        iconBg: theme.colorScheme.secondaryContainer,
                        iconColor: theme.colorScheme.secondary,
                        icon: Icons.badge_outlined,
                        title: s.editProfile,
                        onTap: _showEditProfileSheet,
                      ),
                      Divider(height: 1, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35)),
                      _settingsRow(
                        iconBg: theme.colorScheme.surfaceContainerHigh,
                        iconColor: theme.colorScheme.onSurfaceVariant,
                        icon: Icons.help_outline,
                        title: s.supportFeedback,
                        onTap: _showSupport,
                      ),
                      Divider(height: 1, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35)),
                      _settingsRow(
                        iconBg: theme.colorScheme.errorContainer.withValues(alpha: 0.5),
                        iconColor: theme.colorScheme.error,
                        icon: Icons.logout,
                        title: s.logout,
                        titleColor: theme.colorScheme.error,
                        trailing: const SizedBox.shrink(),
                        onTap: () async {
                          await ref.read(authStateProvider.notifier).signOut();
                          if (context.mounted) context.go('/login');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      '${s.versionLabel} ${SupportContact.appVersion}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
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

class _DayAvailability {
  const _DayAvailability({
    required this.open,
    this.opening,
    this.closing,
  });

  final bool open;
  final TimeOfDay? opening;
  final TimeOfDay? closing;

  _DayAvailability copyWith({
    bool? open,
    TimeOfDay? opening,
    TimeOfDay? closing,
  }) {
    return _DayAvailability(
      open: open ?? this.open,
      opening: opening ?? this.opening,
      closing: closing ?? this.closing,
    );
  }
}

class OwnerGarageSetupScreen extends ConsumerStatefulWidget {
  const OwnerGarageSetupScreen({super.key});

  @override
  ConsumerState<OwnerGarageSetupScreen> createState() => _OwnerGarageSetupScreenState();
}

class _OwnerGarageSetupScreenState extends ConsumerState<OwnerGarageSetupScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _serviceCostController = TextEditingController(text: '899');
  TimeOfDay _opening = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _closing = const TimeOfDay(hour: 18, minute: 0);
  bool _loading = false;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(_redirectIfGarageExists);
  }

  Future<void> _redirectIfGarageExists() async {
    try {
      await ref.read(garageRepositoryProvider).getMyGarage();
      if (mounted) context.go('/owner');
    } catch (_) {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _serviceCostController.dispose();
    super.dispose();
  }

  String _formatApiTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00';

  Future<void> _create() async {
    final s = AppStrings.of(context);
    final name = _nameController.text.trim();
    final address = _addressController.text.trim();
    final costRaw = _serviceCostController.text.trim().replaceAll(',', '');
    final cost = double.tryParse(costRaw);
    if (name.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.enterGarageDetails)));
      return;
    }
    if (cost == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.enterValidAmount)));
      return;
    }
    setState(() => _loading = true);
    try {
      await ref.read(garageRepositoryProvider).createGarage({
        'garage_name': name,
        'address': address,
        'opening_time': _formatApiTime(_opening),
        'closing_time': _formatApiTime(_closing),
        'default_service_cost': cost.toStringAsFixed(2),
      });
      ref.invalidate(myGarageProvider);
      ref.invalidate(garagesProvider);
      if (mounted) context.go('/owner');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = AppStrings.of(context);

    if (_checking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(s.createYourGarage),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.garage, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              s.setUpGarageCta,
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              s.createGarageHint,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            MicTextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: s.garageName,
                hintText: 'e.g. Raj Garage',
                prefixIcon: const Icon(Icons.store),
              ),
            ),
            const SizedBox(height: 16),
            MicTextField(
              controller: _addressController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: s.address,
                hintText: 'Full garage address',
                prefixIcon: const Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _serviceCostController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              decoration: InputDecoration(
                labelText: s.generalServiceAmount,
                helperText: s.generalServiceHint,
                prefixText: '₹ ',
                prefixIcon: const Icon(Icons.payments_outlined),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(s.openingTime),
              subtitle: Text(_opening.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final t = await showTimePicker(context: context, initialTime: _opening);
                if (t != null) setState(() => _opening = t);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(s.closingTime),
              subtitle: Text(_closing.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final t = await showTimePicker(context: context, initialTime: _closing);
                if (t != null) setState(() => _closing = t);
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _loading ? null : _create,
              child: _loading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(s.createGarage),
            ),
            TextButton(
              onPressed: () => context.go('/owner'),
              child: Text(s.cancel),
            ),
          ],
        ),
      ),
    );
  }
}

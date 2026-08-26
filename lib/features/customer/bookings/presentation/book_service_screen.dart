import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/booking_provider.dart';
import '../../../../core/providers/garage_provider.dart';
import '../../../../core/providers/vehicle_provider.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_overlays.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../l10n/app_strings.dart';
import '../../../../models/garage_model.dart';
import '../../../../models/vehicle_model.dart';
import '../../../../repositories/booking_repository.dart';
import '../../../../core/widgets/mic_text_field.dart';
import '../../../../repositories/vehicle_repository.dart';

class BookServiceScreen extends ConsumerStatefulWidget {
  const BookServiceScreen({super.key});

  @override
  ConsumerState<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends ConsumerState<BookServiceScreen> {
  int? _selectedVehicleId;
  int? _selectedGarageId;
  final Set<String> _selectedServiceTypes = {'general_service'};
  DateTime _selectedDate = DateTime.now();
  String? _selectedSlot;
  final _notesController = TextEditingController();
  bool _loading = false;
  bool _didAutoSelectVehicle = false;
  bool _didAutoSelectGarage = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _ensureVehicleSelection(List<VehicleModel> vehicles) {
    if (vehicles.isEmpty) return;
    if (_selectedVehicleId != null &&
        vehicles.any((v) => v.id == _selectedVehicleId)) {
      return;
    }
    final primary = vehicles.where((v) => v.isPrimary);
    final pick = primary.isNotEmpty ? primary.first : vehicles.first;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _selectedVehicleId = pick.id;
        _didAutoSelectVehicle = true;
      });
    });
  }

  void _ensureGarageSelection(List<GarageModel> garages) {
    if (garages.isEmpty) return;
    if (_selectedGarageId != null &&
        garages.any((g) => g.id == _selectedGarageId)) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _selectedGarageId = garages.first.id;
        _didAutoSelectGarage = true;
        _selectedSlot = null;
      });
    });
  }

  String? _validationMessage(AppStrings s) {
    if (_selectedVehicleId == null) return s.pleaseSelectVehicle;
    if (_selectedGarageId == null) return s.pleaseSelectGarage;
    if (_selectedServiceTypes.isEmpty) return 'Please select at least one service type';
    if (_selectedSlot == null) return s.pleaseSelectTimeSlot;
    return null;
  }

  String _normalizeTimeSlot(String slot) {
    final parts = slot.split(':');
    if (parts.length >= 3) return slot;
    if (parts.length == 2) return '$slot:00';
    return slot;
  }

  bool _isSlotInPast(String slotTime) {
    final parts = slotTime.split(':');
    if (parts.length < 2) return false;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1].split('.').first) ?? 0;
    return !AppDateUtils.isDateTimeInFuture(
      _selectedDate,
      TimeOfDay(hour: hour, minute: minute),
    );
  }

  GarageModel? _selectedGarage(List<GarageModel> garages) {
    if (_selectedGarageId == null) return null;
    for (final g in garages) {
      if (g.id == _selectedGarageId) return g;
    }
    return null;
  }

  DateTime _nextOpenDate(GarageModel garage, {DateTime? from}) {
    var day = from ?? DateTime.now();
    day = DateTime(day.year, day.month, day.day);
    for (var i = 0; i < 90; i++) {
      final candidate = day.add(Duration(days: i));
      if (garage.isOpenOnDate(candidate)) return candidate;
    }
    return day;
  }

  Future<void> _book() async {
    final s = AppStrings.of(context);
    final error = _validationMessage(s);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    if (_isSlotInPast(_selectedSlot!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a future time for today')),
      );
      return;
    }
    final garages = ref.read(garagesProvider).valueOrNull ?? [];
    final garage = _selectedGarage(garages);
    setState(() => _loading = true);
    try {
      await ref.read(bookingRepositoryProvider).createBooking({
        'garage': _selectedGarageId,
        'vehicle': _selectedVehicleId,
        'service_type': _selectedServiceTypes.join(','),
        'booking_date': AppDateUtils.toApiDate(_selectedDate),
        'time_slot': _normalizeTimeSlot(_selectedSlot!),
        'notes': _notesController.text.trim(),
      });
      refreshBookings(ref);
      if (mounted) {
        await showAppDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(s.bookingConfirmed),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  garage?.garageName ?? 'Garage',
                  style: Theme.of(ctx).textTheme.titleMedium,
                ),
                if (garage != null && garage.address.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(garage.address),
                ],
                if (garage?.ownerPhone != null &&
                    garage!.ownerPhone!.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Owner phone: ${garage.ownerPhone}'),
                ],
              ],
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        if (mounted) context.go('/customer/bookings');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = AppStrings.of(context);
    final locale = Localizations.localeOf(context).toString();
    final vehiclesAsync = ref.watch(vehiclesProvider);
    final garagesAsync = ref.watch(garagesProvider);
    final slotsAsync = _selectedGarageId != null
        ? ref.watch(
            availableSlotsProvider((
              garageId: _selectedGarageId!,
              date: AppDateUtils.toApiDate(_selectedDate),
            )),
          )
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(s.bookService),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/customer');
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(s.selectVehicle, style: theme.textTheme.headlineMedium),
                TextButton.icon(
                  onPressed: () => _showAddVehicle(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(s.addNew),
                ),
              ],
            ),
            const SizedBox(height: 12),
            vehiclesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text(e.toString()),
              data: (vehicles) {
                if (!_didAutoSelectVehicle ||
                    (_selectedVehicleId != null &&
                        !vehicles.any((v) => v.id == _selectedVehicleId))) {
                  _ensureVehicleSelection(vehicles);
                }
                if (vehicles.isEmpty) {
                  return GlassCard(
                    child: Text(
                      s.noVehiclesYetAdd,
                      style: theme.textTheme.bodyMedium,
                    ),
                  );
                }
                return SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: vehicles.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (_, i) {
                      final v = vehicles[i];
                      final selected = _selectedVehicleId == v.id;
                      return GestureDetector(
                        onTap: () => setState(() {
                          _selectedVehicleId = v.id;
                          final allowed =
                              AppConstants.serviceTypesForVehicle(v.vehicleType);
                          _selectedServiceTypes
                              .removeWhere((t) => !allowed.contains(t));
                          if (_selectedServiceTypes.isEmpty) {
                            _selectedServiceTypes.add('general_service');
                          }
                        }),
                        child: Container(
                          width: 200,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.outlineVariant,
                              width: selected ? 2 : 1,
                            ),
                            color: selected
                                ? theme.colorScheme.primaryContainer
                                    .withValues(alpha: 0.35)
                                : theme.colorScheme.surfaceContainerLowest,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                v.vehicleType == 'bike'
                                    ? Icons.two_wheeler
                                    : Icons.directions_car,
                                color: theme.colorScheme.primary,
                              ),
                              const Spacer(),
                              Text(
                                v.displayName,
                                style: theme.textTheme.titleLarge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                v.vehicleNumber,
                                style: theme.textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(s.selectGarage, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 12),
            garagesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text(e.toString()),
              data: (garages) {
                if (!_didAutoSelectGarage ||
                    (_selectedGarageId != null &&
                        !garages.any((g) => g.id == _selectedGarageId))) {
                  _ensureGarageSelection(garages);
                }
                if (garages.isEmpty) {
                  return GlassCard(
                    child: Text(
                      s.noGaragesAvailable,
                      style: theme.textTheme.bodyMedium,
                    ),
                  );
                }
                return Column(
                  children: garages.map((g) {
                    final selected = _selectedGarageId == g.id;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GlassCard(
                        onTap: () => setState(() {
                          _selectedGarageId = g.id;
                          _selectedSlot = null;
                          if (!g.isOpenOnDate(_selectedDate)) {
                            _selectedDate = _nextOpenDate(g);
                          }
                        }),
                        child: Row(
                          children: [
                            Icon(
                              selected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    g.garageName,
                                    style: theme.textTheme.titleLarge,
                                  ),
                                  Text(
                                    g.address,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(s.serviceTypeLabel, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text(
              'You can select more than one',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Builder(
              builder: (context) {
                final vehicles = ref.watch(vehiclesProvider).valueOrNull ?? [];
                final matched = vehicles.where((v) => v.id == _selectedVehicleId);
                final vehicleType =
                    matched.isEmpty ? 'bike' : matched.first.vehicleType;
                final types = AppConstants.serviceTypesForVehicle(vehicleType);
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: types.map((type) {
                    final selected = _selectedServiceTypes.contains(type);
                    return FilterChip(
                      label: Text(
                        s.serviceType(type, vehicleType: vehicleType),
                      ),
                      selected: selected,
                      onSelected: (v) => setState(() {
                        if (v) {
                          _selectedServiceTypes.add(type);
                        } else {
                          _selectedServiceTypes.remove(type);
                        }
                      }),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(s.selectDate),
              subtitle: Text(
                AppDateUtils.formatDisplayDate(_selectedDate, locale: locale),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final now = DateTime.now();
                final garages = garagesAsync.valueOrNull ?? [];
                final garage = _selectedGarage(garages);
                var initial = _selectedDate.isBefore(now) ? now : _selectedDate;
                if (garage != null && !garage.isOpenOnDate(initial)) {
                  initial = _nextOpenDate(garage, from: now);
                }
                final picked = await showDatePicker(
                  context: context,
                  initialDate: initial,
                  firstDate: DateTime(now.year, now.month, now.day),
                  lastDate: now.add(const Duration(days: 60)),
                  selectableDayPredicate: garage == null
                      ? null
                      : (day) => garage.isOpenOnDate(day),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                    _selectedSlot = null;
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            Text(s.timeSlots, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 12),
            if (_selectedGarageId == null)
              Text(
                s.selectGarageForSlots,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            else
              slotsAsync!.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text(e.toString()),
                data: (slots) {
                  if (slots.closed) {
                    return GlassCard(
                      child: Text(
                        'Garage is closed on this day. Please choose another date.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    );
                  }
                  final visible = slots.slots.where((slot) {
                    // Keep past slots out of the picker for today.
                    return !_isSlotInPast(slot.time);
                  }).toList();
                  if (visible.isEmpty) {
                    return Text(s.noSlotsForDate);
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (slots.openingTime != null && slots.closingTime != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            'Hours: ${AppDateUtils.formatTime(slots.openingTime!, locale: locale)} – ${AppDateUtils.formatTime(slots.closingTime!, locale: locale)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: visible.map((slot) {
                          final selected = _selectedSlot == slot.time;
                          return FilterChip(
                            label: Text(
                              AppDateUtils.formatTime(slot.time, locale: locale),
                            ),
                            selected: selected,
                            onSelected: slot.available
                                ? (_) => setState(() => _selectedSlot = slot.time)
                                : null,
                            showCheckmark: false,
                            avatar: !slot.available
                                ? const Icon(Icons.block, size: 16)
                                : null,
                          );
                        }).toList(),
                      ),
                    ],
                  );
                },
              ),
            const SizedBox(height: 16),
            MicTextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: s.additionalNotes,
                hintText: s.notesHint,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _loading ? null : _book,
              child: _loading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(s.confirmBooking),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showAddVehicle(BuildContext context) {
    final s = AppStrings.of(context);
    final numberController = TextEditingController();
    final modelController = TextEditingController();
    var vehicleType = 'bike';
    showAppModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Vehicle type', style: Theme.of(ctx).textTheme.titleMedium),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'bike', label: Text('Bike'), icon: Icon(Icons.two_wheeler)),
                    ButtonSegment(value: 'car', label: Text('Car'), icon: Icon(Icons.directions_car)),
                  ],
                  selected: {vehicleType},
                  onSelectionChanged: (v) => setModalState(() => vehicleType = v.first),
                ),
                const SizedBox(height: 16),
                MicTextField(
                  controller: numberController,
                  decoration: InputDecoration(labelText: s.vehicleNumber),
                  textCapitalization: TextCapitalization.characters,
                ),
                const SizedBox(height: 16),
                MicTextField(
                  controller: modelController,
                  decoration: InputDecoration(labelText: s.makeModel),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    final number = numberController.text.trim().toUpperCase();
                    if (number.isEmpty) return;
                    final created =
                        await ref.read(vehicleRepositoryProvider).createVehicle({
                      'vehicle_number': number,
                      'make_model': modelController.text.trim(),
                      'vehicle_type': vehicleType,
                      'is_primary': true,
                    });
                    ref.invalidate(vehiclesProvider);
                    if (mounted) {
                      setState(() {
                        _selectedVehicleId = created.id;
                        _didAutoSelectVehicle = true;
                      });
                    }
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  child: Text(s.addVehicle),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

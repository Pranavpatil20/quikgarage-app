import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/booking_provider.dart';
import '../../../../core/providers/garage_provider.dart';
import '../../../../core/providers/vehicle_provider.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../models/garage_model.dart';
import '../../../../models/vehicle_model.dart';
import '../../../../repositories/booking_repository.dart';
import '../../../../repositories/vehicle_repository.dart';

class BookServiceScreen extends ConsumerStatefulWidget {
  const BookServiceScreen({super.key});

  @override
  ConsumerState<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends ConsumerState<BookServiceScreen> {
  int? _selectedVehicleId;
  int? _selectedGarageId;
  String _serviceType = 'general_service';
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

  String? _validationMessage() {
    if (_selectedVehicleId == null) return 'Please select a vehicle';
    if (_selectedGarageId == null) {
      return 'Please select a garage (or ask an owner to create one)';
    }
    if (_selectedSlot == null) return 'Please select a time slot';
    return null;
  }

  String _normalizeTimeSlot(String slot) {
    // API may return "09:00" or "09:00:00"
    final parts = slot.split(':');
    if (parts.length >= 3) return slot;
    if (parts.length == 2) return '$slot:00';
    return slot;
  }

  Future<void> _book() async {
    final error = _validationMessage();
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    setState(() => _loading = true);
    try {
      await ref.read(bookingRepositoryProvider).createBooking({
        'garage': _selectedGarageId,
        'vehicle': _selectedVehicleId,
        'service_type': _serviceType,
        'booking_date': AppDateUtils.toApiDate(_selectedDate),
        'time_slot': _normalizeTimeSlot(_selectedSlot!),
        'notes': _notesController.text.trim(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking confirmed!')),
        );
        context.go('/customer');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
        title: const Text('Book Service'),
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
                Text('Select Vehicle', style: theme.textTheme.headlineMedium),
                TextButton.icon(
                  onPressed: () => _showAddVehicle(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add New'),
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
                      'No vehicles yet. Tap Add New to add one.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  );
                }
                return SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: vehicles.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) {
                      final v = vehicles[i];
                      final selected = _selectedVehicleId == v.id;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedVehicleId = v.id),
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
                                Icons.directions_car,
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
            Text('Select Garage', style: theme.textTheme.headlineMedium),
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
                      'No garages available yet. An owner must create a garage first.',
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
            Text('Service Type', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppConstants.serviceTypes.map((s) {
                final selected = _serviceType == s;
                return FilterChip(
                  label: Text(AppConstants.serviceTypeLabels[s] ?? s),
                  selected: selected,
                  onSelected: (_) => setState(() => _serviceType = s),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Select Date'),
              subtitle: Text(AppDateUtils.formatDisplayDate(_selectedDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 60)),
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
            Text('Time Slots', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 12),
            if (_selectedGarageId == null)
              Text(
                'Select a garage to see available time slots.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              )
            else
              slotsAsync!.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text(e.toString()),
                data: (slots) {
                  if (slots.slots.isEmpty) {
                    return const Text('No slots for this date.');
                  }
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: slots.slots.map((slot) {
                      final selected = _selectedSlot == slot.time;
                      return FilterChip(
                        label: Text(AppDateUtils.formatTime(slot.time)),
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
                  );
                },
              ),
            const SizedBox(height: 16),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Additional Notes',
                hintText: 'Describe any issues...',
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
                  : const Text('Confirm Booking'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showAddVehicle(BuildContext context) {
    final numberController = TextEditingController();
    final modelController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: numberController,
                decoration: const InputDecoration(labelText: 'Vehicle Number'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: modelController,
                decoration: const InputDecoration(labelText: 'Make / Model'),
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
                    'vehicle_type': 'car',
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
                child: const Text('Add Vehicle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

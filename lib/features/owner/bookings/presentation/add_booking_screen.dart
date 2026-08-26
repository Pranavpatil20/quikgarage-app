import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/booking_provider.dart';
import '../../../../core/providers/customer_provider.dart';
import '../../../../core/providers/dashboard_provider.dart';
import '../../../../core/providers/garage_provider.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../models/garage_model.dart';
import '../../../../core/widgets/mic_text_field.dart';
import '../../../../repositories/booking_repository.dart';

class AddBookingScreen extends ConsumerStatefulWidget {
  const AddBookingScreen({super.key});

  @override
  ConsumerState<AddBookingScreen> createState() => _AddBookingScreenState();
}

class _AddBookingScreenState extends ConsumerState<AddBookingScreen> {
  final _phoneController = TextEditingController();
  final _vehicleController = TextEditingController();
  final _makeModelController = TextEditingController();
  final _notesController = TextEditingController();
  final Set<String> _selectedServiceTypes = {'general_service'};
  String _vehicleType = 'bike';
  DateTime _date = DateTime.now();
  TimeOfDay _time = AppDateUtils.nextAvailableTime();
  bool _loading = false;

  bool get _isPastSelection => !AppDateUtils.isDateTimeInFuture(_date, _time);

  @override
  void dispose() {
    _phoneController.dispose();
    _vehicleController.dispose();
    _makeModelController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  TimeOfDay _openTime(GarageModel garage) {
    final hours = garage.hoursForDate(_date);
    final raw = hours?.opening ?? garage.openingTime;
    return AppDateUtils.parseTimeOfDay(raw) ?? const TimeOfDay(hour: 9, minute: 0);
  }

  TimeOfDay _closeTime(GarageModel garage) {
    final hours = garage.hoursForDate(_date);
    final raw = hours?.closing ?? garage.closingTime;
    return AppDateUtils.parseTimeOfDay(raw) ?? const TimeOfDay(hour: 18, minute: 0);
  }

  String _hoursMessage(GarageModel garage) {
    if (!garage.isOpenOnDate(_date)) {
      return 'Garage is closed on this day. Please choose another date.';
    }
    final open = _openTime(garage);
    final close = _closeTime(garage);
    return 'Booking time must be between ${AppDateUtils.formatHoursRange(open, close)}.';
  }

  bool _isWithinHours(GarageModel garage, TimeOfDay time) {
    if (!garage.isOpenOnDate(_date)) return false;
    return AppDateUtils.isWithinGarageHours(
      time,
      open: _openTime(garage),
      close: _closeTime(garage),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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

  Future<void> _pickDate(GarageModel garage) async {
    final now = DateTime.now();
    var initial = _date.isBefore(now) ? now : _date;
    if (!garage.isOpenOnDate(initial)) {
      initial = _nextOpenDate(garage, from: now);
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 90)),
      selectableDayPredicate: garage.isOpenOnDate,
    );
    if (picked == null) return;
    setState(() {
      _date = picked;
      if (!AppDateUtils.isDateTimeInFuture(_date, _time) || !_isWithinHours(garage, _time)) {
        var next = AppDateUtils.nextAvailableTime(forDate: _date);
        if (!_isWithinHours(garage, next)) {
          next = _openTime(garage);
        }
        _time = next;
      }
    });
  }

  Future<void> _pickTime(GarageModel garage) async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked == null) return;
    if (!AppDateUtils.isDateTimeInFuture(_date, picked)) {
      _showMessage('Please select a future time for today');
      return;
    }
    if (!_isWithinHours(garage, picked)) {
      _showMessage(_hoursMessage(garage));
      return;
    }
    setState(() => _time = picked);
  }

  Future<void> _submit(GarageModel garage) async {
    if (_phoneController.text.isEmpty || _vehicleController.text.isEmpty) {
      _showMessage('Phone and vehicle number required');
      return;
    }
    if (_selectedServiceTypes.isEmpty) {
      _showMessage('Select at least one service type');
      return;
    }
    if (!garage.isOpenOnDate(_date)) {
      _showMessage('Garage is closed on this day. Please choose another date.');
      return;
    }
    if (_isPastSelection) {
      _showMessage('Cannot create a booking in the past');
      return;
    }
    if (!_isWithinHours(garage, _time)) {
      _showMessage(_hoursMessage(garage));
      return;
    }

    setState(() => _loading = true);
    try {
      await ref.read(bookingRepositoryProvider).createOwnerBooking({
        'garage': garage.id,
        'customer_phone': _phoneController.text.trim(),
        'vehicle_number': _vehicleController.text.trim().toUpperCase(),
        'make_model': _makeModelController.text.trim(),
        'vehicle_type': _vehicleType,
        'service_type': _selectedServiceTypes.join(','),
        'booking_date': AppDateUtils.toApiDate(_date),
        'time_slot':
            '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}:00',
        'notes': _notesController.text.trim(),
      });
      refreshBookings(ref);
      ref.invalidate(customersProvider);
      ref.invalidate(dashboardMetricsProvider);
      if (mounted) {
        _showMessage('Booking created');
        context.pop();
      }
    } catch (e) {
      _showMessage('$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final garageAsync = ref.watch(myGarageProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Booking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: garageAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.store_mall_directory_outlined,
                    size: 56, color: theme.colorScheme.primary),
                const SizedBox(height: 16),
                Text(
                  'Create your garage first',
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Add Booking needs a garage. Set one up in Settings, then try again.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go('/owner/settings'),
                  child: const Text('Go to Settings'),
                ),
                TextButton(
                  onPressed: () => ref.invalidate(myGarageProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (garage) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Customer Phone',
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 16),
              Text('Vehicle type', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'bike',
                    label: Text('Bike'),
                    icon: Icon(Icons.two_wheeler),
                  ),
                  ButtonSegment(
                    value: 'car',
                    label: Text('Car'),
                    icon: Icon(Icons.directions_car),
                  ),
                ],
                selected: {_vehicleType},
                onSelectionChanged: (v) => setState(() {
                  _vehicleType = v.first;
                  final allowed = AppConstants.serviceTypesForVehicle(_vehicleType);
                  _selectedServiceTypes.removeWhere((t) => !allowed.contains(t));
                  if (_selectedServiceTypes.isEmpty) {
                    _selectedServiceTypes.add('general_service');
                  }
                }),
              ),
              const SizedBox(height: 16),
              MicTextField(
                controller: _vehicleController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Number',
                  prefixIcon: Icon(Icons.directions_car),
                ),
              ),
              const SizedBox(height: 16),
              MicTextField(
                controller: _makeModelController,
                decoration: const InputDecoration(
                  labelText: 'Make / Model',
                  prefixIcon: Icon(Icons.car_repair),
                ),
              ),
              const SizedBox(height: 16),
              Text('Service type', style: theme.textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(
                'You can select more than one',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppConstants.serviceTypesForVehicle(_vehicleType).map((type) {
                  final selected = _selectedServiceTypes.contains(type);
                  return FilterChip(
                    label: Text(
                      AppConstants.serviceTypeLabel(type, vehicleType: _vehicleType),
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
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Booking Date'),
                subtitle: Text(AppDateUtils.formatDisplayDate(_date)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _pickDate(garage),
              ),
              ListTile(
                title: const Text('Time Slot'),
                subtitle: Text(_time.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () => _pickTime(garage),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: Text(
                  'Garage hours: ${garage.formattedHours}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              MicTextField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  prefixIcon: Icon(Icons.notes),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : () => _submit(garage),
                child: _loading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(),
                      )
                    : const Text('Create Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

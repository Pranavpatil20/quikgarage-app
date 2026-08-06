import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/garage_provider.dart';
import '../../../../core/utils/date_utils.dart';
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
  String _serviceType = 'general_service';
  DateTime _date = DateTime.now();
  TimeOfDay _time = const TimeOfDay(hour: 9, minute: 0);
  bool _loading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _vehicleController.dispose();
    _makeModelController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit(int garageId) async {
    if (_phoneController.text.isEmpty || _vehicleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone and vehicle number required')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      await ref.read(bookingRepositoryProvider).createOwnerBooking({
        'garage': garageId,
        'customer_phone': _phoneController.text.trim(),
        'vehicle_number': _vehicleController.text.trim().toUpperCase(),
        'make_model': _makeModelController.text.trim(),
        'service_type': _serviceType,
        'booking_date': AppDateUtils.toApiDate(_date),
        'time_slot':
            '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}:00',
        'notes': _notesController.text.trim(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking created')),
        );
        context.pop();
      }
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
        error: (_, __) => Center(
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
              TextField(
                controller: _vehicleController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Number',
                  prefixIcon: Icon(Icons.directions_car),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _makeModelController,
                decoration: const InputDecoration(
                  labelText: 'Make / Model',
                  prefixIcon: Icon(Icons.car_repair),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _serviceType,
                dropdownColor: theme.colorScheme.surfaceContainerHighest,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  labelText: 'Service Type',
                  labelStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  prefixIcon: Icon(
                    Icons.build_circle_outlined,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                items: AppConstants.serviceTypes
                    .map(
                      (s) => DropdownMenuItem(
                        value: s,
                        child: Text(
                          AppConstants.serviceTypeLabels[s] ?? s,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _serviceType = v!),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Booking Date'),
                subtitle: Text(AppDateUtils.formatDisplayDate(_date)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                  );
                  if (picked != null) setState(() => _date = picked);
                },
              ),
              ListTile(
                title: const Text('Time Slot'),
                subtitle: Text(_time.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final picked = await showTimePicker(context: context, initialTime: _time);
                  if (picked != null) setState(() => _time = picked);
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  prefixIcon: Icon(Icons.notes),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading ? null : () => _submit(garage.id),
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

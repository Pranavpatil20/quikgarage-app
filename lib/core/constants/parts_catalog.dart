/// Catalog of common bike/car service parts (lubricant / parts / labour).
class PartCatalogItem {
  const PartCatalogItem({
    required this.name,
    required this.category,
    required this.vehicleTypes,
    this.defaultRate = 0,
  });

  final String name;
  /// lubricant | parts | labour
  final String category;
  /// bike, car, or both
  final List<String> vehicleTypes;
  final double defaultRate;

  bool matchesVehicle(String vehicleType) {
    final t = vehicleType.toLowerCase();
    return vehicleTypes.contains('both') ||
        vehicleTypes.contains(t) ||
        (t == 'scooter' && vehicleTypes.contains('bike'));
  }
}

abstract final class PartsCatalog {
  static const List<PartCatalogItem> all = [
    // —— Lubricants (bike) ——
    PartCatalogItem(name: 'Engine Oil 10W30 (Bike)', category: 'lubricant', vehicleTypes: ['bike'], defaultRate: 450),
    PartCatalogItem(name: 'Engine Oil 20W40 (Bike)', category: 'lubricant', vehicleTypes: ['bike'], defaultRate: 420),
    PartCatalogItem(name: 'Gear Oil (Scooter/Bike)', category: 'lubricant', vehicleTypes: ['bike'], defaultRate: 120),
    PartCatalogItem(name: 'Chain Lubricant Spray', category: 'lubricant', vehicleTypes: ['bike'], defaultRate: 180),
    PartCatalogItem(name: 'Fork Oil', category: 'lubricant', vehicleTypes: ['bike'], defaultRate: 250),
    PartCatalogItem(name: 'Brake Fluid DOT 3/4 (Bike)', category: 'lubricant', vehicleTypes: ['bike'], defaultRate: 150),
    PartCatalogItem(name: 'Coolant (Bike)', category: 'lubricant', vehicleTypes: ['bike'], defaultRate: 200),
    PartCatalogItem(name: 'Consumables Kit (Bike)', category: 'lubricant', vehicleTypes: ['bike'], defaultRate: 99),
    // —— Lubricants (car) ——
    PartCatalogItem(name: 'Engine Oil 5W30 (Car)', category: 'lubricant', vehicleTypes: ['car'], defaultRate: 2200),
    PartCatalogItem(name: 'Engine Oil 10W40 (Car)', category: 'lubricant', vehicleTypes: ['car'], defaultRate: 1800),
    PartCatalogItem(name: 'Gear Oil (Car)', category: 'lubricant', vehicleTypes: ['car'], defaultRate: 650),
    PartCatalogItem(name: 'Brake Fluid DOT 4 (Car)', category: 'lubricant', vehicleTypes: ['car'], defaultRate: 280),
    PartCatalogItem(name: 'Coolant (Car)', category: 'lubricant', vehicleTypes: ['car'], defaultRate: 450),
    PartCatalogItem(name: 'Power Steering Oil', category: 'lubricant', vehicleTypes: ['car'], defaultRate: 350),
    PartCatalogItem(name: 'AC Gas / Refrigerant', category: 'lubricant', vehicleTypes: ['car'], defaultRate: 1200),
    PartCatalogItem(name: 'Consumables Kit (Car)', category: 'lubricant', vehicleTypes: ['car'], defaultRate: 199),
    // —— Parts (bike) ——
    PartCatalogItem(name: 'Air Filter (Bike)', category: 'parts', vehicleTypes: ['bike'], defaultRate: 180),
    PartCatalogItem(name: 'Oil Filter (Bike)', category: 'parts', vehicleTypes: ['bike'], defaultRate: 120),
    PartCatalogItem(name: 'Spark Plug (Bike)', category: 'parts', vehicleTypes: ['bike'], defaultRate: 150),
    PartCatalogItem(name: 'Brake Shoe Set (Front)', category: 'parts', vehicleTypes: ['bike'], defaultRate: 350),
    PartCatalogItem(name: 'Brake Shoe Set (Rear)', category: 'parts', vehicleTypes: ['bike'], defaultRate: 320),
    PartCatalogItem(name: 'Brake Pad Set (Disc)', category: 'parts', vehicleTypes: ['bike'], defaultRate: 450),
    PartCatalogItem(name: 'Clutch Plate Set', category: 'parts', vehicleTypes: ['bike'], defaultRate: 800),
    PartCatalogItem(name: 'Drive Chain', category: 'parts', vehicleTypes: ['bike'], defaultRate: 650),
    PartCatalogItem(name: 'Sprocket Kit', category: 'parts', vehicleTypes: ['bike'], defaultRate: 900),
    PartCatalogItem(name: 'Accelerator Cable', category: 'parts', vehicleTypes: ['bike'], defaultRate: 180),
    PartCatalogItem(name: 'Clutch Cable', category: 'parts', vehicleTypes: ['bike'], defaultRate: 160),
    PartCatalogItem(name: 'Speedometer Cable', category: 'parts', vehicleTypes: ['bike'], defaultRate: 140),
    PartCatalogItem(name: 'Choke Cable', category: 'parts', vehicleTypes: ['bike'], defaultRate: 120),
    PartCatalogItem(name: 'Battery (Bike 12V)', category: 'parts', vehicleTypes: ['bike'], defaultRate: 1200),
    PartCatalogItem(name: 'Headlight Bulb (Bike)', category: 'parts', vehicleTypes: ['bike'], defaultRate: 80),
    PartCatalogItem(name: 'Indicator Bulb Set', category: 'parts', vehicleTypes: ['bike'], defaultRate: 60),
    PartCatalogItem(name: 'Tyre Tube (Front)', category: 'parts', vehicleTypes: ['bike'], defaultRate: 250),
    PartCatalogItem(name: 'Tyre Tube (Rear)', category: 'parts', vehicleTypes: ['bike'], defaultRate: 280),
    PartCatalogItem(name: 'Front Tyre (Bike)', category: 'parts', vehicleTypes: ['bike'], defaultRate: 1400),
    PartCatalogItem(name: 'Rear Tyre (Bike)', category: 'parts', vehicleTypes: ['bike'], defaultRate: 1600),
    PartCatalogItem(name: 'Mirror Set', category: 'parts', vehicleTypes: ['bike'], defaultRate: 350),
    PartCatalogItem(name: 'Handle Grip Set', category: 'parts', vehicleTypes: ['bike'], defaultRate: 200),
    PartCatalogItem(name: 'Seat Cover', category: 'parts', vehicleTypes: ['bike'], defaultRate: 400),
    PartCatalogItem(name: 'Horn', category: 'parts', vehicleTypes: ['bike'], defaultRate: 250),
    PartCatalogItem(name: 'Relay / CDI', category: 'parts', vehicleTypes: ['bike'], defaultRate: 600),
    PartCatalogItem(name: 'Carburetor Kit', category: 'parts', vehicleTypes: ['bike'], defaultRate: 450),
    PartCatalogItem(name: 'Fuel Filter (Bike)', category: 'parts', vehicleTypes: ['bike'], defaultRate: 90),
    PartCatalogItem(name: 'Wheel Bearing', category: 'parts', vehicleTypes: ['bike'], defaultRate: 200),
    PartCatalogItem(name: 'Bush Kit / Suspension Bush', category: 'parts', vehicleTypes: ['bike'], defaultRate: 280),
    PartCatalogItem(name: 'Brake Cable', category: 'parts', vehicleTypes: ['bike'], defaultRate: 150),
    PartCatalogItem(name: 'Body Cover / Visor', category: 'parts', vehicleTypes: ['bike'], defaultRate: 500),
    PartCatalogItem(name: '3M Nano Polish', category: 'parts', vehicleTypes: ['both'], defaultRate: 350),
    // —— Parts (car) ——
    PartCatalogItem(name: 'Air Filter (Car)', category: 'parts', vehicleTypes: ['car'], defaultRate: 450),
    PartCatalogItem(name: 'Oil Filter (Car)', category: 'parts', vehicleTypes: ['car'], defaultRate: 350),
    PartCatalogItem(name: 'Fuel Filter (Car)', category: 'parts', vehicleTypes: ['car'], defaultRate: 400),
    PartCatalogItem(name: 'Cabin / AC Filter', category: 'parts', vehicleTypes: ['car'], defaultRate: 550),
    PartCatalogItem(name: 'Spark Plug Set (Car)', category: 'parts', vehicleTypes: ['car'], defaultRate: 800),
    PartCatalogItem(name: 'Brake Pad Set Front (Car)', category: 'parts', vehicleTypes: ['car'], defaultRate: 1800),
    PartCatalogItem(name: 'Brake Pad Set Rear (Car)', category: 'parts', vehicleTypes: ['car'], defaultRate: 1500),
    PartCatalogItem(name: 'Brake Disc / Rotor', category: 'parts', vehicleTypes: ['car'], defaultRate: 3200),
    PartCatalogItem(name: 'Wiper Blade Set', category: 'parts', vehicleTypes: ['car'], defaultRate: 450),
    PartCatalogItem(name: 'Battery (Car 12V)', category: 'parts', vehicleTypes: ['car'], defaultRate: 5500),
    PartCatalogItem(name: 'Headlight Bulb (Car)', category: 'parts', vehicleTypes: ['car'], defaultRate: 350),
    PartCatalogItem(name: 'Serpentine / Timing Belt', category: 'parts', vehicleTypes: ['car'], defaultRate: 2500),
    PartCatalogItem(name: 'Radiator Hose', category: 'parts', vehicleTypes: ['car'], defaultRate: 600),
    PartCatalogItem(name: 'Clutch Kit (Car)', category: 'parts', vehicleTypes: ['car'], defaultRate: 6500),
    PartCatalogItem(name: 'Shock Absorber (Car)', category: 'parts', vehicleTypes: ['car'], defaultRate: 2800),
    PartCatalogItem(name: 'Wheel Bearing (Car)', category: 'parts', vehicleTypes: ['car'], defaultRate: 1200),
    PartCatalogItem(name: 'Tyre (Car)', category: 'parts', vehicleTypes: ['car'], defaultRate: 4500),
    PartCatalogItem(name: 'AC Compressor Oil / Seal', category: 'parts', vehicleTypes: ['car'], defaultRate: 800),
    PartCatalogItem(name: 'Oxygen / MAF Sensor', category: 'parts', vehicleTypes: ['car'], defaultRate: 2200),
    PartCatalogItem(name: 'Alternator Belt', category: 'parts', vehicleTypes: ['car'], defaultRate: 700),
    // —— Labour (both) ——
    PartCatalogItem(name: 'General / Paid Service Labour', category: 'labour', vehicleTypes: ['both'], defaultRate: 499),
    PartCatalogItem(name: 'Oil Change Labour', category: 'labour', vehicleTypes: ['both'], defaultRate: 150),
    PartCatalogItem(name: 'Brake Shoe / Pad R/R', category: 'labour', vehicleTypes: ['both'], defaultRate: 250),
    PartCatalogItem(name: 'Chain & Sprocket Fitment', category: 'labour', vehicleTypes: ['bike'], defaultRate: 200),
    PartCatalogItem(name: 'Clutch Overhaul Labour', category: 'labour', vehicleTypes: ['both'], defaultRate: 800),
    PartCatalogItem(name: 'Carburetor Cleaning', category: 'labour', vehicleTypes: ['bike'], defaultRate: 350),
    PartCatalogItem(name: 'Engine Tuning', category: 'labour', vehicleTypes: ['both'], defaultRate: 400),
    PartCatalogItem(name: 'Wheel Alignment / Balancing', category: 'labour', vehicleTypes: ['both'], defaultRate: 300),
    PartCatalogItem(name: 'Puncture Repair', category: 'labour', vehicleTypes: ['both'], defaultRate: 50),
    PartCatalogItem(name: 'Battery Fitment', category: 'labour', vehicleTypes: ['both'], defaultRate: 100),
    PartCatalogItem(name: 'AC Service Labour', category: 'labour', vehicleTypes: ['car'], defaultRate: 600),
    PartCatalogItem(name: 'Full Body Wash', category: 'labour', vehicleTypes: ['both'], defaultRate: 200),
    PartCatalogItem(name: 'Interior Cleaning', category: 'labour', vehicleTypes: ['car'], defaultRate: 400),
    PartCatalogItem(name: 'Denting / Painting (Panel)', category: 'labour', vehicleTypes: ['both'], defaultRate: 1500),
    PartCatalogItem(name: 'Diagnostic / Scanning', category: 'labour', vehicleTypes: ['car'], defaultRate: 500),
    PartCatalogItem(name: 'Free Service Labour', category: 'labour', vehicleTypes: ['both'], defaultRate: 0),
    PartCatalogItem(name: 'Inspection Only', category: 'labour', vehicleTypes: ['both'], defaultRate: 199),
    PartCatalogItem(name: 'Other Labour', category: 'labour', vehicleTypes: ['both'], defaultRate: 300),
  ];

  static List<PartCatalogItem> forVehicle(String vehicleType, {String query = ''}) {
    final q = query.trim().toLowerCase();
    return all.where((p) {
      if (!p.matchesVehicle(vehicleType)) return false;
      if (q.isEmpty) return true;
      return p.name.toLowerCase().contains(q) || p.category.contains(q);
    }).toList();
  }
}

/// One line on booking / invoice (parts, lubricant, or labour).
class ServiceLineItem {
  ServiceLineItem({
    required this.name,
    required this.category,
    this.qty = 1,
    this.rate = 0,
    this.gstPercent = 0,
  });

  String name;
  String category;
  double qty;
  double rate;
  /// Kept for API compatibility; GST is not used (always 0).
  double gstPercent;

  double get amount => qty * rate;

  Map<String, dynamic> toJson() => {
        'name': name,
        'category': category,
        'qty': qty,
        'rate': rate,
        'gst_percent': 0,
        'amount': double.parse(amount.toStringAsFixed(2)),
      };

  factory ServiceLineItem.fromJson(Map<String, dynamic> json) {
    return ServiceLineItem(
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? 'parts',
      qty: (json['qty'] as num?)?.toDouble() ?? 1,
      rate: (json['rate'] as num?)?.toDouble() ?? 0,
      gstPercent: 0,
    );
  }
}

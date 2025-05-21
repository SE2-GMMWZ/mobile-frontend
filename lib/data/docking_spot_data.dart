class DockingSpotData {
  final String? dock_id;
  final String name;
  final String town;
  final String latitude;
  final String longitude;
  final String description;
  final String owner_id;
  final String services;
  final double services_pricing;
  final double price_per_night;
  final double price_per_person;
  final String availability;

  DockingSpotData({
    this.dock_id,
    required this.name,
    required this.town,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.owner_id,
    required this.services,
    required this.services_pricing,
    required this.price_per_night,
    required this.price_per_person,
    required this.availability,
  });

  factory DockingSpotData.fromJson(Map<String, dynamic> json) {
    return DockingSpotData(
      dock_id: json['dock_id'] as String?,
      name: json['name'] as String? ?? '',
      town: json['town'] as String? ?? '',
      latitude: json['latitude'] as String? ?? '',
      longitude: json['longitude'] as String? ?? '',
      description: json['description'] as String? ?? '',
      owner_id: json['owner_id'] as String? ?? '',
      services: json['services'] as String? ?? '',
      services_pricing: (json['services_pricing'] as num?)?.toDouble() ?? 0.0,
      price_per_night: (json['price_per_night'] as num?)?.toDouble() ?? 0.0,
      price_per_person: (json['price_per_person'] as num?)?.toDouble() ?? 0.0,
      availability: json['availability'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dock_id': dock_id,
      'name': name,
      'town': town,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'owner_id': owner_id,
      'services': services,
      'services_pricing': services_pricing,
      'price_per_night': price_per_night,
      'price_per_person': price_per_person,
      'availability': availability,
    };
  }
}
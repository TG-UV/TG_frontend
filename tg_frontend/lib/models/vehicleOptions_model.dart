class VehicleOption {
  final int id;
  final String name;

  VehicleOption({required this.id, required this.name});

   factory VehicleOption.fromJson(Map<String, dynamic> json, String idKey) {
    return VehicleOption(
      id: json[idKey] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
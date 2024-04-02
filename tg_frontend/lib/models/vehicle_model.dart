class Vehicle {
  final int idVehicle;
  final String licensePlate;
  final int vehicleType;
  final int vehicleBrand;
  final int vehicleModel;
  final int vehicleColor;
  final int owner;

  Vehicle({
    required this.idVehicle,
    required this.licensePlate,
    required this.vehicleType,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.owner,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      idVehicle: json['id_vehicle']as int? ?? 0,
      licensePlate: json['license_plate']?.toString() ?? '',
      vehicleType: json['vehicle_type']as int? ?? 0,
      vehicleBrand: json['vehicle_brand']as int? ?? 0,
      vehicleModel: json['vehicle_model']as int? ?? 0,
      vehicleColor: json['vehicle_color']as int? ?? 0,
      owner: json['owner']as int? ?? 0,
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'license_plate': licensePlate,
      'vehicle_type' :vehicleType,
      'vehicle_brand' : vehicleBrand,
      'vehicle_model': vehicleModel,
      'vehicle_color': vehicleColor,
      'owner' : owner,
    };
  }
}

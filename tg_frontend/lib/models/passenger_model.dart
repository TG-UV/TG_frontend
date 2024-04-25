import 'package:intl/intl.dart';

class Passenger {
  final int idPassenger;
  final double pickupPointLat;
  final double pickupPointLong;
  final int seats;
  final int isConfirmed;
  final int trip;
  final int passenger;
  final String phoneNumber;
  final String firstName;
  final String lastName;

  Passenger({
    required this.idPassenger,
    required this.pickupPointLat,
    required this.pickupPointLong,
    required this.seats,
    required this.isConfirmed,
    required this.trip,
    required this.passenger,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
  });

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      idPassenger: json['id_passenger_trip'] as int? ?? 0,
      isConfirmed: json['is_confirmed'] == true ? 1 : 0,
      pickupPointLat: json['pickup_point_lat'] as double? ?? 0.0,
      pickupPointLong: json['pickup_point_long'] as double? ?? 0.0,
      phoneNumber: json['phone_number']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      trip: json['trip'] as int? ?? 0,
      seats: json['seats'] as int? ?? 0,
      passenger: json['passenger'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'id_passenger_trip': idPassenger,
      'pickup_point_lat': double.parse(pickupPointLat.toStringAsFixed(6)),
      'pickup_point_long': double.parse(pickupPointLong.toStringAsFixed(6)),
      'seats': seats,
      'is_confirmed': isConfirmed == 1 ? true : false,
      'trip': trip,
      'passenger': passenger,
      //'phone_number': phoneNumber,
      //'first_name': firstName,
      //'last_name': lastName,
    };
  }
}

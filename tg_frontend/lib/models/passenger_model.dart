import 'package:intl/intl.dart';

class Passenger {
  final int idPassenger;
  final String pickupPoint;
  final int seats;
  final int isConfirmed;
  final int trip;
  final int passenger;
  final String phoneNumber;
  final String firstName;
  final String lastName;

  Passenger({
    required this.idPassenger,
    required this.pickupPoint,
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
      pickupPoint: json['pickup_point']?.toString() ?? '',
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
      'pickup_point': pickupPoint,
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

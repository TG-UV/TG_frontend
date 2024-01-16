import 'package:intl/intl.dart';

class Travel {
  final String id;
  final String arrivalPoint;
  final String startingPoint;
  final int driver;
  final String price;
  final int seats;
  final DateTime hour;
  final DateTime date;
  final bool currentTrip;

  Travel(
      {required this.id,
      required this.arrivalPoint,
      required this.startingPoint,
      required this.driver,
      required this.price,
      required this.seats,
      required this.hour,
      required this.date,
      required this.currentTrip});

  factory Travel.fromJson(Map<String, dynamic> json) {
    return Travel(
      id: json['id_trip']?.toString() ?? '',
      arrivalPoint: json['arrival_point']?.toString() ?? '',
      startingPoint: json['starting_point']?.toString() ?? '',
      driver: json['driver'] as int? ?? 0,
      price: json['fare']?.toString() ?? '',
      seats: json['seats'] as int? ?? 0,
      hour: json['start_time'] != null
          ? DateTime.parse('${json['start_date']} ${json['start_time']}')
          : DateTime.now(),
      date: json['start_date'] != null
          ? DateTime.parse('${json['start_date']} ${json['start_time']}')
          : DateTime.now(),
      currentTrip: json['current_trip'] as bool? ?? false,
    );
  }

  String get dateFormatted {
    return DateFormat('EEEE').format(date);
  }

  String get hourFormatted {
    return DateFormat('HH:mm').format(hour);
  }
}

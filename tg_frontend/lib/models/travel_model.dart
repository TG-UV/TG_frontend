import 'package:intl/intl.dart';

class Travel {
  final int id;
  final String arrivalPoint;
  final String startingPoint;
  final int driver;
  final int price;
  final int seats;
  final String hour;
  final String date;
  final int currentTrip;

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
      id: json['id_trip'] as int? ?? 0,
      arrivalPoint: json['arrival_point']?.toString() ?? '',
      startingPoint: json['starting_point']?.toString() ?? '',
      driver: json['driver'] as int? ?? 0,
      price: json['fare'] as int? ?? 0,
      seats: json['seats'] as int? ?? 0,
      hour: json['start_time']?.toString() ?? '',
      date: json['start_date']?.toString() ?? '',
      // hour: json['start_time'] != null
      //     ? DateTime.parse('${json['start_date']} ${json['start_time']}')
      //     : DateTime.now(),
      // date: json['start_date'] != null
      //     ? DateTime.parse('${json['start_date']} ${json['start_time']}')
      //     : DateTime.now(),
      currentTrip: json['current_trip'] == true ? 1 : 0,
    );
  }

  // String get dateFormatted {
  //   return DateFormat('EEEE').format(date);
  // }

  // String get hourFormatted {
  //   return DateFormat('HH:mm').format(hour);
  // }

  Map<String, dynamic> toJson() {
    // DateTime dateFormatted = DateTime.parse(date);
    // DateTime hourFormatted = DateTime.parse(hour);
    return {
      'arrival_point': arrivalPoint,
      'starting_point': startingPoint,
      //'driver': driver,
      'fare': price,
      'seats': seats,
      'start_time': hour,
      'start_date': date,
      // 'start_time': DateFormat("yyyy-MM-ddTHH:mm "),
      // 'start_date': DateFormat("yyyy-MM-dd").format(date).toString(),
      'current_trip': currentTrip == 1 ? true : false,
      'vehicle': 1
    };
  }
}

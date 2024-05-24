class Travel {
  final int id;
  final double arrivalPointLat;
  final double arrivalPointLong;
  final double startingPointLat;
  final double startingPointLong;
  final int driver;
  final int price;
  final int seats;
  final String hour;
  final String date;
  final int currentTrip;
  final int? vehicle;

  Travel(
      {required this.id,
      required this.arrivalPointLat,
      required this.arrivalPointLong,
      required this.startingPointLat,
      required this.startingPointLong,
      required this.driver,
      required this.price,
      required this.seats,
      required this.hour,
      required this.date,
      required this.currentTrip,
      this.vehicle});

  factory Travel.fromJson(Map<String, dynamic> json) {
    return Travel(
      id: json['id_trip'] as int? ?? 0,
      startingPointLat: json['starting_point']['lat'] as double? ?? 0.0,
      startingPointLong: json['starting_point']['long'] as double? ?? 0.0,
      arrivalPointLat: json['arrival_point']['lat'] as double? ?? 0.0,
      arrivalPointLong: json['arrival_point']['long'] as double? ?? 0.0,
      driver: json['driver'] as int? ?? 0,
      price: json['fare'] as int? ?? 0,
      seats: json['seats'] as int? ?? 0,
      hour: json['start_time']?.toString() ?? '',
      date: json['start_date']?.toString() ?? '',
      currentTrip: json['current_trip'] == true ? 1 : 0,
    );
  }
  factory Travel.fromJsonNotifications(Map<String, dynamic> json) {
    return Travel(
        id: json['id_trip']
            as int, // No es necesario el parseo ya que es un int
        startingPointLat:
            double.parse(json['starting_point']['lat'] as String? ?? '0'),
        startingPointLong:
            double.parse(json['starting_point']['long'] as String? ?? '0'),
        arrivalPointLat:
            double.parse(json['arrival_point']['lat'] as String? ?? '0'),
        arrivalPointLong:
            double.parse(json['arrival_point']['long'] as String? ?? '0'),
        driver:
            0, // json['driver'] as int? ?? 0, // Ajusta según lo que desees hacer con 'driver'
        price: json['fare'] as int? ??
            0, // No es necesario el parseo ya que es un int
        seats: json['seats'] as int? ??
            0, // No es necesario el parseo ya que es un int
        hour: json['start_time']?.toString() ?? '',
        date: json['start_date']?.toString() ?? '',
        currentTrip:
            0 // json['current_trip'] == true ? 1 : 0, // Ajusta según lo que desees hacer con 'current_trip'
        );
  }

  // String get dateFormatted {
  //   return DateFormat('EEEE').format(date);
  // }

  // String get hourFormatted {
  //   return DateFormat('HH:mm').format(hour);
  // }

  static Map<String, double> _parsePoint(Map<String, dynamic>? point) {
    if (point == null) return {'lat': 0.0, 'long': 0.0};
    return {
      'lat': point['lat'] as double? ?? 0.0,
      'long': point['long'] as double? ?? 0.0,
    };
  }

  Map<String, dynamic> toJson() {
    // DateTime dateFormatted = DateTime.parse(date);
    // DateTime hourFormatted = DateTime.parse(hour);
    return {
      'arrival_point_lat': double.parse(arrivalPointLat.toStringAsFixed(6)),
      'arrival_point_long': double.parse(arrivalPointLong.toStringAsFixed(6)),
      'starting_point_lat': double.parse(startingPointLat.toStringAsFixed(6)),
      'starting_point_long': double.parse(startingPointLong.toStringAsFixed(6)),
      //'driver': driver,
      'fare': price,
      'seats': seats,
      'start_time': hour,
      'start_date': date,
      // 'start_time': DateFormat("yyyy-MM-ddTHH:mm "),
      // 'start_date': DateFormat("yyyy-MM-dd").format(date).toString(),
      'current_trip': currentTrip == 1 ? true : false,
      'vehicle': vehicle
    };
  }
}

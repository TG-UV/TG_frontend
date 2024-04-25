import 'package:latlong2/latlong.dart';
import 'package:tg_frontend/device/local_tables.dart';
import 'package:tg_frontend/models/passenger_model.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:dio/dio.dart';
import 'package:tg_frontend/services/auth_services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tg_frontend/datasource/local_database_provider.dart';
import 'package:tg_frontend/datasource/endPoints/end_point.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class TravelDatasource {
  Future<List<String>> getMapSuggestions({required String address});
  Future<LatLng> getMapCoordinates({required String address});
  Future<String> getTextDirection({required double lat, required double long});
  //Future<void> insertTravelsLocal({required List<Travel> travels});
  Future<void> insertTravelRemote({required Travel travel});
  Future<void> deleteTravelRemote({required String travelId});
  Future<void> getTravelLocal({required int travelId, String filter});
  Future<List<Travel>> getTravelsRemote({required String finalEndPoint});
  Future<Response<Map<String, dynamic>>?> getTravelDetails(
      {required int travelId, required String finalUrl});
  Future<int?> updateTravelLocal(
      {required int travelId,
      required List<String> fields,
      required List<String> values});
  Future<int?> updateTravelRemote(
      {required int travelId,
      required List<String> fields,
      required List<String> values});
  Future<List<Passenger>> getPassangersRemote({required int travelId});
  Future<int> insertPassengerRemote({required Passenger passenger});
  Future<int> updatePassengerRemote(
      {required int passengerTripId, required bool valueConfirmed});
  Future<int> deletePassengerRemote({required int passengerId});
}

class TravelDatasourceMethods implements TravelDatasource {
  Dio dio = Dio();
  DatabaseProvider databaseProvider = DatabaseProvider.db;
  late Database database;
  final _endPoints = EndPoints();
  String? token;
  late User user = Environment.sl.get<User>();
  String apiKey =
      'pk.eyJ1Ijoic2FybWFyaWUiLCJhIjoiY2xwYm15eTRrMGZyYjJtcGJ1bnJ0Y3hpciJ9.v5mHXrC66zG4x-dgZDdLSA';

  TravelDatasourceMethods() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    database = await databaseProvider.database;
    token = await AuthStorage().getToken();
  }

  @override
  Future<List<String>> getMapSuggestions({required String address}) async {
    String url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$address.json?access_token=$apiKey&country=CO&region=Valle%20del%20Cauca';
    List<String> suggestions = [];

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> features = data['features'];
      suggestions =
          features.map((feature) => feature['place_name'] as String).toList();
    } else {
      throw Exception('Error al obtener sugerencias de búsqueda');
    }
    return suggestions;
  }

  @override
  Future<LatLng> getMapCoordinates({required String address}) async {
    String url =
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$address.json?access_token=$apiKey";

    //List<String> suggestions = [];

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<double> coordinatesValues =
          List<double>.from(data['features'][0]['geometry']['coordinates']);
      //print('response coor: ${json.decode(response.body)}');
      LatLng coordinates = LatLng(coordinatesValues[1], coordinatesValues[0]);
      print('coordinates: $coordinates');
      return coordinates;
    } else {
      throw Exception('Falló al obtener las coordenadas en Mapbox');
    }
  }

  @override
  Future<String> getTextDirection(
      {required double lat, required double long}) async {
    String placeName = "";
    String url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$long,$lat.json?access_token=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final features = jsonResponse['features'];
      if (features != null && features.isNotEmpty) {
        final firstFeature = features[0];
        placeName = firstFeature['place_name'];
      } else {
        return 'No se encontraron resultados';
      }
    } else {
      throw Exception('Error al obtener la dirección: ${response.statusCode}');
    }
    return placeName;
  }

  // @override
  // Future<void> insertTravelsLocal({required List<Travel> travels}) async {
  //   var i = 0;
  //   Travel currentTravel;
  //   try {
  //     while (i < travels.length) {
  //       currentTravel = travels[i];
  //       await database.insert(LocalDB.tbTravel, {
  //         LocalDB.idTravel: currentTravel.id,
  //         LocalDB.arrivalPoint: currentTravel.arrivalPoint,
  //         LocalDB.startingPoint: currentTravel.startingPoint,
  //         LocalDB.date: currentTravel.date,
  //         LocalDB.hour: currentTravel.hour,
  //         LocalDB.driver: currentTravel.driver,
  //         LocalDB.price: currentTravel.price,
  //         LocalDB.seats: currentTravel.seats,
  //         LocalDB.currentTrip: currentTravel.currentTrip,
  //       }).timeout(const Duration(seconds: 120));
  //       i++;
  //     }
  //   } catch (e) {
  //     print('Error al insertar un viaje Local' + e.toString());
  //   }
  // }

  @override
  Future<int> insertTravelRemote({required Travel travel}) async {
    Response? response;
    int sent = 0;
    try {
      String? token = await AuthStorage().getToken();
      Map<String, dynamic> jsonTravel = travel.toJson();
      print(jsonTravel);
      dio.options.headers['Authorization'] = 'Token $token';
      response = await dio.post(_endPoints.baseUrl + _endPoints.postTravel,
          data: jsonTravel);
      // String data = Travel.toJson(travels[sent] as Travel);

      //  print(response.data);

      // await updateTravelLocal(
      //     travelId: int.parse(travels[sent].id),
      //     fields: [Local.FIELD_SINCRONIZADO_ORDEN],
      //     values: [SINCRONIZADO.toString()]);
      sent++;
    } catch (e) {
      return sent;
    }
    return sent;
  }

  @override
  Future<int> deleteTravelRemote({required String travelId}) async {
    Response? response;
    int sent = 0;
    String url =
        "${_endPoints.baseUrl}${_endPoints.deleteTRavelDriver}$travelId/";
    try {
      dio.options.headers['Authorization'] = 'Token $token';
      response = await dio.delete(url);

      // String data = Travel.toJson(travels[sent] as Travel);

      //  print(response.data);

      // await updateTravelLocal(
      //     travelId: int.parse(travels[sent].id),
      //     fields: [Local.FIELD_SINCRONIZADO_ORDEN],
      //     values: [SINCRONIZADO.toString()]);
      sent++;
    } catch (e) {
      return sent;
    }
    return sent;
  }

  @override
  Future<Travel?> getTravelLocal(
      {required int travelId, String? filter}) async {
    try {
      List<Map<String, dynamic>> travelMaps = await database.query(
        LocalDB.tbTravel,
        where: '${LocalDB.idTravel} = ?',
        whereArgs: [travelId],
      ).timeout(const Duration(seconds: 300));

      if (travelMaps.isNotEmpty) {
        return Travel.fromJson(travelMaps.first);
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Future<List<Travel>> getTravelsRemote({required String finalEndPoint}) async {
    String? token = await AuthStorage().getToken();
    List<Travel> travelList = [];
    Response<dynamic> response;

    if (token != null) {
      try {
        dio.options.headers['Authorization'] = 'Token $token';
        response = await dio.get(_endPoints.baseUrl + finalEndPoint
            //queryParameters: parameters,
            );
        if (finalEndPoint == _endPoints.getGeneralTravels) {
          for (var data in response.data) {
            Travel travel = Travel.fromJson(data);
            travelList.add(travel);
          }
        } else {
          for (var data in response.data["results"]) {
            Travel travel = Travel.fromJson(data);
            travelList.add(travel);
          }
        }

        // travel = Travel.fromJson(response.data);
        // travelList.add(travel);
        //insertTravelsLocal(travels: travelList);
      } catch (error) {
        print('Error al realizar la solicitud viaje remoto: $error');
      }
    } else {
      print('No se encontró ningún token.');
    }

    return travelList;
  }

  @override
  Future<int?> updateTravelLocal(
      {required int travelId,
      required List<String> fields,
      required List<String> values}) async {
    int request = 0;
    try {
      Map<String, Object?> updates = {};
      for (var i = 0; i < fields.length; i++) {
        updates[fields[i]] = values[i];
      }
      request = await database.update(LocalDB.tbTravel, updates, where: """
          ${LocalDB.idTravel} = ?
          """, whereArgs: [travelId]).timeout(const Duration(seconds: 300));
    } catch (error) {
      print('Error al realizar updateTRavelLocal: $error');
    }
    return request;
  }

  @override
  Future<int> updateTravelRemote(
      {required int travelId,
      required List<String> fields,
      required List<String> values}) async {
    int request = 0;

    return request;
  }

  @override
  Future<List<Passenger>> getPassangersRemote({required int travelId}) async {
    List<Passenger> passengersList = [];
    Response<dynamic> response;
    String? token = await AuthStorage().getToken();

    try {
      //Map<String, dynamic> parameters = {"id_trip": travelId.toString()};
      dio.options.headers['Authorization'] = 'Token $token';
      String url =
          _endPoints.baseUrl + _endPoints.getTravel + travelId.toString();
      response = await dio.get(
        url,
        //  queryParameters: parameters,
      );
      if (response.data != null) {
        List<dynamic> passengersData = response.data['passengers'];

        for (var passengerData in passengersData) {
          var passengerDetails = passengerData['passenger'];
          Passenger passenger = Passenger.fromJson({
            'id_passenger_trip': passengerData['id_passenger_trip'],
            'is_confirmed': passengerData['is_confirmed'],
            'pickup_point_lat': passengerData['pickup_point']['lat'],
            'pickup_point_long': passengerData['pickup_point']['long'],
            'phone_number': passengerDetails['phone_number'],
            'first_name': passengerDetails['first_name'],
            'last_name': passengerDetails['last_name'],
            'trip': travelId,
            'seats': passengerData['seats'],
          });
          passengersList.add(passenger);
        }
      } else {
        passengersList = [];
      }

      // travel = Travel.fromJson(response.data);
      // travelList.add(travel);
      //insertTravelsLocal(travels: travelList);
    } catch (error) {
      print('Error al realizar get pasajeros remoto: $error');
    }

    return passengersList;
  }

  @override
  Future<int> updatePassengerRemote(
      {required int passengerTripId, required bool valueConfirmed}) async {
    int sent = 0;
    Map<String, dynamic> _data = {"is_confirmed": valueConfirmed};
    String url =
        "${_endPoints.baseUrl}${_endPoints.patchPassengerTrip}${passengerTripId.toString()}/";
    try {
      dio.options.headers['Authorization'] = 'Token $token';
      Response response = await dio.patch(url, data: _data);
      print("$response");
      sent++;
    } catch (error) {
      print('Error al actualizar un pasajero : $error');
      return sent;
    }
    return sent;
  }

  @override
  Future<int> insertPassengerRemote({required Passenger passenger}) async {
    Response? response;
    int sent = 0;
    try {
      Map<String, dynamic> jsonPassengerTrip = passenger.toJson();
      print(jsonPassengerTrip);
      dio.options.headers['Authorization'] = 'Token $token';
      response = await dio.post(
          _endPoints.baseUrl + _endPoints.postPassengerTrip,
          data: jsonPassengerTrip);
      sent++;
    } catch (e) {
      return sent;
    }
    return sent;
  }

  @override
  Future<int> deletePassengerRemote({required int passengerId}) async {
    Response? response;
    String url =
        "${_endPoints.baseUrl}${_endPoints.patchPassengerTrip}${passengerId.toString()}/";
    int sent = 0;
    try {
      dio.options.headers['Authorization'] = 'Token $token';
      response = await dio.delete(url);
      print('response: --- $response');
      sent++;
    } catch (e) {
      return sent;
    }
    return sent;
  }

  @override
  Future<Response<Map<String, dynamic>>?> getTravelDetails(
      {required int travelId, required String finalUrl}) async {
    Response<Map<String, dynamic>>? response;
    try {
      dio.options.headers['Authorization'] = 'Token $token';
      String url = "${_endPoints.baseUrl}$finalUrl${travelId.toString()}/";
      print(url);
      response = await dio.get(
        url,
      );
    } catch (error) {
      print('Error al realizar get TravelDetails: $error');
    }

    return response;
  }
}

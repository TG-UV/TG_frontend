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

abstract class TravelDatasource {
  Future<void> insertTravelsLocal({required List<Travel> travels});
  Future<void> insertTravelRemote({required Travel travel});
  Future<void> getTravelLocal({required int travelId, String filter});
  Future<void> getTravelsRemote({required String finalEndPoint});
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

  TravelDatasourceMethods() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    database = await databaseProvider.database;
    token = await AuthStorage().getToken();
  }

  @override
  Future<void> insertTravelsLocal({required List<Travel> travels}) async {
    var i = 0;
    Travel currentTravel;
    try {
      while (i < travels.length) {
        currentTravel = travels[i];
        await database.insert(LocalDB.tbTravel, {
          LocalDB.idTravel: currentTravel.id,
          LocalDB.arrivalPoint: currentTravel.arrivalPoint,
          LocalDB.startingPoint: currentTravel.startingPoint,
          LocalDB.date: currentTravel.date,
          LocalDB.hour: currentTravel.hour,
          LocalDB.driver: currentTravel.driver,
          LocalDB.price: currentTravel.price,
          LocalDB.seats: currentTravel.seats,
          LocalDB.currentTrip: currentTravel.currentTrip,
        }).timeout(const Duration(seconds: 120));
        i++;
      }
    } catch (e) {
      print('Error al insertar un viaje Local' + e.toString());
    }
  }

  @override
  Future<int> insertTravelRemote({required Travel travel}) async {
    Response? response;
    int sent = 0;
    try {
      String? token = await AuthStorage().getToken();
      Map<String, dynamic> jsonTravel = travel.toJson();
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
      rethrow;
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
    Travel travel;
    List<Travel> travelList = [];
    Response<dynamic> response;

    if (token != null) {
      try {
        //Map<String, dynamic> parameters = {"id_trip": travelId};
        dio.options.headers['Authorization'] = 'Token $token';
        response = await dio.get(_endPoints.baseUrl + finalEndPoint
            //queryParameters: parameters,
            );

        for (var data in response.data['results']) {
          Travel travel = Travel.fromJson(data);
          travelList.add(travel);
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
    Passenger passenger;
    List<Passenger> passengersList = [];
    Response<dynamic> response;
    String? token = await AuthStorage().getToken();

    try {
      //Map<String, dynamic> parameters = {"id_trip": travelId.toString()};
      dio.options.headers['Authorization'] = 'Token $token';
      String url =
          _endPoints.baseUrl + _endPoints.getTravel + travelId.toString();
      print(url);
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
            'pickup_point': passengerData['pickup_point'],
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
    try {
      Response response = await dio.patch(
          _endPoints.baseUrl +
              _endPoints.patchPassengerTrip +
              passengerTripId.toString(),
          //queryParameters: {"id_passenger_trip": passengerTripId},
          data: {"is_confirmed": valueConfirmed});
      sent++;
    } catch (error) {
      print('Error al actualizar un pasajero : $error');
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
    int sent = 0;
    try {
      dio.options.headers['Authorization'] = 'Token $token';
      response = await dio.delete(
        _endPoints.baseUrl + _endPoints.patchPassengerTrip,
      );
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
    String? token = await AuthStorage().getToken();

    try {
      dio.options.headers['Authorization'] = 'Token $token';
      String url = _endPoints.baseUrl +
          finalUrl+
          travelId.toString();
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

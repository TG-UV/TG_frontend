import 'package:tg_frontend/device/local_tables.dart';
import 'package:tg_frontend/models/travel_model.dart';
import 'package:dio/dio.dart';
import 'package:tg_frontend/services/auth_services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tg_frontend/datasource/local_database_provider.dart';
import 'package:tg_frontend/datasource/endPoints/end_point.dart';

abstract class TravelDatasource {
  Future<void> insertTravelsLocal({required List<Travel> travels});
  Future<void> insertTravelRemote({required Travel travel});
  Future<void> getTravelLocal({required int travelId, String filter});
  Future<void> getTravelsRemote({required int travelId});
  Future<int?> updateTravelLocal(
      {required int travelId,
      required List<String> fields,
      required List<String> values});
  Future<int?> updateTravelRemote(
      {required int travelId,
      required List<String> fields,
      required List<String> values});
}

class TravelDatasourceMethods implements TravelDatasource {
  Dio dio = Dio();
  DatabaseProvider databaseProvider = DatabaseProvider.db;
  late Database database;
  final _endPoints = EndPoints();

  TravelDatasourceMethods() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    database = await databaseProvider.database;
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
    int send = 0;
    try {
      String? token = await AuthStorage().getToken();
      Map<String, dynamic> jsonTravel = travel.toJson();
      dio.options.headers['Authorization'] = 'Token $token';
      response = await dio.post(_endPoints.baseUrl + _endPoints.getTravel,
          data: jsonTravel);
      // String data = Travel.toJson(travels[send] as Travel);

      //  print(response.data);

      // await updateTravelLocal(
      //     travelId: int.parse(travels[send].id),
      //     fields: [Local.FIELD_SINCRONIZADO_ORDEN],
      //     values: [SINCRONIZADO.toString()]);
      send++;
    } catch (e) {
      rethrow;
    }
    return send;
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
  Future<List<Travel>> getTravelsRemote({required int travelId}) async {
    String? token = await AuthStorage().getToken();
    Travel travel;
    List<Travel> travelList = [];
    Response<dynamic> response;

    if (token != null) {
      try {
        Map<String, dynamic> parameters = {"id_trip": travelId};
        dio.options.headers['Authorization'] = 'Token $token';
        response = await dio.get(
          _endPoints.baseUrl + _endPoints.getTravel,
          queryParameters: parameters,
        );
        for (var data in response.data) {
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
      print('Error al realizar la solicitud viaje remoto: $error');
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
}

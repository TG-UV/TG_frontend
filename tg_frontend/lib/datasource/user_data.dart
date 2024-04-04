import 'package:get_it/get_it.dart';
import 'package:tg_frontend/datasource/endPoints/end_point.dart';
import 'package:tg_frontend/device/local_tables.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:tg_frontend/models/vehicle_model.dart';
import 'package:tg_frontend/services/auth_services.dart';
import 'package:tg_frontend/datasource/local_database_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:convert';

abstract class UserDatasource {
  Future<void> insertUserLocal({required User user});
  Future<int> insertUserRemote({required User user});
  Future<int> insertVehicleRemote({required Vehicle vehicle});
  Future<void> getUserRemote({required String endPoint});
  Future<Map<String, dynamic>?> getVehicleOptionsRemote();
  Future<String?> getUserAuth(
      {required String username, required String password});
  Future<User> getUserLocal();
  // Future<User> requestLoginUserRemote(
  //     {required String nick, required String password});
}

class UserDatasourceMethods implements UserDatasource {
  Dio dio = Dio();
  DatabaseProvider databaseProvider = DatabaseProvider.db;
  final _endPoints = EndPoints();
  String? token;

  late Database database;

  //final database = await databaseProvider.database;

  UserDatasourceMethods() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    database = await databaseProvider.database;
    token = await AuthStorage().getToken();
  }

  @override
  Future<int> insertUserRemote({required User user}) async {
    Response? response;
    int sent = 0;
    try {
      Map<String, dynamic> jsonUser = user.toJson();
      dio.options.headers['Authorization'] = 'Token $token';
      response = await dio.post(_endPoints.baseUrl + _endPoints.getAndPostUser,
          data: jsonUser);
      User userResponse = User.fromJson(response.data);
      insertUserLocal(user: userResponse);
      sent++;
    } catch (e) {
      rethrow;
    }
    return sent;
  }

  @override
  Future<int> insertVehicleRemote({required Vehicle vehicle}) async {
    Response? response;
    int sent = 0;
    try {
      Map<String, dynamic> jsonUser = vehicle.toJson();
      dio.options.headers['Authorization'] = 'Token $token';
      response = await dio.post(
          _endPoints.baseUrl + _endPoints.getAndPostVehicle,
          data: jsonUser);
      // User userResponse = User.fromJson(response.data);
      // insertUserLocal(user: userResponse);
      sent++;
    } catch (e) {
      rethrow;
    }
    return sent;
  }

  @override
  Future<void> insertUserLocal({required User user}) async {
    try {
      //final database = await databaseProvider.database;
      await database.insert(LocalDB.tbUser, {
        LocalDB.idUser: user.idUser,
        LocalDB.email: user.email,
        LocalDB.firstName: user.firstName,
        LocalDB.lastName: user.lastName,
        LocalDB.birthDate: user.birthDate,
        LocalDB.phoneNumber: user.phoneNumber,
        LocalDB.residenceCity: user.residenceCity,
        LocalDB.isActive: user.isActive,
        LocalDB.identityDocument: user.identityDocument,
        LocalDB.type: user.type,
      }).timeout(const Duration(seconds: 300));
    } catch (e) {
      print('Error al insertar user locar ' + e.toString());
    }
  }

  @override
  Future<User> getUserLocal() async {
    var response;
    // List<Map<String, dynamic>> userMaps;
    // User user;
    try {
      response = await database.query(
        LocalDB.tbUser,
        where: '${LocalDB.idUser} = ?',
        whereArgs: [14],
      ).timeout(const Duration(seconds: 300));

      // if (userMaps.isNotEmpty) {
      //  // insertUserLocal(user:  User.fromJson(userMaps.first));
      //   return User.fromJson(userMaps.first);
      // } else {
      //   return null;
      // }
    } catch (e) {
      print(e.toString());
    }
    User user = User.fromJson(response.first);
    return user;
  }

  @override
  Future<void> getUserRemote({required String endPoint}) async {
    String? token = await AuthStorage().getToken();
    User user;

    if (token != null) {
      try {
        dio.options.headers['Authorization'] = 'Token $token';
        Response response = await dio.get(endPoint);
        user = User.fromJson(response.data);
        print(user);
        insertUserLocal(user: user);
      } catch (error) {
        print('Error al realizar la solicitud: $error');
      }
    } else {
      print('No se encontró ningún token.');
    }
  }

  @override
  Future<Map<String, dynamic>?> getVehicleOptionsRemote() async {
    //String? token = await AuthStorage().getToken();
    token = '0e82ae3cb06e3e4611ee2b3986951a2720659243';
    Map<String, dynamic>? options;

    if (token != null) {
      try {
        dio.options.headers['Authorization'] = 'Token $token';
        Response response =
            await dio.get(_endPoints.baseUrl + _endPoints.getVehicleOptions);
        options = json.decode(response.data);
      } catch (error) {
        print('Error al realizar la solicitud vehiclesOptions: $error');
      }
    } else {
      print('No se encontró ningún token.');
    }
    return options;
  }

  @override
  Future<String?> getUserAuth(
      {required String username, required String password}) async {
    String? token;
    try {
      var response = await dio.post(
        _endPoints.baseUrl + _endPoints.getUserAuth,
        data: {"password": password, "email": username},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = Map.from(response.data);
        token = responseData['auth_token'];
      }
    } catch (error) {
      // Maneja los errores de autenticación aquí.
      print('Error al autenticar: $error');
    }
    return token;
  }
}

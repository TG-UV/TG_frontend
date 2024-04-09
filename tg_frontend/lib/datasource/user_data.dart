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
  Future<int> insertUserLocal({required User user});
  Future<int> insertUserRemote({required User user});
  Future<int> insertVehicleRemote({required Vehicle vehicle});
  Future<void> getUserRemote({required String endPoint});
  Future<Map<String, dynamic>?> getVehicleOptionsRemote();
  Future<String?> getUserAuth(
      {required String username, required String password});
  Future<User> getUserLocal(int idUser);
  Future<List<dynamic>?> getUserCitiesRemote();
}

class UserDatasourceMethods implements UserDatasource {
  Dio dio = Dio();
  DatabaseProvider databaseProvider = DatabaseProvider.db;
  final _endPoints = EndPoints();
  String? token;

  late Database database;

  UserDatasourceMethods() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    database = await databaseProvider.database;
    token = await AuthStorage().getToken();
    print('token: --------------- $token');
    //token = "0e82ae3cb06e3e4611ee2b3986951a2720659243";
  }

  @override
  Future<int> insertUserRemote({required User user}) async {
    Response? response;
    User userResponse;
    int sent = 0;
    try {
      Map<String, dynamic> jsonUser = user.toJson();
            //dio.options.headers['Authorization'] = 'Token $token';
      response = await dio.post(_endPoints.baseUrl + _endPoints.getAndPostUser,
          data: jsonUser);
      userResponse = User.fromJson(response.data);
      insertUserLocal(user: userResponse);
      sent++;
    } catch (e) {
      rethrow;
    }
    return userResponse.idUser;
  }

  @override
  Future<int> insertVehicleRemote({required Vehicle vehicle}) async {
    Response? response;
    int sent = 0;
    try {
      Map<String, dynamic> jsonUser = vehicle.toJson();
      dio.options.headers['Authorization'] = 'Token $token';
      response = await dio.post(
          _endPoints.baseUrl + _endPoints.postVehicle,
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
  Future<int> insertUserLocal({required User user}) async {
    int sent=0;
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
      sent ++;
    } catch (e) {
      print('Error al insertar user locar ' + e.toString());
    }
    return sent;
  }

  @override
  Future<User> getUserLocal(int idUser) async {
    var response;
    try {
      response = await database.query(
        LocalDB.tbUser,
        where: '${LocalDB.idUser} = ?',
        whereArgs: [idUser],
      ).timeout(const Duration(seconds: 300));
    } catch (e) {
      print(e.toString());
    }
    User user = User.fromJson(response.first);
    return user;
  }

  @override
  Future<int> getUserRemote({required String endPoint}) async {
    String? token = await AuthStorage().getToken();
    User user;
    int idUser = 0;

    if (token != null) {
      try {
        dio.options.headers['Authorization'] = 'Token $token';
        Response response = await dio.get(endPoint);
        user = User.fromJson(response.data);
        idUser = user.idUser;
        print(user);
        insertUserLocal(user: user);
      } catch (error) {
        print('Error al realizar la solicitud: $error');
      }
    } else {
      print('No se encontró ningún token.');
    }
    return idUser;
  }

  @override
  Future<Map<String, dynamic>?> getVehicleOptionsRemote() async {
    
    Map<String, dynamic>? options;

    if (token != null) {
      try {
        //dio.options.headers['Authorization'] = 'Token $token';
        Response response =
            await dio.get(_endPoints.baseUrl + _endPoints.getVehicleOptions);
        if (response.data is Map<String, dynamic>) {
          options = response.data;
        }
        print('response data $options');
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
      print('Error al autenticar: $error');
    }
    return token;
  }

    @override
  Future<List<dynamic>?> getUserCitiesRemote() async {
    
    List<dynamic>? citiesOptions;
      try {
        //dio.options.headers['Authorization'] = 'Token $token';
         Response response =
            await dio.get(_endPoints.baseUrl + _endPoints.getCities);
            //citiesOptions = response.data;
        if (response.data is List<dynamic>?) {
          citiesOptions = response.data;
        }
        
      } catch (error) {
        print('Error al realizar la solicitud vehiclesOptions: $error');
      }
   
    return citiesOptions;
  }

}

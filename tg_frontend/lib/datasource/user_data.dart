import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tg_frontend/datasource/endPoints/end_point.dart';
import 'package:tg_frontend/datasource/local_database_provider.dart';
import 'package:tg_frontend/device/environment.dart';
import 'package:tg_frontend/device/local_tables.dart';
import 'package:tg_frontend/errors.dart/exceptions.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:tg_frontend/models/vehicle_model.dart';
import 'package:tg_frontend/services/auth_services.dart';

abstract class UserDatasource {
  Future<int> insertUserLocal({required User user, context});
  Future<int?> insertUserRemote({required User user, context});
  Future<void> postUserSendEmail({required String userEmail, context});
  Future<int?> postUserSetPassword(
      {required String currentPassword, required String newPassword, context});
  Future<int?> insertVehicleRemote({required Vehicle vehicle, context});
  Future<int?> updateVehicelRemote(
      {required int vehicleId, required Vehicle vehicle});
  Future<int> getUserRemote(context);
  Future<Map<String, dynamic>?> getVehicleOptionsRemote(context);
  Future<List<Vehicle>?> getVehiclesDriver(context);
  Future<String?> getUserAuth(
      {required String username,
      required String password,
      required String idDevice,
      context});
  Future<void> postReSetPassword(
      {required String email, required BuildContext context});
  Future<User> getUserLocal(int idUser);
  Future<List<dynamic>?> getUserCitiesRemote(conext);
}

class UserDatasourceMethods implements UserDatasource {
  Dio dio = Dio();
  DatabaseProvider databaseProvider = DatabaseProvider.db;
  final _endPoints = EndPoints();
  String? token;
  String serverErrorString = "Lo sentimos, tenemos un error en el servidor, ";

  late Database database;

  UserDatasourceMethods() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    database = await databaseProvider.database;

    token = await AuthStorage().getToken();
    //token = "0e82ae3cb06e3e4611ee2b3986951a2720659243";
  }

  @override
  Future<int?> insertUserRemote({required User user, context}) async {
    int send = 0;
    try {
      Map<String, dynamic> jsonUser = user.toJson();
      Response response = await dio
          .post(_endPoints.baseUrl + _endPoints.getAndPostUser, data: jsonUser);
      if (response.statusCode == 200 || response.statusCode == 201) {
        User userResponse = User.fromJson(response.data);
        Environment.sl.registerSingleton<User>(userResponse);
        send++;
        return send;
      }
    } on DioException catch (e) {
      ErrorOrAdviceHandler.showErrorAlert(
          context, serverErrorString + e.response!.data.toString(), true);
    }
    return send;
  }

  @override
  Future<void> postUserSendEmail({required String userEmail, context}) async {
    var response;
    Map<String, dynamic> _data = {"email": userEmail};

    try {
      dio.options.headers['Authorization'] = 'Token $token';
      response = await dio.post(
          _endPoints.baseUrl + _endPoints.postUserReSendActivation,
          data: _data);
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 203 ||
          response.statusCode == 204) {
        ErrorOrAdviceHandler.showErrorAlert(context, "Correo enviado", true);
      }
    } on DioException catch (e) {
      ErrorOrAdviceHandler.showErrorAlert(
          context, serverErrorString + e.response!.data.toString(), true);
    }
  }

  @override
  Future<int?> postUserSetPassword(
      {required String currentPassword,
      required String newPassword,
      context}) async {
    Map<String, dynamic> _data = {
      "new_password": newPassword,
      "current_password": currentPassword
    };
    int? sent;

    try {
      dio.options.headers['Authorization'] = 'Token $token';
      Response response = await dio.post(
        _endPoints.baseUrl + _endPoints.postSetPassword,
        data: _data,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        sent = 1;
      }
    } on DioException catch (e) {
      ErrorOrAdviceHandler.showErrorAlert(
          context, serverErrorString + e.response!.data.toString(), true);
    }
    return sent;
  }

  @override
  Future<int?> insertVehicleRemote({required Vehicle vehicle, context}) async {
    int? sent;
    try {
      Map<String, dynamic> jsonUser = vehicle.toJson();

      dio.options.headers['Authorization'] = 'Token $token';
      Response response = await dio
          .post(_endPoints.baseUrl + _endPoints.postVehicle, data: jsonUser);

      if (response.statusCode == 200 || response.statusCode == 201) {
        sent = 1;
      }
    } on DioException catch (e) {
      ErrorOrAdviceHandler.showErrorAlert(
          context, serverErrorString + e.response!.data.toString(), true);
    }
    return null;
  }

  @override
  Future<int?> updateVehicelRemote(
      {required int vehicleId, required Vehicle vehicle, context}) async {
    int? sent;
    try {
      Map<String, dynamic> jsonUser = vehicle.toJson();
      String url =
          _endPoints.baseUrl + _endPoints.postVehicle + vehicleId.toString();
      dio.options.headers['Authorization'] = 'Token $token';
      Response response = await dio.put(url, data: jsonUser);
      if (response.statusCode == 200 || response.statusCode == 201) {
        sent = 1;
      }
    } on DioException catch (e) {
      ErrorOrAdviceHandler.showErrorAlert(
          context, serverErrorString + e.response!.data.toString(), true);
    }
    return sent;
  }

  @override
  Future<int> insertUserLocal({required User user, context}) async {
    int sent = 0;
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
      sent++;
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
  Future<int> getUserRemote(context) async {
    User user;
    int send = 0;
    token = await AuthStorage().getToken();
    try {
      dio.options.headers['Authorization'] = 'Token $token';
      Response response =
          await dio.get(_endPoints.baseUrl + _endPoints.getUserLogged);
      if (response.statusCode == 200 || response.statusCode == 201) {
        user = User.fromJson(response.data);
        Environment.sl.registerSingleton<User>(user);
        send++;
        return send;
        //idUser = user.idUser;
        //insertUserLocal(user: user);
      }
    } on DioException catch (e) {
      ErrorOrAdviceHandler.showErrorAlert(
          context, serverErrorString + e.response!.data.toString(), true);
    }
    return send;
  }

  @override
  Future<Map<String, dynamic>?> getVehicleOptionsRemote(context) async {
    Map<String, dynamic>? options;

    try {
      Response response =
          await dio.get(_endPoints.baseUrl + _endPoints.getVehicleOptions);
      if (response.statusCode == 200 || response.statusCode == 201) {
        options = response.data;
        return options;
      }
    } on DioException catch (e) {
      ErrorOrAdviceHandler.showErrorAlert(
          context, serverErrorString + e.response!.data.toString(), true);
    }
    return options;
  }

  @override
  Future<List<Vehicle>?> getVehiclesDriver(context) async {
    List<Vehicle>? vehicles = [];

    try {
      dio.options.headers['Authorization'] = 'Token $token';
      Response response =
          await dio.get(_endPoints.baseUrl + _endPoints.getVehiclesDriver);
      if (response.statusCode == 200 || response.statusCode == 201) {
        for (var data in response.data) {
          Vehicle vehicle = Vehicle.fromJson(data);
          vehicles.add(vehicle);
        }
        return vehicles;
      }
    } on DioException catch (e) {
      ErrorOrAdviceHandler.showErrorAlert(
          context, serverErrorString + e.response!.data.toString(), true);
    }
    return vehicles;
  }

  @override
  Future<String?> getUserAuth(
      {required String username,
      required String password,
      required String idDevice,
      context}) async {
    String? token;
    try {
      var response = await dio.post(
        _endPoints.baseUrl + _endPoints.getUserAuth,
        data: {"password": password, "email": username, "id_device": idDevice},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData = Map.from(response.data);
        token = responseData['auth_token'];
        await AuthStorage().saveToken(token!);
        return token;
      }
    } on DioException catch (e) {
      ErrorOrAdviceHandler.showErrorAlert(
          context, serverErrorString + e.response!.data.toString(), true);
    }
    return token;
  }

  @override
  Future<void> postReSetPassword(
      {required String email, required BuildContext context}) async {
    try {
      Response response = await dio.post(
          _endPoints.baseUrl + _endPoints.postReSetPassword,
          data: {"email": email});
      print(response.statusCode);
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 203 ||
          response.statusCode == 204) {
        ErrorOrAdviceHandler.showErrorAlert(
            context,
            "Correo enviado con éxito, ingrese al correo que ingresó para restablecer su contraseña",
            true);
      }
    } on DioException catch (e) {
      print("error al ernviar correos ${e.toString()}");
      ErrorOrAdviceHandler.showErrorAlert(
          context, "Formato invalido, intente de nuevo", true);
    }
    //return null;
  }

  @override
  Future<List<dynamic>?> getUserCitiesRemote(context) async {
    List<dynamic>? citiesOptions;
    try {
      //dio.options.headers['Authorization'] = 'Token $token';
      Response response =
          await dio.get(_endPoints.baseUrl + _endPoints.getCities);
      if (response.statusCode == 200 || response.statusCode == 201) {
        citiesOptions = response.data;
        return citiesOptions;
      }
    } on DioException catch (e) {
      ErrorOrAdviceHandler.showErrorAlert(
          context, serverErrorString + e.response!.data.toString(), true);
    }
    return citiesOptions;
  }
}

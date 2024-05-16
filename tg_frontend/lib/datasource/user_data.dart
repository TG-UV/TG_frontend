import 'package:get_it/get_it.dart';
import 'package:tg_frontend/datasource/endPoints/end_point.dart';
import 'package:tg_frontend/device/local_tables.dart';
import 'package:tg_frontend/errors.dart/exceptions.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:tg_frontend/models/vehicle_model.dart';
import 'package:tg_frontend/services/auth_services.dart';
import 'package:tg_frontend/datasource/local_database_provider.dart';
import 'package:sqflite/sqflite.dart';

abstract class UserDatasource {
  Future<int> insertUserLocal({required User user});
  Future<dynamic> insertUserRemote({required User user});
  Future<void> postUserSendEmail({required String userEmail});
  Future<dynamic> postUserSetPassword(
      {required String currentPassword, required String newPassword});
  Future<dynamic> insertVehicleRemote({required Vehicle vehicle, context});
  Future<dynamic> updateVehicelRemote(
      {required int vehicleId, required Vehicle vehicle});
  Future<void> getUserRemote();
  Future<Map<String, dynamic>?> getVehicleOptionsRemote(context);
  Future<List<Vehicle>?> getVehiclesDriver(context);
  Future<String?> getUserAuth(
      {required String username,
      required String password,
      required String idDevice,
      context});
  Future<void> postReSetPassword({required String email});
  Future<User> getUserLocal(int idUser);
  Future<List<dynamic>?> getUserCitiesRemote();
}

class UserDatasourceMethods implements UserDatasource {
  Dio dio = Dio();
  DatabaseProvider databaseProvider = DatabaseProvider.db;
  final _endPoints = EndPoints();
  String? token;
  String serverErrorString = "Lo sentimos, tenemos un error en el servidor: ";

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
  Future<dynamic> insertUserRemote({required User user}) async {
    try {
      Map<String, dynamic> jsonUser = user.toJson();
      Response response = await dio
          .post(_endPoints.baseUrl + _endPoints.getAndPostUser, data: jsonUser);
      if (response.statusCode == 200) {
        User userResponse = User.fromJson(response.data);
        insertUserLocal(user: userResponse);
        return userResponse.idUser;
      } else {
        return 'Error: Código de estado ${response.statusCode}';
      }
    } on DioException catch (e) {
      print(e.response!.data.toString());
      // return e.response!.data.toString();
      return "Error de conexión ${e.response!.data.toString()}";
    }
  }

  @override
  Future<void> postUserSendEmail({required String userEmail}) async {
    var response;
    Map<String, dynamic> _data = {"email": userEmail};

    try {
      dio.options.headers['Authorization'] = 'Token $token';
      response = await dio.post(
        _endPoints.baseUrl + _endPoints.postUserActivation,
        data: _data,
      );
    } catch (e) {
      print("error al reenviar el email de confirmación $response");
    }
  }

  @override
  Future<dynamic> postUserSetPassword(
      {required String currentPassword, required String newPassword}) async {
    var response;
    int sent = 0;
    Map<String, dynamic> _data = {
      "new_password": newPassword,
      "current_password": currentPassword
    };

    try {
      dio.options.headers['Authorization'] = 'Token $token';
      response = await dio.post(
        _endPoints.baseUrl + _endPoints.postSetPassword,
        data: _data,
      );
      sent++;
    } catch (e) {
      print("error al cambiar contraseña $response");
      return response.toString();
    }
    return sent;
  }

  @override
  Future<int?> insertVehicleRemote({required Vehicle vehicle, context}) async {
    Response? response;

    try {
      Map<String, dynamic> jsonUser = vehicle.toJson();

      dio.options.headers['Authorization'] = 'Token $token';
      response = await dio.post(_endPoints.baseUrl + _endPoints.postVehicle,
          data: jsonUser);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return 1;
      } else {
        print("llega a 1");
        ErrorHandler.showErrorAlert(context, response.data.toString());
      }
    } on DioException catch (e) {
      print("llega a 2");

      ErrorHandler.showErrorAlert(
          context, serverErrorString + e.response!.data.toString());
    }
    // User userResponse = User.fromJson(response.data);
    // insertUserLocal(user: userResponse);
  }

  @override
  Future<dynamic> updateVehicelRemote(
      {required int vehicleId, required Vehicle vehicle}) async {
    Response? response;
    int sent = 0;
    try {
      Map<String, dynamic> jsonUser = vehicle.toJson();
      String url =
          _endPoints.baseUrl + _endPoints.postVehicle + vehicleId.toString();
      dio.options.headers['Authorization'] = 'Token $token';
      response = await dio.put(url, data: jsonUser);
      // User userResponse = User.fromJson(response.data);
      // insertUserLocal(user: userResponse);
      sent++;
    } catch (e) {
      return response!.statusMessage;
    }
    return sent;
  }

  @override
  Future<int> insertUserLocal({required User user}) async {
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
  Future<int> getUserRemote() async {
    String? token = await AuthStorage().getToken();
    User user;
    int idUser = 0;

    if (token != null) {
      try {
        dio.options.headers['Authorization'] = 'Token $token';
        Response response =
            await dio.get(_endPoints.baseUrl + _endPoints.getUserLogged);
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
  Future<Map<String, dynamic>?> getVehicleOptionsRemote(context) async {
    Map<String, dynamic>? options;

    try {
      Response response =
          await dio.get(_endPoints.baseUrl + _endPoints.getVehicleOptions);
      if (response.statusCode == 200) {
        options = response.data;
      } else {
        ErrorHandler.showErrorAlert(context, response.data);
      }
    } on DioException catch (e) {
      ErrorHandler.showErrorAlert(
          context, serverErrorString + e.response!.data["detail"]);
    }

    // try {
    //   Response response =
    //       await dio.get(_endPoints.baseUrl + _endPoints.getVehicleOptions);
    //   if (response.data is Map<String, dynamic>) {
    //     options = response.data;
    //   }
    //   print('response data $options');
    // } catch (error) {
    //   print('Error al realizar la solicitud vehiclesOptions: $error');
    // }

    return options;
  }

  @override
  Future<List<Vehicle>?> getVehiclesDriver(context) async {
    List<Vehicle>? vehicles = [];

    try {
      //  dio.options.headers['Authorization'] = 'Token $token';
      Response response =
          await dio.get(_endPoints.baseUrl + _endPoints.getVehiclesDriver);
      if (response.statusCode == 200) {
        for (var data in response.data) {
          Vehicle vehicle = Vehicle.fromJson(data);
          vehicles.add(vehicle);
        }
      } else {
        ErrorHandler.showErrorAlert(context, response.data);
      }
    } on DioException catch (e) {
      ErrorHandler.showErrorAlert(
          context, serverErrorString + e.response!.data["detail"]);
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

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = Map.from(response.data);
        token = responseData['auth_token'];
        return token;
      }
    } on DioException catch (e) {
      if (e.response!.statusCode != 200) {
        ErrorHandler.showErrorAlert(context, e.response!.data.toString());
      } else {
        ErrorHandler.showErrorAlert(
            context, serverErrorString + e.response!.data["detail"]);
      }
    }
  }

  @override
  Future<void> postReSetPassword({required String email}) async {
    try {
      await dio.post(
        _endPoints.baseUrl + _endPoints.postReSetPassword,
        data: {"email": email},
      );
    } catch (error) {
      print('Error al reSetPassword: $error');
    }
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

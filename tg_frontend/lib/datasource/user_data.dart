import 'package:get_it/get_it.dart';
import 'package:tg_frontend/device/local_tables.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:tg_frontend/services/auth_services.dart';
import 'package:tg_frontend/datasource/local_database_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart';


abstract class UserDatasource {
  Future<void> insertUserLocal({required User user});
  Future<void> getUserRemote({required String endPoint});
  Future<String?> getUserAuth(
      {required String endPoint,
      required String username,
      required String password});
  Future<User> getUserLocal();
  // Future<User> requestLoginUserRemote(
  //     {required String nick, required String password});
}

class UserDatasourceMethods implements UserDatasource {
  Dio dio = Dio();
  DatabaseProvider databaseProvider = DatabaseProvider.db;
  
  late Database database;

  //final database = await databaseProvider.database;

  UserDatasourceMethods() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    database = await databaseProvider.database;
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

        //LocalDB.registrationDate: user.registrationDate,
      }).timeout(const Duration(seconds: 300));
    } catch (e) {
      print('Error al insertar user locar' + e.toString());
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
        whereArgs: [4],
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
        insertUserLocal(user: user);
      } catch (error) {
        print('Error al realizar la solicitud: $error');
      }
    } else {
      print('No se encontró ningún token.');
    }
  }

  @override
  Future<String?> getUserAuth(
      {required String endPoint,
      required String username,
      required String password}) async {
    String? token;
    try {
      var response = await dio.post(
        endPoint,
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

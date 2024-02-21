import 'package:tg_frontend/device/local_tables.dart';
import 'package:tg_frontend/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:tg_frontend/services/auth_services.dart';
import 'package:tg_frontend/datasource/local_database.dart';
import 'package:sqflite/sqflite.dart';

abstract class UserDatasource {
  Future<void> insertUserLocal({required User user});
  Future<void> getUserRemote({required String endPoint});
  Future<User?> getFieldUserLocal();
  // Future<User> requestLoginUserRemote(
  //     {required String nick, required String password});
}

class UserDatasourceImpl implements UserDatasource {
  final Dio dio;
  final Database database;
  //AuthStorage? authStorage;

  //final database = await databaseProvider.database;

  UserDatasourceImpl(this.dio, this.database);

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
        LocalDB.type: user.type,
        LocalDB.identityDocument: user.identityDocument,

        //LocalDB.registrationDate: user.registrationDate,
      }).timeout(const Duration(seconds: 300));
    } catch (e) {
      print('Error al insertar user locar' + e.toString());
    }
  }

  @override
  Future<User?> getFieldUserLocal() async {
    try {
      //final database = await databaseProvider.database;
      List<Map<String, dynamic>> userMaps = await database.query(
        LocalDB.tbUser,
        where: '${LocalDB.idUser} = ?',
        whereArgs: [4],
      ).timeout(const Duration(seconds: 300));

      if (userMaps.isNotEmpty) {
        // Si se encontró un usuario con el ID especificado, construye y devuelve un objeto User
        return User.fromJson(userMaps.first);
      } else {
        // Si no se encontró ningún usuario con el ID especificado, devuelve null
        return null;
      }
    } catch (e) {
      // Manejar cualquier error que ocurra durante la consulta
      print(e.toString());
      return null;
    }
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
        //user = response.data["user"] as String;
        print('Respuesta del servidor: ${response.data}');
      } catch (error) {
        print('Error al realizar la solicitud: $error');
      }
    } else {
      print('No se encontró ningún token.');
    }
  }
}

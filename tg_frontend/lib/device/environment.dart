//import "package:sqflite/sqlite_api.dart";
//import 'package:tg_frontend/device/local_datasource.dart';
import 'package:dio/dio.dart';
import 'package:tg_frontend/datasource/local_database_provider.dart';
import "package:get_it/get_it.dart";
import 'package:tg_frontend/datasource/travel_data.dart';
import 'package:tg_frontend/datasource/user_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tg_frontend/models/user_model.dart';

class Environment {
  static GetIt sl = GetIt.instance;
  late UserDatasourceMethods userDatasourseImpl;
  late TravelDatasourceMethods travelDatasourceImpl;
  late User user;

  Future<void> startEnvironment() async {
    Database database = await _initDatabase();
    Dio dio = Dio();
    userDatasourseImpl = UserDatasourceMethods();
    travelDatasourceImpl = TravelDatasourceMethods();
    sl.registerSingleton<UserDatasourceMethods>(userDatasourseImpl);
    sl.registerSingleton<TravelDatasourceMethods>(travelDatasourceImpl);
  }

  Future<Database> _initDatabase() async {
    final databaseProvider = DatabaseProvider.db;
    await databaseProvider.initDB();
    Database db = await databaseProvider.database;
    return db;
  }
}

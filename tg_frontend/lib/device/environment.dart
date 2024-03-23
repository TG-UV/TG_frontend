//import "package:sqflite/sqlite_api.dart";
//import 'package:tg_frontend/device/local_datasource.dart';
import 'package:dio/dio.dart';
import 'package:tg_frontend/datasource/local_database_provider.dart';
import "package:get_it/get_it.dart";
import 'package:tg_frontend/datasource/user_data.dart';
import 'package:tg_frontend/screens/loginAndRegister/login.dart';
import 'package:sqflite/sqflite.dart';

class Environment {
  static GetIt sl = GetIt.instance;
  late UserDatasourceMethods userDatasourseImpl;

  //late var dba = null;
  //final Database db = await Db.openDb();
  // static bool running = false;
  // static late var sendPort;
  // static late var response_port;
  // RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;

  Future<void> startEnvironment() async {
    Database database = await _initDatabase();
    Dio dio = Dio();
    userDatasourseImpl = UserDatasourceMethods();
    //Environment.sl.registerLazySingleton(
  }

  Future<Database> _initDatabase() async {
    final databaseProvider = DatabaseProvider.db;
    await databaseProvider.initDB();
    Database db = await databaseProvider.database;
    return db;
  }

  // sl.registerLazySingleton<DatabaseProvider>(() => DatabaseProvider.db);
  // final databaseProvider = sl<DatabaseProvider>();
  // await databaseProvider.initDB();
}
  //  void startEnvironment() async {
  //    final Database db = await Db.openDb();
  //  }

  // openDb() async {
  //   //dba ??= dba = await Db.openDb  ();
  //   sl.registerLazySingleton<DatabaseProvider>(() => dba);
  // }


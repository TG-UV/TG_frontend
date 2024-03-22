import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:tg_frontend/device/local_tables.dart';

class DatabaseProvider extends ChangeNotifier {
  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();
  late Database _database; //SQLite

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "rayo_database.db");
    _database = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    // Aquí puedes ejecutar cualquier sentencia SQL para crear tus tablas
    await db.execute(LocalDB.tableInsertUser);
    // Asegúrate de notificar a los widgets que dependen de la base de datos
    //notifyListeners();
  }

  // static cleanTable(String tableName) async{
  //   await Environment.sl<Database>().delete(tableName);
  // }

  static cleanDatabase() async {
    // await Environment.sl<Database>().delete(LocalDB.TB_TIPO);
    // await Environment.sl<Database>().delete(LocalDB.TB_PROGRAMA);
    // await Environment.sl<Database>().delete(LocalDB.TB_ORDEN);
    // await Environment.sl<Database>().delete(LocalDB.TB_ORDEN_FOTO);
    // await Environment.sl<Database>().delete(LocalDB.TB_USUARIO);
    // await Environment.sl<Database>().delete(LocalDB.TB_LOG);
    // await Environment.sl<Database>().delete(LocalDB.TB_FECHA);
    // await Environment.sl<Database>().delete(LocalDB.TB_MEDIDOR_ENCONTRADO);
    // await Environment.sl<Database>().delete(LocalDB.TB_ORDEN_MEDIDOR);
    // await Environment.sl<Database>().delete(LocalDB.TB_ORDEN_LECTURA);
    // await Environment.sl<Database>().delete(LocalDB.TB_TIPO_RELACION);
    // await Environment.sl<Database>().delete(LocalDB.TB_GEOLOCALIZADOR);
    // await Environment.sl<Database>().delete(LocalDB.TB_ORDEN_CLIENTE);
    // await Environment.sl<Database>().delete(LocalDB.TB_ORDEN_MATERIAL);
    // await Environment.sl<Database>().delete(LocalDB.TB_MATERIAL);
    // await Environment.sl<Database>().delete(LocalDB.TB_BODEGA);
  }
}

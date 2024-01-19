import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  final storage = const FlutterSecureStorage();

  // Método para guardar el token
  Future<void> saveToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  // Método para obtener el token
  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  // Método para eliminar el token (por ejemplo, al cerrar sesión)
  Future<void> deleteToken() async {
    await storage.delete(key: 'token');
  }
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  final storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await storage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> deleteToken() async {
    await storage.delete(key: 'token');
  }

  Future<void> saveNickname(String nickname) async {
    await storage.write(key: 'nickname', value: nickname);
  }

  Future<String?> getNickName() async {
    return await storage.read(key: 'nickname');
  }

  Future<void> savePassword(String password) async {
    await storage.write(key: 'password', value: password);
  }

  Future<String?> getPassword() async {
    return await storage.read(key: 'password');
  }

  Future<void> removeValues() async {
    await storage.delete(key: 'password');
    await storage.delete(key: 'nickname');
    await storage.delete(key: 'token');
  }
}

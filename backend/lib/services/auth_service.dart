import '../config/database.dart';
import 'package:mysql1/mysql1.dart';

class AuthService {
  Future<Map<String, dynamic>?> login(String email, String password) async {
    MySqlConnection? conn;
    try {
      conn = await getConnection();
      var results = await conn.query(
        'SELECT id, nom, email FROM users WHERE email = ? AND password = ?',
        [email, password],
      );

      if (results.isNotEmpty) {
        final user = Map<String, dynamic>.from(results.first.fields);
        user['token'] = 'dummy-token-${user['id']}';
        return user;
      }
      return null;
    } catch (e) {
      print('Erreur AuthService.login: $e');
      rethrow;
    } finally {
      await conn?.close();
    }
  }

  Future<void> register(String nom, String email, String password) async {
    MySqlConnection? conn;
    try {
      conn = await getConnection();
      await conn.query(
        'INSERT INTO users (nom, email, password) VALUES (?, ?, ?)',
        [nom, email, password],
      );
    } catch (e) {
      print('Erreur AuthService.register: $e');
      rethrow;
    } finally {
      await conn?.close();
    }
  }
}

import '../config/database.dart';


class AuthService {
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final conn = await getConnection();
    try {
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
    } finally {
      await conn.close(); // conn.close() garanti même en cas d'erreur
    }
  }

  Future<void> register(String nom, String email, String password) async {
    final conn = await getConnection();
    try {
      await conn.query(
        'INSERT INTO users (nom, email, password) VALUES (?, ?, ?)',
        [nom, email, password],
      );
    } finally {
      await conn.close();
    }
  }
}
import '../config/database.dart';
import 'package:mysql1/mysql1.dart';
import 'package:bcrypt/bcrypt.dart';

class AuthService {
  Future<Map<String, dynamic>?> login(String email, String password) async {
    MySqlConnection? conn;
    try {
      conn = await getConnection();
      
      // On récupère l'utilisateur par son email
      var results = await conn.query(
        'SELECT * FROM users WHERE email = ?',
        [email],
      );

      if (results.isEmpty) return null;

      final user = Map<String, dynamic>.from(results.first.fields);
      final storedHash = user['password'] as String;

      // Vérification sécurisée du mot de passe
      if (BCrypt.checkpw(password, storedHash)) {
        // On génère un token factice
        user['token'] = 'dummy-token-${user['id']}';
        // Sécurité : on supprime le hash du mot de passe avant de renvoyer l'objet
        user.remove('password');
        return user;
      }
      
      return null;
    } catch (e) {
      print('Erreur AuthService.login: $e');
      rethrow;
    } finally {
      // On ferme toujours la connexion
      await conn?.close();
    }
  }

  Future<void> register(String nom, String email, String password) async {
    MySqlConnection? conn;
    
    // Hachage du mot de passe avant l'insertion
    final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
    
    try {
      conn = await getConnection();
      await conn.query(
        'INSERT INTO users (nom, email, password) VALUES (?, ?, ?)',
        [nom, email, hashedPassword],
      );
      print('Utilisateur $email enregistré avec mot de passe sécurisé.');
    } catch (e) {
      print('Erreur AuthService.register: $e');
      rethrow;
    } finally {
      await conn?.close();
    }
  }
}

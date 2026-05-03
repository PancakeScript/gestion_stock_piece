import 'package:mysql1/mysql1.dart';

Future<MySqlConnection> getConnection() async {
  try {
    final conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: '127.0.0.1', // IMPORTANT
        port: 3306,
        user: 'root',
        // PAS de password si vide dans XAMPP
        db: 'gestion_stock_piece',
      ),
    );

    print(' Connexion MySQL réussie');
    return conn;

  } catch (e) {
    print(' Erreur connexion MySQL: $e');
    rethrow;
  }
}
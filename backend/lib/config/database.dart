//configuration pour la BD
import 'package:mysql1/mysql1.dart';

Future<MySqlConnection> getConnection() async {
  return await MySqlConnection.connect(
    ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      password: '',
      db: 'gestion_stock_piece',
    ),
  );
}

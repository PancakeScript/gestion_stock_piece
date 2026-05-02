import '../config/database.dart';

class FournisseurService {
  Future<List<Map>> getAll() async {
    final conn = await getConnection();
    var results = await conn.query('SELECT * FROM fournisseurs');

    List<Map> data = [];
    for (var row in results) {
      data.add(row.fields);
    }

    await conn.close();
    return data;
  }

  Future<void> add(String nom, String tel) async {
    final conn = await getConnection();

    await conn.query(
      'INSERT INTO fournisseurs (nomFr, telephoneFr) VALUES (?, ?)',
      [nom, tel],
    );

    await conn.close();
  }
}
import '../config/database.dart';

class PieceService {
  Future<List<Map>> getAll() async {
    final conn = await getConnection();
    var results = await conn.query('SELECT * FROM pieces');

    List<Map> data = [];
    for (var row in results) {
      data.add(row.fields);
    }

    await conn.close();
    return data;
  }

  Future<void> add(String nom, String ref, double prix) async {
    final conn = await getConnection();

    await conn.query(
      'INSERT INTO pieces (nomPiece, reference, prix, quantite_stock) VALUES (?, ?, ?, 0)',
      [nom, ref, prix],
    );

    await conn.close();
  }
}
import '../config/database.dart';

class PieceService {
  Future<List<Map>> getAll() async {
    final conn = await getConnection();
    var results = await conn.query('SELECT * FROM piece');
    List<Map> data = [];
    for (var row in results) {
      data.add(row.fields);
    }
    await conn.close();
    return data;
  }

  Future<void> add(String nom, String ref, double prix, int? categorieId) async {
    final conn = await getConnection();
    await conn.query(
      'INSERT INTO piece (nomPiece, reference, prix, quantite_stock, idCat) VALUES (?, ?, ?, 0, ?)',
      [nom, ref, prix, categorieId],
    );
    await conn.close();
  }

  Future<void> edit(int id, String nom, String ref, double prix, int? categorieId) async {
    final conn = await getConnection();
    await conn.query(
      'UPDATE piece SET nomPiece=?, reference=?, prix=?, idCat=? WHERE idPiece=?',
      [nom, ref, prix, categorieId, id],
    );
    await conn.close();
  }

  Future<void> delete(int id) async {
    final conn = await getConnection();
    await conn.query('DELETE FROM piece WHERE idPiece=?', [id]);
    await conn.close();
  }
}
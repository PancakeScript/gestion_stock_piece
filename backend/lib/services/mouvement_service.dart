import '../config/database.dart';

class MouvementService {
  Future<void> entree(int pieceId, int quantite) async {
    final conn = await getConnection();

    await conn.query(
      "INSERT INTO mouvement (piece_id, type, quantite) VALUES (?, 'entree', ?)",
      [pieceId, quantite],
    );

    await conn.query(
      "UPDATE piece SET quantite_stock = quantite_stock + ? WHERE idPiece = ?",
      [quantite, pieceId],
    );

    await conn.close();
  }

  Future<void> sortie(int pieceId, int quantite) async {
    final conn = await getConnection();

    await conn.query(
      "INSERT INTO mouvement (piece_id, type, quantite) VALUES (?, 'sortie', ?)",
      [pieceId, quantite],
    );

    await conn.query(
      "UPDATE piece SET quantite_stock = quantite_stock - ? WHERE idPiece = ?",
      [quantite, pieceId],
    );

    await conn.close();
  }

  Future<List<Map>> getAll() async {
    final conn = await getConnection();
    var results = await conn.query('SELECT * FROM mouvement ORDER BY id DESC');
    List<Map> data = [];
    for (var row in results) {
      Map<String, dynamic> map = {};
      row.fields.forEach((key, value) {
        if (value is DateTime) {
          map[key] = value.toIso8601String();
        } else {
          map[key] = value;
        }
      });
      data.add(map);
    }
    await conn.close();
    return data;
  }
}
import '../config/database.dart';

class CategoryService {
  Future<List<Map>> getAll() async {
    final conn = await getConnection();
    var results = await conn.query('SELECT * FROM categorie');
    List<Map> data = [];
    for (var row in results) {
      data.add(row.fields);
    }
    await conn.close();
    return data;
  }

  Future<void> add(String nom) async {
    final conn = await getConnection();
    await conn.query('INSERT INTO categorie (nom) VALUES (?)', [nom]);
    await conn.close();
  }

  Future<void> edit(int id, String nom) async {
    final conn = await getConnection();
    await conn.query('UPDATE categorie SET nom=? WHERE idCat=?', [nom, id]);
    await conn.close();
  }

  Future<void> delete(int id) async {
    final conn = await getConnection();
    await conn.query('DELETE FROM categorie WHERE idCat=?', [id]);
    await conn.close();
  }
}
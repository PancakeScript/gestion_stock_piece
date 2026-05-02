import '../config/database.dart';

class CategoryService {
  Future<List<Map>> getAll() async {
    final conn = await getConnection();
    try {
      var results = await conn.query('SELECT * FROM categories');
      List<Map> data = [];
      for (var row in results) {
        data.add(row.fields);
      }
      return data;
    } catch (e) {
      // Si la table n'existe pas encore, on retourne des données par défaut pour éviter de bloquer l'app
      return [
        {'id': 1, 'nom': 'Moteur', 'description': 'Pièces du bloc moteur'},
        {'id': 2, 'nom': 'Freinage', 'description': 'Disques, plaquettes, etc.'},
        {'id': 3, 'nom': 'Suspension', 'description': 'Amortisseurs et bras'},
      ];
    } finally {
      await conn.close();
    }
  }
}

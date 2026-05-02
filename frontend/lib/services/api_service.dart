import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080';

  // AUTH
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> register(Map data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }

  // PIECES
  static Future<List> getPieces() async {
    final res = await http.get(Uri.parse('$baseUrl/pieces'));
    return jsonDecode(res.body);
  }

  static Future<void> addPiece(Map data) async {
    await http.post(
      Uri.parse('$baseUrl/pieces'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // CATEGORIES
  static Future<List> getCategories() async {
    // Note: Assuming there's a /categories endpoint in the backend
    final res = await http.get(Uri.parse('$baseUrl/categories'));
    return jsonDecode(res.body);
  }

  // FOURNISSEURS
  static Future<List> getFournisseurs() async {
    final res = await http.get(Uri.parse('$baseUrl/fournisseurs'));
    return jsonDecode(res.body);
  }

  static Future<void> addFournisseur(Map data) async {
    await http.post(
      Uri.parse('$baseUrl/fournisseurs'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // STOCK
  static Future<void> entree(Map data) async {
    await http.post(
      Uri.parse('$baseUrl/stock/entree'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Future<void> sortie(Map data) async {
    await http.post(
      Uri.parse('$baseUrl/stock/sortie'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
  }

  static Future<List> getMouvements() async {
    final res = await http.get(Uri.parse('$baseUrl/mouvements'));
    return jsonDecode(res.body);
  }
}

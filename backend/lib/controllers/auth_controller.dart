import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/auth_service.dart';
import '../utils/response.dart';

final authService = AuthService();

Future<Response> login(Request req) async {
  try {
    final payload = await req.readAsString();
    final body = jsonDecode(payload);
    
    final user = await authService.login(body['email'], body['password']);

    if (user != null) {
      return jsonResponse(user);
    } else {
      return Response(401,
        body: jsonEncode({'error': 'Email ou mot de passe incorrect'}),
        headers: {'Content-Type': 'application/json'}
      );
    }
  } catch (e) {
    print('Erreur Login: $e');
    return Response.internalServerError(
      body: jsonEncode({'error': 'Erreur de connexion à la base de données'}),
      headers: {'Content-Type': 'application/json'}
    );
  }
}

Future<Response> register(Request req) async {
  try {
    final payload = await req.readAsString();
    final body = jsonDecode(payload);
    
    await authService.register(body['nom'], body['email'], body['password']);
    
    return Response.ok(
      jsonEncode({'message': 'Utilisateur créé avec succès'}),
      headers: {'Content-Type': 'application/json'}
    );
  } catch (e) {
    print('Erreur Register: $e');
    return Response.internalServerError(
      body: jsonEncode({'error': 'Impossible d\'enregistrer l\'utilisateur. Vérifiez la base de données.'}),
      headers: {'Content-Type': 'application/json'}
    );
  }
}

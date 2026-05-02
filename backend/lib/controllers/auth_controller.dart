import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/auth_service.dart';
import '../utils/response.dart';

final authService = AuthService();

Future<Response> login(Request req) async {
  try {
    final body = jsonDecode(await req.readAsString());
    final user = await authService.login(body['email'], body['password']);

    if (user != null) {
      return jsonResponse(user);
    } else {
      return Response(401,
        body: jsonEncode({'error': 'Identifiants incorrects'}),
        headers: {'Content-Type': 'application/json'}
      );
    }
  } catch (e) {
    print('Erreur Login: $e');
    return Response.internalServerError(
      body: jsonEncode({'error': e.toString()}),
      headers: {'Content-Type': 'application/json'}
    );
  }
}

Future<Response> register(Request req) async {
  try {
    final body = jsonDecode(await req.readAsString());
    await authService.register(body['nom'], body['email'], body['password']);
    return jsonResponse({'message': 'Utilisateur créé avec succès'});
  } catch (e) {
    print('Erreur Register: $e');
    return Response.internalServerError(
      body: jsonEncode({'error': 'Erreur serveur: $e'}),
      headers: {'Content-Type': 'application/json'}
    );
  }
}

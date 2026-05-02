import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/fournisseur_service.dart';
import '../utils/response.dart';

final service = FournisseurService();

Future<Response> getFournisseurs(Request req) async {
  return jsonResponse(await service.getAll());
}

Future<Response> addFournisseur(Request req) async {
  final body = jsonDecode(await req.readAsString());

  await service.add(body['nom'], body['telephone']);

  return jsonResponse({'message': 'ok'});
}
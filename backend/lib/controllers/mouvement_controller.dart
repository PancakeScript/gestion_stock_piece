import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/mouvement_service.dart';
import '../utils/response.dart';

final service = MouvementService();

Future<Response> entree(Request req) async {
  final body = jsonDecode(await req.readAsString());

  await service.entree(body['piece_id'], body['quantite']);

  return jsonResponse({'message': 'entrée ok'});
}

Future<Response> sortie(Request req) async {
  final body = jsonDecode(await req.readAsString());

  await service.sortie(body['piece_id'], body['quantite']);

  return jsonResponse({'message': 'sortie ok'});
}

Future<Response> getMouvements(Request req) async {
  return jsonResponse(await service.getAll());
}
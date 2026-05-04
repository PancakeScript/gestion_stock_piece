import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/piece_service.dart';
import '../utils/response.dart';

final service = PieceService();

Future<Response> getPieces(Request req) async {
  return jsonResponse(await service.getAll());
}

Future<Response> addPiece(Request req) async {
  final body = jsonDecode(await req.readAsString());
  await service.add(
    body['nom'],
    body['reference'],
    (body['prix'] as num).toDouble(),
    body['idCat'],
  );
  return jsonResponse({'message': 'ok'});
}

Future<Response> editPiece(Request req, String id) async {
  final body = jsonDecode(await req.readAsString());
  await service.edit(
    int.parse(id),
    body['nom'],
    body['reference'],
    (body['prix'] as num).toDouble(),
    body['idCat'],
  );
  return jsonResponse({'message': 'ok'});
}

Future<Response> deletePiece(Request req, String id) async {
  await service.delete(int.parse(id));
  return jsonResponse({'message': 'ok'});
}
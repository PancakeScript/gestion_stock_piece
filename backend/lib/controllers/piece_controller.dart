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
    body['prix'],
  );

  return jsonResponse({'message': 'ok'});
}
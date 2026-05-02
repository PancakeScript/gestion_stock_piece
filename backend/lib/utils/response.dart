import 'dart:convert';
import 'package:shelf/shelf.dart';

Response jsonResponse(dynamic data) {
  return Response.ok(
    jsonEncode(data),
    headers: {'Content-Type': 'application/json'},
  );
}
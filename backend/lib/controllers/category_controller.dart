import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../services/category_service.dart';
import '../utils/response.dart';

final categoryService = CategoryService();

Future<Response> getCategories(Request req) async {
  return jsonResponse(await categoryService.getAll());
}

Future<Response> addCategory(Request req) async {
  final body = jsonDecode(await req.readAsString());
  await categoryService.add(body['nom']);
  return jsonResponse({'message': 'ok'});
}

Future<Response> editCategory(Request req, String id) async {
  final body = jsonDecode(await req.readAsString());
  await categoryService.edit(int.parse(id), body['nom']);
  return jsonResponse({'message': 'ok'});
}

Future<Response> deleteCategory(Request req, String id) async {
  await categoryService.delete(int.parse(id));
  return jsonResponse({'message': 'ok'});
}
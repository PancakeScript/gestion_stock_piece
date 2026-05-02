import 'package:shelf/shelf.dart';
import '../services/category_service.dart';
import '../utils/response.dart';

final categoryService = CategoryService();

Future<Response> getCategories(Request req) async {
  final categories = await categoryService.getAll();
  return jsonResponse(categories);
}

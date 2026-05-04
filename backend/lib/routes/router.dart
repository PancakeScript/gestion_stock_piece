import 'package:shelf_router/shelf_router.dart';

import '../controllers/piece_controller.dart';
import '../controllers/fournisseur_controller.dart';
import '../controllers/mouvement_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/category_controller.dart';

Router get router {
  final r = Router();

  // Auth
  r.post('/login', login);
  r.post('/register', register);

  // Categories
  r.get('/categories', getCategories);
  r.post('/categories', addCategory);
  r.put('/categories/<id>', editCategory);
  r.delete('/categories/<id>', deleteCategory);

  // Pieces
  r.get('/piece', getPieces);
  r.post('/piece', addPiece);
  r.put('/piece/<id>', editPiece);
  r.delete('/piece/<id>', deletePiece);


  // Fournisseurs
  r.get('/fournisseurs', getFournisseurs);
  r.post('/fournisseurs', addFournisseur);

  // Stock
  r.post('/stock/entree', entree);
  r.post('/stock/sortie', sortie);
  r.get('/mouvements', getMouvements);

  return r;
}

import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class EditPieceScreen extends StatefulWidget {
  final Map piece;
  const EditPieceScreen({required this.piece});

  @override
  State<EditPieceScreen> createState() => _EditPieceScreenState();
}

class _EditPieceScreenState extends State<EditPieceScreen> {
  late TextEditingController nomCtrl;
  late TextEditingController refCtrl;
  late TextEditingController prixCtrl;
  List categories = [];
  int? selectedCatId = -1;
  bool loadingCats = true;

  @override
  void initState() {
    super.initState();
    nomCtrl = TextEditingController(text: widget.piece['nomPiece']);
    refCtrl = TextEditingController(text: widget.piece['reference']);
    prixCtrl = TextEditingController(text: widget.piece['prix'].toString());
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final data = await ApiService.getCategories();
    if (!mounted) return;
    setState(() {
      categories = data;
      final catId = widget.piece['idCat'];
      final exists = data.any((c) => c['idCat'] == catId);
      selectedCatId = exists ? int.parse(catId.toString()) : -1;
      loadingCats = false;
    });
  }

  @override
  void dispose() {
    nomCtrl.dispose();
    refCtrl.dispose();
    prixCtrl.dispose();
    super.dispose();
  }

  InputDecoration _input(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: Colors.cyan[700]),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.cyan[700]!, width: 2),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Modifier la pièce"),
        backgroundColor: Colors.cyan[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 10),
            TextField(controller: nomCtrl, decoration: _input('Nom', Icons.label)),
            SizedBox(height: 16),
            TextField(controller: refCtrl, decoration: _input('Référence', Icons.tag)),
            SizedBox(height: 16),
            TextField(
              controller: prixCtrl,
              keyboardType: TextInputType.number,
              decoration: _input('Prix', Icons.monetization_on),
            ),
            SizedBox(height: 16),
            loadingCats
                ? CircularProgressIndicator()
                : DropdownButtonFormField<int?>(
              value: selectedCatId,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.category, color: Colors.cyan[700]),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              items: [
                DropdownMenuItem<int?>(
                    value: -1, child: Text("-- Choisir une catégorie --")),
                ...categories.map<DropdownMenuItem<int?>>((c) {
                  return DropdownMenuItem<int?>(
                    value: int.parse(c['idCat'].toString()),
                    child: Text(c['nom'].toString()),
                  );
                }).toList(),
              ],
              onChanged: (val) => setState(() => selectedCatId = val),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan[700],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: Icon(Icons.save),
                label: Text("Mettre à jour", style: TextStyle(fontSize: 16)),
                onPressed: () async {
                  await ApiService.editPiece(widget.piece['idPiece'], {
                    "nom": nomCtrl.text,
                    "reference": refCtrl.text,
                    "prix": double.parse(prixCtrl.text),
                    "idCat": selectedCatId == -1 ? null : selectedCatId,
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
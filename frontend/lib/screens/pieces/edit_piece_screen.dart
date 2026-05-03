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

  @override
  void initState() {
    super.initState();
    nomCtrl = TextEditingController(text: widget.piece['nomPiece']);
    refCtrl = TextEditingController(text: widget.piece['reference']);
    prixCtrl = TextEditingController(text: widget.piece['prix'].toString());
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
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 10),
            TextField(controller: nomCtrl, decoration: _input('Nom', Icons.label)),
            SizedBox(height: 16),
            TextField(controller: refCtrl, decoration: _input('Référence', Icons.tag)),
            SizedBox(height: 16),
            TextField(controller: prixCtrl, keyboardType: TextInputType.number, decoration: _input('Prix', Icons.monetization_on)),
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
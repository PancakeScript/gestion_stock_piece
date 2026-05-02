import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class AddPieceScreen extends StatelessWidget {
  final nomCtrl = TextEditingController();
  final refCtrl = TextEditingController();
  final prixCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter pièce")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nomCtrl, decoration: InputDecoration(labelText: 'Nom')),
            TextField(controller: refCtrl, decoration: InputDecoration(labelText: 'Référence')),
            TextField(controller: prixCtrl, decoration: InputDecoration(labelText: 'Prix')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await ApiService.addPiece({
                  "nom": nomCtrl.text,
                  "reference": refCtrl.text,
                  "prix": double.parse(prixCtrl.text)
                });
                Navigator.pop(context);
              },
              child: Text("Ajouter"),
            )
          ],
        ),
      ),
    );
  }
}
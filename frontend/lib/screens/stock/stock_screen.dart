import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class StockScreen extends StatelessWidget {
  final pieceIdCtrl = TextEditingController();
  final quantiteCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stock")),
      body: Column(
        children: [
          TextField(controller: pieceIdCtrl, decoration: InputDecoration(labelText: 'Piece ID')),
          TextField(controller: quantiteCtrl, decoration: InputDecoration(labelText: 'Quantité')),

          ElevatedButton(
            onPressed: () {
              ApiService.entree({
                "piece_id": int.parse(pieceIdCtrl.text),
                "quantite": int.parse(quantiteCtrl.text)
              });
            },
            child: Text("Entrée"),
          ),

          ElevatedButton(
            onPressed: () {
              ApiService.sortie({
                "piece_id": int.parse(pieceIdCtrl.text),
                "quantite": int.parse(quantiteCtrl.text)
              });
            },
            child: Text("Sortie"),
          ),
        ],
      ),
    );
  }
}
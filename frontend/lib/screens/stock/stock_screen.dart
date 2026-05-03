import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class StockScreen extends StatefulWidget {
  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  List pieces = [];
  List mouvements = [];
  int? selectedPieceId;
  final quantiteCtrl = TextEditingController();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    setState(() => loading = true);
    pieces = await ApiService.getPieces();
    mouvements = await ApiService.getMouvements();
    setState(() => loading = false);
  }

  void handle(String type) async {
    if (selectedPieceId == null || quantiteCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sélectionne une pièce et entre une quantité")),
      );
      return;
    }
    final data = {"piece_id": selectedPieceId, "quantite": int.parse(quantiteCtrl.text)};
    if (type == 'entree') {
      await ApiService.entree(data);
    } else {
      await ApiService.sortie(data);
    }
    quantiteCtrl.clear();
    loadData();
  }

  String getNomPiece(dynamic pieceId) {
    final p = pieces.firstWhere((p) => p['idPiece'] == pieceId, orElse: () => null);
    return p != null ? p['nomPiece'] : 'ID: $pieceId';
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
        title: Text("Gestion Stock", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.cyan[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FORMULAIRE
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    DropdownButtonFormField<int>(
                      value: selectedPieceId,
                      hint: Text("Choisir une pièce"),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.settings, color: Colors.cyan[700]),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      items: pieces.map<DropdownMenuItem<int>>((p) {
                        return DropdownMenuItem(
                          value: p['idPiece'],
                          child: Text("${p['nomPiece']} — Stock: ${p['quantite_stock']}"),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => selectedPieceId = value),
                    ),
                    SizedBox(height: 14),
                    TextField(
                      controller: quantiteCtrl,
                      keyboardType: TextInputType.number,
                      decoration: _input('Quantité', Icons.numbers),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[600],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: Icon(Icons.arrow_downward),
                            label: Text("Entrée"),
                            onPressed: () => handle('entree'),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[600],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: Icon(Icons.arrow_upward),
                            label: Text("Sortie"),
                            onPressed: () => handle('sortie'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            Text("Historique des mouvements",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

            SizedBox(height: 8),

            // HISTORIQUE
            Expanded(
              child: mouvements.isEmpty
                  ? Center(child: Text("Aucun mouvement"))
                  : ListView.builder(
                itemCount: mouvements.length,
                itemBuilder: (_, i) {
                  final m = mouvements[i];
                  final isEntree = m['type'] == 'entree';
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isEntree ? Colors.green[100] : Colors.red[100],
                        child: Icon(
                          isEntree ? Icons.arrow_downward : Icons.arrow_upward,
                          color: isEntree ? Colors.green[700] : Colors.red[700],
                        ),
                      ),
                      title: Text(
                        getNomPiece(m['piece_id']),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(isEntree ? "Entrée" : "Sortie"),
                      trailing: Text(
                        "${isEntree ? '+' : '-'}${m['quantite']}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isEntree ? Colors.green[700] : Colors.red[700],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
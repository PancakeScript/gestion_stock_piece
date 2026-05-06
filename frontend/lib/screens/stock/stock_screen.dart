import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../profil/profil_screen.dart';


class StockScreen extends StatefulWidget {
  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  List pieces = [];
  List mouvements = [];
  List mouvementsFiltres = [];
  int? selectedPieceId;
  List filteredPieces = [];
  final pieceSearchCtrl = TextEditingController();
  final quantiteCtrl = TextEditingController();
  bool loading = true;
  DateTime? dateFiltre;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    setState(() => loading = true);
    try {
      pieces = await ApiService.getPieces();
      print('pieces OK: ${pieces.length}');
      filteredPieces = pieces;
      mouvements = await ApiService.getMouvements();
      print('mouvements OK: ${mouvements.length}');
      print('detail: $mouvements');
      mouvementsFiltres = mouvements;
    } catch (e, stack) {
      print('ERREUR: $e');
      print('STACK: $stack');
    }
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
    setState(() {
      selectedPieceId = null;
      pieceSearchCtrl.clear();
    });
    loadData();
  }

  void _filterPieces(String query) {
    setState(() {
      filteredPieces = pieces.where((p) =>
          p['nomPiece'].toString().toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void _filtrerParDate(DateTime date) {
    setState(() {
      dateFiltre = date;
      mouvementsFiltres = mouvements.where((m) {
        final d = DateTime.tryParse(m['date_mouvement'].toString());
        if (d == null) return false;
        return d.year == date.year && d.month == date.month && d.day == date.day;
      }).toList();
    });
  }

  void _resetFiltre() {
    setState(() {
      dateFiltre = null;
      mouvementsFiltres = mouvements;
    });
  }

  String getNomPiece(dynamic pieceId) {
    try {
      final p = pieces.firstWhere(
            (p) => p['idPiece'].toString() == pieceId.toString(),
      );
      return p['nomPiece'];
    } catch (_) {
      return 'Pièce $pieceId';
    }
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
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(
                    nom: "Utilisateur",
                    email: "utilisateur@gmail.com",
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FORMULAIRE
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: pieceSearchCtrl,
                      onChanged: _filterPieces,
                      decoration: InputDecoration(
                        hintText: "Rechercher une pièce...",
                        prefixIcon: Icon(Icons.search, color: Colors.cyan[700]),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                      ),
                    ),
                    if (pieceSearchCtrl.text.isNotEmpty)
                      Container(
                        constraints: BoxConstraints(maxHeight: 180),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          children: filteredPieces.map((p) {
                            final isSelected = selectedPieceId == p['idPiece'];
                            return ListTile(
                              tileColor: isSelected ? Colors.cyan[50] : null,
                              title: Text(p['nomPiece']),
                              subtitle: Text("Stock actuel : ${p['quantite_stock']}"),
                              trailing: isSelected
                                  ? Icon(Icons.check, color: Colors.cyan[700])
                                  : null,
                              onTap: () {
                                setState(() {
                                  selectedPieceId = p['idPiece'];
                                  pieceSearchCtrl.text = p['nomPiece'];
                                  filteredPieces = [];
                                });
                              },
                            );
                          }).toList(),
                        ),
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
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
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
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
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
          ),

          // HEADER HISTORIQUE + FILTRE DATE
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Historique",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Row(
                  children: [
                    if (dateFiltre != null)
                      TextButton.icon(
                        icon: Icon(Icons.clear, size: 16, color: Colors.red),
                        label: Text("Effacer", style: TextStyle(color: Colors.red)),
                        onPressed: _resetFiltre,
                      ),
                    TextButton.icon(
                      icon: Icon(Icons.calendar_today, size: 16, color: Colors.cyan[700]),
                      label: Text(
                        dateFiltre != null
                            ? "${dateFiltre!.day}/${dateFiltre!.month}/${dateFiltre!.year}"
                            : "Filtrer par date",
                        style: TextStyle(color: Colors.cyan[700]),
                      ),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) _filtrerParDate(picked);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // HISTORIQUE
          Expanded(
            child: mouvementsFiltres.isEmpty
                ? Center(child: Text("Aucun mouvement"))
                : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: mouvementsFiltres.length,
              itemBuilder: (_, i) {
                final m = mouvementsFiltres[i];
                final isEntree = m['type'] == 'entree';
                final date = DateTime.tryParse(m['date_mouvement'].toString());
                final dateStr = date != null
                    ? "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}"
                    : '';
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                      isEntree ? Colors.green[100] : Colors.red[100],
                      child: Icon(
                        isEntree ? Icons.arrow_downward : Icons.arrow_upward,
                        color: isEntree ? Colors.green[700] : Colors.red[700],
                      ),
                    ),
                    title: Text(getNomPiece(m['piece_id']),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(dateStr),
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
    );
  }
}
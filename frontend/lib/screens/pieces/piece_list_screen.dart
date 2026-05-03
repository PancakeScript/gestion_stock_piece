import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'add_piece_screen.dart';
import 'edit_piece_screen.dart';

class PieceListScreen extends StatefulWidget {
  @override
  State<PieceListScreen> createState() => _PieceListScreenState();
}

class _PieceListScreenState extends State<PieceListScreen> {
  List pieces = [];
  bool loading = true;

  void load() async {
    setState(() => loading = true);
    pieces = await ApiService.getPieces();
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  void confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Supprimer"),
        content: Text("Confirmer la suppression de cette pièce ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Annuler")),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ApiService.deletePiece(id);
              load();
            },
            child: Text("Supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Pièces", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.cyan[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : pieces.isEmpty
          ? Center(child: Text("Aucune pièce trouvée"))
          : ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: pieces.length,
        itemBuilder: (_, i) {
          final p = pieces[i];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: Colors.cyan[100],
                child: Icon(Icons.settings, color: Colors.cyan[700]),
              ),
              title: Text(p['nomPiece'] ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("Réf: ${p['reference']}  |  Stock: ${p['quantite_stock']}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${p['prix']} Ar", style: TextStyle(color: Colors.cyan[700], fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.orange),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EditPieceScreen(piece: p)),
                      );
                      load();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => confirmDelete(p['idPiece']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.cyan[700],
        icon: Icon(Icons.add, color: Colors.white),
        label: Text("Ajouter", style: TextStyle(color: Colors.white)),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => AddPieceScreen()));
          load();
        },
      ),
    );
  }
}
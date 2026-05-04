import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'add_piece_screen.dart';
import 'edit_piece_screen.dart';

class PieceListScreen extends StatefulWidget {
  final int? scrollToPieceId;
  const PieceListScreen({Key? key, this.scrollToPieceId}) : super(key: key);
  @override
  State<PieceListScreen> createState() => _PieceListScreenState();
}

class _PieceListScreenState extends State<PieceListScreen> {
  List pieces = [];
  List filtered = [];
  bool loading = true;
  final searchCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollTopiece() {
    final index = pieces.indexWhere(
      (p) => p['idPiece'] == widget.scrollToPieceId,
    );
    if (index != -1) {
      _scrollController.animateTo(
        index * 90.0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void load() async {
    setState(() => loading = true);
    if (widget.scrollToPieceId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollTopiece());
    }

    pieces = await ApiService.getPieces();
    _filter('');
    setState(() => loading = false);
  }

  void _filter(String query) {
    filtered = pieces.where((p) {
      return p['nomPiece'].toString().toLowerCase().contains(
        query.toLowerCase(),
      );
    }).toList();
    setState(() {});
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler"),
          ),
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
    // Pièces avec stock <= 5
    final alertes = pieces
        .where((p) => (p['quantite_stock'] ?? 0) <= 5)
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Pièces", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.cyan[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (alertes.isNotEmpty)
            IconButton(
              icon: Badge(
                label: Text('${alertes.length}'),
                child: Icon(Icons.warning_amber_rounded, color: Colors.orange),
              ),
              onPressed: () => _showAlertes(alertes),
            ),
        ],
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: TextField(
                    controller: searchCtrl,
                    onChanged: _filter,
                    decoration: InputDecoration(
                      hintText: "Rechercher une pièce...",
                      prefixIcon: Icon(Icons.search, color: Colors.cyan[700]),
                      suffixIcon: searchCtrl.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                searchCtrl.clear();
                                _filter('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(child: Text("Aucune pièce trouvée"))
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          itemCount: filtered.length,
                          itemBuilder: (_, i) {
                            final p = filtered[i];
                            final stockFaible = (p['quantite_stock'] ?? 0) <= 5;
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: stockFaible
                                      ? Colors.orange[100]
                                      : Colors.cyan[100],
                                  child: Icon(
                                    stockFaible
                                        ? Icons.warning_amber_rounded
                                        : Icons.settings,
                                    color: stockFaible
                                        ? Colors.orange[700]
                                        : Colors.cyan[700],
                                  ),
                                ),
                                title: Text(
                                  p['nomPiece'] ?? '',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Réf: ${p['reference']}"),
                                    Row(
                                      children: [
                                        Text(
                                          "Stock: ${p['quantite_stock']}",
                                          style: TextStyle(
                                            color: stockFaible ? Colors.orange[700] : Colors.grey[700],
                                            fontWeight: stockFaible ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                        if (stockFaible) Text(" ⚠️", style: TextStyle(fontSize: 12)),
                                        Spacer(),
                                        Text("${p['prix']} Ar",
                                            style: TextStyle(color: Colors.cyan[700], fontWeight: FontWeight.bold, fontSize: 12)),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      icon: Icon(Icons.edit, color: Colors.orange, size: 20),
                                      onPressed: () async {
                                        await Navigator.push(context,
                                            MaterialPageRoute(builder: (_) => EditPieceScreen(piece: p)));
                                        load();
                                      },
                                    ),
                                    SizedBox(width: 4),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      icon: Icon(Icons.delete, color: Colors.red, size: 20),
                                      onPressed: () => confirmDelete(p['idPiece']),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.cyan[700],
        icon: Icon(Icons.add, color: Colors.white),
        label: Text("Ajouter", style: TextStyle(color: Colors.white)),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddPieceScreen()),
          );
          load();
        },
      ),
    );
  }

  void _showAlertes(List alertes) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "⚠️ Stock faible (≤ 5)",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 10),
            ...alertes.map(
              (p) => ListTile(
                leading: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                ),
                title: Text(p['nomPiece']),
                trailing: Text(
                  "Stock: ${p['quantite_stock']}",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../pieces/piece_list_screen.dart';

class CategoryListScreen extends StatefulWidget {
  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  List categories = [];
  List filtered = [];
  List allPieces = [];
  bool isLoading = true;
  final searchCtrl = TextEditingController();
  int? expandedIndex;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    setState(() => isLoading = true);
    final cats = await ApiService.getCategories();
    final pieces = await ApiService.getPieces();
    if (!mounted) return;
    setState(() {
      categories = cats;
      filtered = cats;
      allPieces = pieces;
      isLoading = false;
    });
  }

  void _filter(String query) {
    setState(() {
      filtered = categories
          .where((c) => c['nom'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  List getPiecesOfCategory(dynamic catId) {
    return allPieces.where((p) => p['idCat'] == catId).toList();
  }

  void _showForm({Map? cat}) {
    final ctrl = TextEditingController(text: cat?['nom'] ?? '');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(cat == null ? "Ajouter une catégorie" : "Modifier la catégorie",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 16),
            TextField(
              controller: ctrl,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(cat == null ? "Ajouter" : "Mettre à jour"),
                onPressed: () async {
                  Navigator.pop(context);
                  if (cat == null) {
                    await ApiService.addCategory({"nom": ctrl.text});
                  } else {
                    await ApiService.editCategory(cat['idCat'], {"nom": ctrl.text});
                  }
                  loadData();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Supprimer"),
        content: Text("Supprimer cette catégorie ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Annuler")),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ApiService.deleteCategory(id);
              loadData();
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
        title: Text("Catégories", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.cyan[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              controller: searchCtrl,
              onChanged: _filter,
              decoration: InputDecoration(
                hintText: "Rechercher une catégorie...",
                prefixIcon: Icon(Icons.search, color: Colors.cyan[700]),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final cat = filtered[index];
                final piecesOfCat = getPiecesOfCategory(cat['idCat']);
                final isExpanded = expandedIndex == index;

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.cyan[100],
                          child: Icon(Icons.category, color: Colors.cyan[700]),
                        ),
                        title: Text(cat['nom'] ?? '',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("${piecesOfCat.length} pièce(s)"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: Icon(Icons.edit, color: Colors.orange, size: 20),
                              onPressed: () => _showForm(cat: cat),
                            ),
                            SizedBox(width: 4),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: Icon(Icons.delete, color: Colors.red, size: 20),
                              onPressed: () => _confirmDelete(cat['idCat']),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              isExpanded ? Icons.expand_less : Icons.expand_more,
                              color: Colors.cyan[700],
                            ),
                          ],
                        ),
                        onTap: () => setState(
                                () => expandedIndex = isExpanded ? null : index),
                      ),
                      if (isExpanded)
                        piecesOfCat.isEmpty
                            ? Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text("Aucune pièce dans cette catégorie",
                              style: TextStyle(color: Colors.grey)),
                        )
                            : Column(
                          children: piecesOfCat.map((p) {
                            final stockFaible = (p['quantite_stock'] ?? 0) <= 5;
                            return ListTile(
                              contentPadding: EdgeInsets.only(left: 72, right: 16),
                              leading: Icon(
                                stockFaible ? Icons.warning_amber_rounded : Icons.settings,
                                color: stockFaible ? Colors.orange : Colors.cyan[700],
                                size: 20,
                              ),
                              title: Text(p['nomPiece'] ?? ''),
                              subtitle: Text("Stock: ${p['quantite_stock']}",
                                  style: TextStyle(
                                      color: stockFaible ? Colors.orange : Colors.grey)),
                              trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PieceListScreen(scrollToPieceId: p['idPiece']),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                    ],
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
        onPressed: () => _showForm(),
      ),
    );
  }
}
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

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
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
          .where(
            (c) => c['nom']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()),
      )
          .toList();

      expandedIndex = null;
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              cat == null ? "Ajouter une catégorie" : "Modifier la catégorie",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(cat == null ? "Ajouter" : "Mettre à jour"),
                onPressed: () async {
                  Navigator.pop(context);

                  if (cat == null) {
                    await ApiService.addCategory({"nom": ctrl.text});
                  } else {
                    await ApiService.editCategory(
                      cat['idCat'],
                      {"nom": ctrl.text},
                    );
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
        title: const Text("Supprimer"),
        content: const Text("Supprimer cette catégorie ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ApiService.deleteCategory(id);
              loadData();
            },
            child: const Text(
              "Supprimer",
              style: TextStyle(color: Colors.red),
            ),
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
        title: const Text(
          "Catégories",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.cyan[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchCtrl,
              onChanged: _filter,
              decoration: InputDecoration(
                hintText: "Rechercher une catégorie...",
                prefixIcon: Icon(Icons.search, color: Colors.cyan[700]),
                suffixIcon: searchCtrl.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
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
                ? const Center(child: Text("Aucune catégorie trouvée"))
                : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final cat = filtered[index];
                final piecesOfCat =
                getPiecesOfCategory(cat['idCat']);
                final isExpanded = expandedIndex == index;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.cyan[100],
                          child: Icon(
                            Icons.category,
                            color: Colors.cyan[700],
                          ),
                        ),
                        title: Text(
                          cat['nom'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle:
                        Text("${piecesOfCat.length} pièce(s)"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.orange,
                                size: 20,
                              ),
                              onPressed: () =>
                                  _showForm(cat: cat),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 20,
                              ),
                              onPressed: () =>
                                  _confirmDelete(cat['idCat']),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              isExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: Colors.cyan[700],
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            expandedIndex =
                            isExpanded ? null : index;
                          });
                        },
                      ),
                      if (isExpanded)
                        piecesOfCat.isEmpty
                            ? const Padding(
                          padding:
                          EdgeInsets.only(bottom: 12),
                          child: Text(
                            "Aucune pièce dans cette catégorie",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        )
                            : Column(
                          children: piecesOfCat.map((p) {
                            final stockFaible =
                                (p['quantite_stock'] ?? 0) <=
                                    5;

                            return ListTile(
                              contentPadding:
                              const EdgeInsets.only(
                                left: 72,
                                right: 16,
                              ),
                              leading: Icon(
                                stockFaible
                                    ? Icons
                                    .warning_amber_rounded
                                    : Icons.settings,
                                color: stockFaible
                                    ? Colors.orange
                                    : Colors.cyan[700],
                                size: 20,
                              ),
                              title: Text(
                                p['nomPiece'] ?? '',
                              ),
                              subtitle: Text(
                                "Stock: ${p['quantite_stock']}",
                                style: TextStyle(
                                  color: stockFaible
                                      ? Colors.orange
                                      : Colors.grey,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: Colors.grey,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        PieceListScreen(
                                          scrollToPieceId:
                                          p['idPiece'],
                                        ),
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
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Ajouter", style: TextStyle(color: Colors.white)),
        onPressed: () => _showForm(),
      ),
    );
  }
}
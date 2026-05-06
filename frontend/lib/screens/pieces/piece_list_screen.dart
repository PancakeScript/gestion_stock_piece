import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'add_piece_screen.dart';
import 'edit_piece_screen.dart';
import '../profil/profil_screen.dart';

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

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTopiece() {
    final index = filtered.indexWhere(
          (p) => p['idPiece'] == widget.scrollToPieceId,
    );

    if (index != -1 && _scrollController.hasClients) {
      _scrollController.animateTo(
        index * 95.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void load() async {
    setState(() => loading = true);

    pieces = await ApiService.getPieces();
    _filter('');

    if (!mounted) return;

    setState(() => loading = false);

    if (widget.scrollToPieceId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollTopiece());
    }
  }

  void _filter(String query) {
    filtered = pieces.where((p) {
      return p['nomPiece']
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase());
    }).toList();

    if (mounted) {
      setState(() {});
    }
  }

  void confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Supprimer"),
        content: const Text("Confirmer la suppression de cette pièce ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ApiService.deletePiece(id);
              load();
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
    final alertes = pieces
        .where((p) => (p['quantite_stock'] ?? 0) <= 5)
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Pièces",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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

          if (alertes.isNotEmpty)
            IconButton(
              icon: Badge(
                label: Text('${alertes.length}'),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                ),
              ),
              onPressed: () => _showAlertes(alertes),
            ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchCtrl,
              onChanged: _filter,
              decoration: InputDecoration(
                hintText: "Rechercher une pièce...",
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
                ? const Center(child: Text("Aucune pièce trouvée"))
                : ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              itemCount: filtered.length,
              itemBuilder: (_, i) {
                final p = filtered[i];
                final stockFaible =
                    (p['quantite_stock'] ?? 0) <= 5;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
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
                                color: stockFaible
                                    ? Colors.orange[700]
                                    : Colors.grey[700],
                                fontWeight: stockFaible
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            if (stockFaible)
                              const Text(
                                " ⚠️",
                                style: TextStyle(fontSize: 12),
                              ),
                            const Spacer(),
                            Text(
                              "${p['prix']} Ar",
                              style: TextStyle(
                                color: Colors.cyan[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    EditPieceScreen(piece: p),
                              ),
                            );
                            load();
                          },
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
                              confirmDelete(p['idPiece']),
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
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Ajouter", style: TextStyle(color: Colors.white)),
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
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        builder: (context, scrollController) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "⚠️ Stock faible (≤ 5)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: alertes.length,
                    itemBuilder: (_, index) {
                      final p = alertes[index];

                      return ListTile(
                        leading: const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange,
                        ),
                        title: Text(p['nomPiece']),
                        trailing: Text(
                          "Stock: ${p['quantite_stock']}",
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
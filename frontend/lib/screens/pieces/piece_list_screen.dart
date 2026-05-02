import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'add_piece_screen.dart';

class PieceListScreen extends StatefulWidget {
  @override
  State<PieceListScreen> createState() => _PieceListScreenState();
}

class _PieceListScreenState extends State<PieceListScreen> {
  List pieces = [];

  void load() async {
    pieces = await ApiService.getPieces();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pièces")),
      body: ListView.builder(
        itemCount: pieces.length,
        itemBuilder: (_, i) {
          return ListTile(
            title: Text(pieces[i]['nom']),
            subtitle: Text("Stock: ${pieces[i]['quantite_stock']}"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
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
}
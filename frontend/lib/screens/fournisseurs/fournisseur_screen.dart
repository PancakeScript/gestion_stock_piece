import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class FournisseurScreen extends StatefulWidget {
  @override
  State<FournisseurScreen> createState() => _FournisseurScreenState();
}

class _FournisseurScreenState extends State<FournisseurScreen> {
  List fournisseurs = [];

  void load() async {
    fournisseurs = await ApiService.getFournisseurs();
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
      appBar: AppBar(title: Text("Fournisseurs")),
      body: ListView.builder(
        itemCount: fournisseurs.length,
        itemBuilder: (_, i) {
          return ListTile(
            title: Text(fournisseurs[i]['nom']),
            subtitle: Text(fournisseurs[i]['telephone'] ?? ''),
          );
        },
      ),
    );
  }
}
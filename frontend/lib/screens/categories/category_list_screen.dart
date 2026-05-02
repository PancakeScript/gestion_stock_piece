import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class CategoryListScreen extends StatefulWidget {
  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  List categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  void loadCategories() async {
    try {
      final data = await ApiService.getCategories();
      setState(() {
        categories = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      // Fallback for demo if API doesn't exist yet
      setState(() {
        categories = [
          {'nom': 'Moteur', 'description': 'Pièces moteur'},
          {'nom': 'Freinage', 'description': 'Systèmes de freinage'},
          {'nom': 'Suspension', 'description': 'Amortisseurs et ressorts'},
          {'nom': 'Électricité', 'description': 'Batteries et câblage'},
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Catégories")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Icon(Icons.category, color: Colors.blue),
                    title: Text(categories[index]['nom']),
                    subtitle: Text(categories[index]['description'] ?? ''),
                    onTap: () {
                      // Navigate to filtered pieces if needed
                    },
                  ),
                );
              },
            ),
    );
  }
}

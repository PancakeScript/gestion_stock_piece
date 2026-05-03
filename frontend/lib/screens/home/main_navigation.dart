import 'package:flutter/material.dart';
import '../categories/category_list_screen.dart';
import '../pieces/piece_list_screen.dart';
//import '../fournisseurs/fournisseur_screen.dart';
import '../stock/stock_screen.dart';

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    CategoryListScreen(),
    PieceListScreen(),
    //FournisseurScreen(),
    StockScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Catégories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_suggest),
            label: 'Pièces',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.business),
          //   label: 'Fournisseurs',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Stock',
          ),

        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

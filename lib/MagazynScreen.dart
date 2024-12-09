import 'package:flutter/material.dart';

import 'AddProductScreen.dart';

class MagazynScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Magazyn - Zarządzanie'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Przejście do okna dodawania produktu
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddProductScreen()),
            );
          },
          child: Text('Dodaj Produkt'),
        ),
      ),
    );
  }
}

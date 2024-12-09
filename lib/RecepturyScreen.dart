import 'package:flutter/material.dart';

import 'AddRecepturaScreen.dart';

class RecepturyScreen extends StatelessWidget {
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
              MaterialPageRoute(builder: (context) => AddRecepturaScreen()),
            );
          },
          child: Text('Dodaj Produkt'),
        ),
      ),
    );
  }
}

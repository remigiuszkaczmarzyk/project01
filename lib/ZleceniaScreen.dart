import 'package:flutter/material.dart';

import 'AddZleceniaScreen.dart';

class ZleceniaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zlecenia - Zarządzanie'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Przejście do okna dodawania produktu
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddZleceniaScreen()),
            );
          },
          child: Text('Dodaj Zlecenie'),
        ),
      ),
    );
  }
}

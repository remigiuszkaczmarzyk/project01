import 'package:flutter/material.dart';

import 'AddDostawa.dart';

class DostawyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Potrzeby - Zarządzanie'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Przejście do okna dodawania produktu
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddDostawa()),
            );
          },
          child: Text('Sprawdz Potrzeby'),
        ),
      ),
    );
  }
}

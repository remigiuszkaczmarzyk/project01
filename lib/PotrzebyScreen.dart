import 'package:flutter/material.dart';

import 'ListPotrzeby2.dart';

class PotrzebyScreen extends StatelessWidget {
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
              MaterialPageRoute(builder: (context) => ListPotrzeby2()),
            );
          },
          child: Text('Sprawdz Potrzeby'),
        ),
      ),
    );
  }
}

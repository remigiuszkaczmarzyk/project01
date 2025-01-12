import 'package:flutter/material.dart';

import 'AddProductScreen.dart';
import 'WarehouseItemsScreen.dart';

class MagazynScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Magazyn - Zarządzanie'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Przejście do okna dodawania produktu
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductScreen()),
                );
              },
              child: Text('Dodaj Produkt'),
            ),
            SizedBox(height: 20), // Odstęp między przyciskami
            ElevatedButton(
              onPressed: () {
                // Przejście do widoku elementów magazynu
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WarehouseItemsScreen()),
                );
              },
              child: Text('Zobacz Elementy Magazynu'),
            ),
          ],
        ),
      ),
    );
  }
}

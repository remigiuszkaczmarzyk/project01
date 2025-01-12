import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WarehouseItemsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Elementy Magazynu'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Magazyn').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Brak danych w magazynie.'));
          }

          // Lista dokumentów z kolekcji
          final documents = snapshot.data!.docs;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Nazwa')),
                DataColumn(label: Text('Ilość dostępna')),
                DataColumn(label: Text('Zamówienia')),
                DataColumn(label: Text('Bilans produkcji')),
                DataColumn(label: Text('Rezerwacja')),
              ],
              rows: documents.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return DataRow(cells: [
                  DataCell(Text(data['Nazwa'] ?? '')),
                  DataCell(Text(data['Ilosc dostepna']?.toString() ?? '0')),
                  DataCell(Text(data['Zamowienia']?.toString() ?? '0')),
                  DataCell(Text(data['Bilans produkcji']?.toString() ?? '0')),
                  DataCell(Text(data['Rezerwacja']?.toString() ?? '0')),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class OrderListBuilder {
  static List<DataRow> buildOrderList(
      List<Map<String, dynamic>> ordersData,
      Map<String, TextEditingController> textControllers,
      Function(String, int) onOrderPressed) {
    return ordersData.map((order) {
      int ilosc = order['Ilosc'];
      int iloscDostepna = order['IloscDostepna'];
      int bilansZamowien = order['BilansZamowien'];
      Color bilansColor =
          ilosc > (iloscDostepna + bilansZamowien) ? Colors.red : Colors.yellow;

      return DataRow(cells: [
        DataCell(Text(order['docNames'])),
        DataCell(Text(order['kod'])),
        DataCell(Text(ilosc.toString())),
        DataCell(Text(iloscDostepna.toString())),
        DataCell(Text(bilansZamowien.toString())),
        // Kolumna 6 - tylko tło z odpowiednim kolorem
        DataCell(Container(
          color: bilansColor,
          height: 40, // Wysokość kontenera, aby pole było widoczne
          width: 100, // Szerokość kontenera, aby pole miało stałą szerokość
        )),
        DataCell(TextFormField(
          controller: textControllers[order['kod']],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Wpisz ilość',
            border: OutlineInputBorder(),
          ),
        )),
        DataCell(TextButton(
          onPressed: () {
            String kod = order['kod'];
            String? textValue = textControllers[kod]?.text;
            if (textValue != null && textValue.isNotEmpty) {
              int iloscZamowienia = int.tryParse(textValue) ?? 0;
              if (iloscZamowienia > 0) {
                onOrderPressed(kod, iloscZamowienia);
              }
            }
          },
          child: Text('Zamawiam'),
        )),
      ]);
    }).toList();
  }
}

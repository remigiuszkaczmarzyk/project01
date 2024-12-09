import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddDostawa extends StatefulWidget {
  @override
  _AddDostawaState createState() => _AddDostawaState();
}

class _AddDostawaState extends State<AddDostawa> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> filteredOrders = [];
  Map<String, TextEditingController> textControllers = {};

  @override
  void initState() {
    super.initState();
    fetchOrdersData();
  }

  // Fetch data from Firestore and filter based on Bilans Zamówień
  Future<void> fetchOrdersData() async {
    QuerySnapshot snapshot = await _firestore.collection('Magazyn').get();
    List<Map<String, dynamic>> ordersList = [];
    for (var doc in snapshot.docs) {
      int bilansZamowien = doc['Bilans Zamowien'] ?? 0;
      if (bilansZamowien > 0) {
        ordersList.add({
          'kod': doc.id, // ID dokumentu jako Kod
          'nazwa': doc['Nazwa'], // Nazwa dokumentu
          'iloscZamowiona': bilansZamowien, // Bilans Zamówień
        });
        textControllers[doc.id] = TextEditingController();
      }
    }
    setState(() {
      filteredOrders = ordersList;
    });
  }

  // Update the Bilans Zamówien and Ilosc Dostepna fields
  Future<void> updateOrderData(String kod, int iloscDoZmiany) async {
    DocumentSnapshot docSnapshot =
        await _firestore.collection('Magazyn').doc(kod).get();
    int currentBilans = docSnapshot['Bilans Zamowien'] ?? 0;
    int currentIloscDostepna = docSnapshot['Ilosc dostepna'] ?? 0;

    if (iloscDoZmiany <= currentBilans) {
      // Update Bilans Zamówien (decrement) and Ilosc Dostepna (increment)
      await _firestore.collection('Magazyn').doc(kod).update({
        'Bilans Zamowien': currentBilans - iloscDoZmiany,
        'Ilosc dostepna': currentIloscDostepna + iloscDoZmiany,
      });

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Zaktualizowano dane dla dokumentu $kod'),
      ));
      fetchOrdersData(); // Refresh data
    } else {
      // Show error if the quantity is greater than Bilans Zamówien
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Nie możesz zmniejszyć Bilans Zamówien o więcej niż dostępna ilość'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dodaj Dostawę'),
      ),
      body: filteredOrders.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Kod')),
                  DataColumn(label: Text('Nazwa')),
                  DataColumn(label: Text('Ilość Zamówiona')),
                  DataColumn(label: Text('Ilość Dostarczona')),
                  DataColumn(label: Text('Akcje')),
                ],
                rows: filteredOrders.map((order) {
                  String kod = order['kod'];
                  String nazwa = order['nazwa'];
                  int iloscZamowiona = order['iloscZamowiona'];

                  return DataRow(cells: [
                    DataCell(Text(kod)),
                    DataCell(Text(nazwa)),
                    DataCell(Text(iloscZamowiona.toString())),
                    DataCell(TextFormField(
                      controller: textControllers[kod],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Wpisz ilość',
                        border: OutlineInputBorder(),
                      ),
                    )),
                    DataCell(TextButton(
                      onPressed: () {
                        String? textValue = textControllers[kod]?.text;
                        if (textValue != null && textValue.isNotEmpty) {
                          int iloscDoZmiany = int.tryParse(textValue) ?? 0;
                          if (iloscDoZmiany > 0) {
                            updateOrderData(kod, iloscDoZmiany);
                          }
                        }
                      },
                      child: Text('Zaktualizuj'),
                    )),
                  ]);
                }).toList(),
              ),
            ),
    );
  }
}

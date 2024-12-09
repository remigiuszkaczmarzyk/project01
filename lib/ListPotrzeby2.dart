import 'package:flutter/material.dart';

import 'FirestoreService.dart';
import 'OrderListBuilder.dart';

class ListPotrzeby2 extends StatefulWidget {
  @override
  _ListPotrzeby2State createState() => _ListPotrzeby2State();
}

class _ListPotrzeby2State extends State<ListPotrzeby2> {
  FirestoreService firestoreService = FirestoreService();
  List<Map<String, dynamic>> allOrdersData = [];
  bool isLoading = true;
  Map<String, TextEditingController> textControllers = {};

  @override
  void initState() {
    super.initState();
    fetchOrdersData();
  }

  Future<void> fetchOrdersData() async {
    setState(() => isLoading = true);
    allOrdersData = await firestoreService.fetchOrdersData();
    textControllers = {
      for (var order in allOrdersData) order['kod']: TextEditingController()
    };
    setState(() => isLoading = false);
  }

  Future<void> orderProduct(String kod, int iloscZamowienia) async {
    await firestoreService.updateOrderBalance(kod, iloscZamowienia);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Świetnie zamówiłeś produkt')),
    );
    fetchOrdersData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dokumenty i Składniki'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(label: Text('Nazwa Dokumentu')),
                  DataColumn(label: Text('Kod')),
                  DataColumn(label: Text('Ilosc')),
                  DataColumn(label: Text('Ilosc Dostępna')),
                  DataColumn(label: Text('Bilans Zamówień')),
                  DataColumn(label: Text('Stan')),
                  DataColumn(label: Text('Ilosc Zamowieniowa')),
                  DataColumn(label: Text('Akcje')),
                ],
                rows: OrderListBuilder.buildOrderList(
                    allOrdersData, textControllers, orderProduct),
              ),
            ),
    );
  }
}

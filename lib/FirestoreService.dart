import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchOrdersData() async {
    QuerySnapshot zleceniaSnapshot =
        await _firestore.collection('Zlecenia').get();

    Map<String, Map<String, dynamic>> kodToDataMap = {};

    for (var doc in zleceniaSnapshot.docs) {
      String docName = doc.id;
      List<dynamic> skladniki = doc['Skladniki'] ?? [];
      for (var skladnik in skladniki) {
        String kod = skladnik['Kod'] ?? '';
        int ilosc = skladnik['Ilosc'] ?? 0;

        if (kodToDataMap.containsKey(kod)) {
          kodToDataMap[kod]!['Ilosc'] += ilosc;
          kodToDataMap[kod]!['docNames'] += "\n$docName";
        } else {
          kodToDataMap[kod] = {
            'kod': kod,
            'Ilosc': ilosc,
            'docNames': docName,
          };
        }
      }
    }

    for (var kod in kodToDataMap.keys) {
      DocumentSnapshot magazynDoc =
          await _firestore.collection('Magazyn').doc(kod).get();
      if (magazynDoc.exists) {
        kodToDataMap[kod]!['IloscDostepna'] = magazynDoc['Ilosc dostepna'] ?? 0;
        kodToDataMap[kod]!['BilansZamowien'] =
            magazynDoc['Bilans Zamowien'] ?? 0;
      } else {
        kodToDataMap[kod]!['IloscDostepna'] = 0;
        kodToDataMap[kod]!['BilansZamowien'] = 0;
      }
    }

    List<Map<String, dynamic>> ordersList = kodToDataMap.values.toList();
    ordersList.removeWhere((order) => order['Ilosc'] < order['IloscDostepna']);

    return ordersList;
  }

  Future<void> updateOrderBalance(String kod, int iloscZamowienia) async {
    DocumentSnapshot magazynDoc =
        await _firestore.collection('Magazyn').doc(kod).get();
    if (magazynDoc.exists) {
      int bilansZamowien = magazynDoc['Bilans Zamowien'] ?? 0;
      await _firestore.collection('Magazyn').doc(kod).update({
        'Bilans Zamowien': bilansZamowien + iloscZamowienia,
      });
    }
  }
}

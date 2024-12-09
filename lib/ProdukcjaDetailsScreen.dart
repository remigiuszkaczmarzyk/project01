import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProdukcjaDetailsScreen extends StatelessWidget {
  final String zlecenieNazwa; // Przechowujemy nazwę zlecenia

  const ProdukcjaDetailsScreen({Key? key, required this.zlecenieNazwa})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Szczegóły Zlecenia'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Zlecenia')
            .doc(zlecenieNazwa)
            .get(), // Pobieramy dokument na podstawie przekazanej nazwy
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
                child: Text('Zlecenie nie zostało znalezione.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          // Sprawdzamy składniki
          final skladniki = data['Skladniki'] as List<dynamic>? ?? [];

          return Column(
            children: [
              // Nagłówki kolumn
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(
                        flex: 2,
                        child: Text('Kod',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 3,
                        child: Text('Nazwa',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 2,
                        child: Text('Ilość',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                        flex: 1,
                        child: Text('Stan',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              // Lista składników
              Expanded(
                child: ListView.builder(
                  itemCount: skladniki.length,
                  itemBuilder: (context, index) {
                    final skladnik = skladniki[index];
                    final kod = skladnik['Kod'];
                    final ilosc = skladnik['Ilosc'];
                    final stan = skladnik['Stan'];

                    // Kolor kółka zależny od stanu
                    Color circleColor = stan == 1 ? Colors.green : Colors.red;

                    // Pobieramy nazwę z kolekcji Magazyn na podstawie Kodu
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('Magazyn')
                          .doc(kod)
                          .get(),
                      builder: (context, magazynSnapshot) {
                        if (magazynSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (!magazynSnapshot.hasData ||
                            !magazynSnapshot.data!.exists) {
                          return Row(
                            children: [
                              Expanded(flex: 2, child: Text(kod)),
                              Expanded(
                                  flex: 3,
                                  child: const Text('Brak nazwy w magazynie')),
                              Expanded(flex: 2, child: Text('Ilość: $ilosc')),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: circleColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        final magazynData = magazynSnapshot.data!.data()
                            as Map<String, dynamic>;
                        final nazwa = magazynData['Nazwa'] ?? 'Brak nazwy';

                        return Row(
                          children: [
                            Expanded(
                                flex: 2, child: Text(kod)), // 1 kolumna: Kod
                            Expanded(
                                flex: 3,
                                child: Text(nazwa)), // 2 kolumna: Nazwa
                            Expanded(
                                flex: 2,
                                child:
                                    Text('Ilość: $ilosc')), // 3 kolumna: Ilość
                            Expanded(
                              flex: 1,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: circleColor, // 4 kolumna: Koło
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

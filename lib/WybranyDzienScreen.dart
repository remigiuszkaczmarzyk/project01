import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'ProdukcjaDetailsScreen.dart';
import 'SelectZlecenieScreen.dart'; // Importujemy nowy ekran

class WybranyDzienScreen extends StatelessWidget {
  final DateTime selectedDay; // Wybrany dzień przekazany z poprzedniego ekranu

  const WybranyDzienScreen({Key? key, required this.selectedDay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wybrany Dzień'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Zlecenia').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'Nie zaplanowano jeszcze produkcji na ten dzień.',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                final selectedDateStr = selectedDay
                    .toLocal()
                    .toString()
                    .split(' ')[0]; // Wybrany dzień jako string

                // Filtracja dokumentów
                final List<DocumentSnapshot> filteredDocs =
                    snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;

                  // Sprawdzenie, czy dokument zawiera wymagane pola
                  if (!data.containsKey('Aktywny') ||
                      !data.containsKey('DataProdukcji')) {
                    return false;
                  }

                  final aktywny = data['Aktywny'] as int;
                  final dataProdukcji = data['DataProdukcji'] as Timestamp;

                  // Filtrujemy tylko aktywne dokumenty z dopasowaną datą produkcji
                  return aktywny == 1 &&
                      dataProdukcji
                              .toDate()
                              .toLocal()
                              .toString()
                              .split(' ')[0] ==
                          selectedDateStr;
                }).toList();

                // Sytuacja, gdy po filtrowaniu lista jest pusta
                if (filteredDocs.isEmpty) {
                  return const Center(
                    child: Text(
                      'Nie zaplanowano jeszcze produkcji na ten dzień.',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];
                    final data = doc.data() as Map<String, dynamic>;

                    // Sprawdzamy listę Skladniki w dokumencie
                    final skladniki = data['Skladniki'] as List<dynamic>? ?? [];
                    bool allSkladnikiValid = true;

                    // Sprawdzamy, czy wszystkie składniki mają Stan = 1
                    for (var skladnik in skladniki) {
                      if (skladnik['Stan'] != 1) {
                        allSkladnikiValid = false;
                        break;
                      }
                    }

                    // Określamy kolor koła
                    Color circleColor =
                        allSkladnikiValid ? Colors.green : Colors.red;

                    final zlecenieNazwa =
                        doc.id; // Używamy id dokumentu jako nazwy zlecenia

                    return ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .start, // Elementy wyrównane do lewej
                        children: [
                          Text(zlecenieNazwa), // Wyświetlamy nazwę dokumentu
                          const SizedBox(
                              width: 8), // Odstęp między nazwą a kółkiem
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: circleColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        // Przekazujemy nazwę zlecenia do nowego ekranu
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProdukcjaDetailsScreen(
                              zlecenieNazwa: zlecenieNazwa,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Przekazujemy parametr selectedDay do SelectZlecenieScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectZlecenieScreen(
                      selectedDay: selectedDay, // Przekazanie parametru
                    ),
                  ),
                );
              },
              child: const Text('Wybierz Zlecenie'),
            ),
          ),
        ],
      ),
    );
  }
}

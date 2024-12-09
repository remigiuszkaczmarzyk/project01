import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SelectZlecenieScreen extends StatelessWidget {
  final DateTime selectedDay; // Dzień wybrany wcześniej

  const SelectZlecenieScreen({Key? key, required this.selectedDay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wybierz Zlecenie'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        // Filtrujemy zapytanie po stronie Firebase
        future: FirebaseFirestore.instance
            .collection('Zlecenia')
            .where('Aktywny',
                isEqualTo: 0) // Pobieramy tylko zlecenia, które nie są aktywne
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'Brak dostępnych zleceń.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final List<DocumentSnapshot> zlecenia = snapshot.data!.docs;

          return ListView.builder(
            itemCount: zlecenia.length,
            itemBuilder: (context, index) {
              final doc = zlecenia[index];
              final data = doc.data() as Map<String, dynamic>;
              final zlecenieNazwa = data['Zlecenie'] ?? 'Nieznane Zlecenie';

              return ListTile(
                title: Text(zlecenieNazwa),
                subtitle: Text('Dokument ID: ${doc.id}'),
                onTap: () {
                  // Po kliknięciu wyświetlamy dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Aktywacja zlecenia'),
                      content: Text(
                          'Czy chcesz aktywować zlecenie "$zlecenieNazwa"?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Zamykamy dialog
                          },
                          child: const Text('Nie'),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              // Formatowanie daty na Timestamp
                              Timestamp dateTimestamp =
                                  Timestamp.fromDate(selectedDay);

                              // Aktualizacja dokumentu: ustawienie Aktywny na 1 i dodanie DataProdukcji
                              await FirebaseFirestore.instance
                                  .collection('Zlecenia')
                                  .doc(doc.id)
                                  .update({
                                'Aktywny': 1,
                                'DataProdukcji':
                                    dateTimestamp, // Użycie Timestamp
                              });

                              // Zamykamy dialog
                              Navigator.of(context).pop();

                              // Wyświetlenie potwierdzenia
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Zlecenie "$zlecenieNazwa" zostało aktywowane.'),
                                ),
                              );
                            } catch (e) {
                              // Obsługa błędów
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Błąd: $e'),
                                ),
                              );
                            }
                          },
                          child: const Text('Tak'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

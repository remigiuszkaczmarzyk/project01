import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddZleceniaScreen extends StatefulWidget {
  const AddZleceniaScreen({Key? key}) : super(key: key);

  @override
  _AddZleceniaScreenState createState() => _AddZleceniaScreenState();
}

class _AddZleceniaScreenState extends State<AddZleceniaScreen> {
  final TextEditingController zlecenieController = TextEditingController();
  final TextEditingController indeksPaczkiController = TextEditingController();
  final TextEditingController iloscController = TextEditingController();

  @override
  void dispose() {
    zlecenieController.dispose();
    indeksPaczkiController.dispose();
    iloscController.dispose();
    super.dispose();
  }

  void saveZlecenie() async {
    final String zlecenie = zlecenieController.text.trim();
    final String indeksPaczki = indeksPaczkiController.text.trim();
    final String iloscText = iloscController.text.trim();

    if (zlecenie.isEmpty || indeksPaczki.isEmpty || iloscText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Proszę wypełnić wszystkie pola.')),
      );
      return;
    }

    final int? ilosc = int.tryParse(iloscText);
    if (ilosc == null || ilosc <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Proszę podać poprawną liczbę w polu Ilosc.')),
      );
      return;
    }

    // Zamiana '/' na '_' w indeksie paczki
    final String nowyIndeksPaczki = indeksPaczki.replaceAll('/', '_');

    try {
      // Pobieranie danych składników z kolekcji Receptury
      final DocumentSnapshot recepturaDoc = await FirebaseFirestore.instance
          .collection('Receptury')
          .doc(nowyIndeksPaczki)
          .get();

      if (!recepturaDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Nie znaleziono receptury dla indeksu: $nowyIndeksPaczki')),
        );
        return;
      }

      // Pobranie danych składników
      final Map<String, dynamic> recepturaData =
          recepturaDoc.data() as Map<String, dynamic>;
      final List<Map<String, dynamic>> skladniki = [];

      recepturaData.forEach((key, value) {
        if (value is Map<String, dynamic> && value.containsKey('ilosc')) {
          final int iloscSkladnika = (value['ilosc'] as int) * ilosc;
          skladniki.add({
            'Kod': value['Kod'],
            'Ilosc': iloscSkladnika,
            'Stan': 0, // Nowy parametr z domyślną wartością
          });
        }
      });

      // Tworzenie nowej kolekcji Zlecenia
      final String dokumentId = '$zlecenie.$nowyIndeksPaczki.$ilosc';
      await FirebaseFirestore.instance
          .collection('Zlecenia')
          .doc(dokumentId)
          .set({
        'Zlecenie': zlecenie,
        'Indeks Paczki': nowyIndeksPaczki,
        'Ilosc': ilosc,
        'Skladniki': skladniki,
        'Aktywny': 0, // Nowy parametr Aktywny
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Zlecenie zostało zapisane.')),
      );

      // Teraz aktualizujemy kolekcję Magazyn
      for (final skladnik in skladniki) {
        final String kodSkladnika = skladnik['Kod'];
        final int iloscSkladnika = skladnik['Ilosc'];

        // Wyszukiwanie dokumentu w kolekcji Magazyn na podstawie kodu składnika
        final DocumentSnapshot magazynDoc = await FirebaseFirestore.instance
            .collection('Magazyn')
            .doc(kodSkladnika)
            .get();

        if (magazynDoc.exists) {
          final Map<String, dynamic> magazynData =
              magazynDoc.data() as Map<String, dynamic>;

          final int aktualnaRezerwacja = magazynData['Rezerwacja'] ?? 0;
          final int aktualnaIloscDostepna = magazynData['Ilosc dostępna'] ?? 0;

          // Zwiększamy 'Rezerwacja' o ilosc składnika
          final int nowaRezerwacja = aktualnaRezerwacja + iloscSkladnika;

          // Zmniejszamy 'Ilosc dostępna' o ilosc składnika
          final int nowaIloscDostepna = aktualnaIloscDostepna - iloscSkladnika;

          // Zapisujemy zaktualizowane dane w kolekcji Magazyn
          await FirebaseFirestore.instance
              .collection('Magazyn')
              .doc(kodSkladnika)
              .update({
            'Rezerwacja': nowaRezerwacja,
            'Ilosc dostępna': nowaIloscDostepna,
          });

          // Wyświetlenie komunikatu o sukcesie
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Zaktualizowano magazyn dla składnika: $kodSkladnika')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Nie znaleziono składnika: $kodSkladnika w magazynie.')),
          );
        }
      }

      // Czyszczenie pól formularza
      zlecenieController.clear();
      indeksPaczkiController.clear();
      iloscController.clear();
    } catch (e) {
      // Obsługa błędów
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wystąpił błąd: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj Zlecenie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Zlecenie:', style: TextStyle(fontSize: 18)),
              TextField(
                controller: zlecenieController,
                decoration: const InputDecoration(
                  hintText: 'Podaj zlecenie',
                ),
              ),
              const SizedBox(height: 20),
              const Text('Indeks Paczki:', style: TextStyle(fontSize: 18)),
              TextField(
                controller: indeksPaczkiController,
                decoration: const InputDecoration(
                  hintText: 'Podaj indeks paczki',
                ),
              ),
              const SizedBox(height: 20),
              const Text('Ilosc:', style: TextStyle(fontSize: 18)),
              TextField(
                controller: iloscController,
                decoration: const InputDecoration(
                  hintText: 'Podaj ilosc',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: saveZlecenie,
                  child: const Text('Zapisz Zlecenie'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

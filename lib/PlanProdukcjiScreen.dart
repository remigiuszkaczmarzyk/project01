import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Importowanie pakietu http

import 'KalendarzScreen.dart';

class PlanProdukcjiScreen extends StatelessWidget {
  // Funkcja wywołująca zapytanie do URL
  Future<void> triggerCloudFunction() async {
    final url = Uri.parse('https://processorders-i4h2nidfda-uc.a.run.app/');

    try {
      // Wysyłamy zapytanie HTTP GET (możesz użyć POST, jeśli jest to wymagane przez serwer)
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print("Funkcja została wywołana pomyślnie!");
      } else {
        print("Błąd wywołania funkcji: ${response.statusCode}");
      }
    } catch (e) {
      print("Wystąpił błąd: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalendarz Produkcji'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Wywołaj funkcję Firebase
            await triggerCloudFunction();

            // Następnie przejdź do okna Kalendarza
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => KalendarzScreen()),
            );
          },
          child: Text('Sprawdz Kalendarz'),
        ),
      ),
    );
  }
}

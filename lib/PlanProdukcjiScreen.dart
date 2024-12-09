import 'package:flutter/material.dart';

import 'KalendarzScreen.dart';

class PlanProdukcjiScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalendarz Produkcji'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Przejście do okna dodawania produktu
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

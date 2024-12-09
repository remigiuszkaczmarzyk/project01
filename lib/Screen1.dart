import 'package:flutter/material.dart';

import 'DostawyScreen.dart';
import 'KontrahenciScreen.dart';
import 'MagazynScreen.dart';
import 'PlanProdukcjiScreen.dart';
import 'PotrzebyScreen.dart';
import 'RecepturyScreen.dart';
import 'ZleceniaScreen.dart';
import 'custom_button.dart'; // Importujemy nasz przycisk

class Screen1 extends StatefulWidget {
  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Panel',
          style: TextStyle(
            color: Colors.black, // Kolor tekstu nagłówka
            fontWeight: FontWeight.bold, // Pogrubienie tekstu
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800], // Tło AppBar
        elevation: 2, // Subtelny cień
        iconTheme: IconThemeData(color: Colors.grey[800]), // Ikony w AppBar
      ),
      body: Container(
        color: Colors.blue[50], // Czyste, minimalistyczne tło
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildButton(context, "Magazyn", MagazynScreen()),
                    SizedBox(width: 20),
                    buildButton(context, "Potrzeby", PotrzebyScreen()),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildButton(context, "Zlecenia", ZleceniaScreen()),
                    SizedBox(width: 20),
                    buildButton(context, "Receptury", RecepturyScreen()),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildButton(context, "Kontrahenci", KontrahenciScreen()),
                    const SizedBox(width: 20),
                    buildButton(context, "Dostawy", DostawyScreen()),
                  ],
                ),
                const SizedBox(height: 20),
                buildButton(context, "Plan produkcji", PlanProdukcjiScreen()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

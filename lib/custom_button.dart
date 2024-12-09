import 'package:flutter/material.dart';

Widget buildButton(BuildContext context, String label, Widget screen) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blueGrey[700], // Profesjonalny kolor tła
      foregroundColor: Colors.white, // Kolor tekstu
      side: BorderSide(color: Colors.blueGrey[900]!, width: 2), // Obramowanie
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Zaokrąglenia rogów
      ),
      padding: EdgeInsets.symmetric(
          horizontal: 24, vertical: 16), // Wewnętrzny odstęp
      shadowColor: Colors.blueGrey[300], // Subtelny cień
      elevation: 4, // Delikatne podniesienie
    ),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    },
    child: Text(
      label,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  );
}

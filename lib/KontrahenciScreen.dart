import 'package:flutter/material.dart';

class KontrahenciScreen extends StatefulWidget {
  @override
  State<KontrahenciScreen> createState() => _KontrahenciScreenState();
}

class _KontrahenciScreenState extends State<KontrahenciScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
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
      body: Column(
        children: <Widget>[
          buildSectionOne(),
        ],
      ),
    );
  }

  Widget buildSectionOne() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(),
      ],
    );
  }
}

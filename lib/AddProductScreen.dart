import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _reservationController = TextEditingController();
  final TextEditingController _availableController = TextEditingController();
  final TextEditingController _ordersController = TextEditingController();
  final TextEditingController _orderBalanceController = TextEditingController();
  final TextEditingController _additionalInfoController =
      TextEditingController();
  final TextEditingController _productionBalanceController =
      TextEditingController();
  final TextEditingController _contractorCodeController =
      TextEditingController();

  void pasteData(String clipboardData) {
    // Podział danych na linie (wiersze z Excela)
    final List<String> lines = clipboardData.split('\n');

    // Obsługujemy tylko pierwszy wiersz jako dane (zakładamy brak nagłówków)
    if (lines.isNotEmpty) {
      final List<String> columns = lines.first.split('\t');
      if (columns.isNotEmpty) _codeController.text = columns[0].trim();
      if (columns.length > 1) _nameController.text = columns[1].trim();
      if (columns.length > 2) _stockController.text = columns[2].trim();
      if (columns.length > 3) _reservationController.text = columns[3].trim();
      if (columns.length > 4) _availableController.text = columns[4].trim();
      if (columns.length > 5) _ordersController.text = columns[5].trim();
      if (columns.length > 6) _orderBalanceController.text = columns[6].trim();
      if (columns.length > 7)
        _additionalInfoController.text = columns[7].trim();
      if (columns.length > 8)
        _productionBalanceController.text = columns[8].trim();
      if (columns.length > 9)
        _contractorCodeController.text = columns[9].trim();
    }
  }

  Future<void> _addProduct() async {
    final String code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kod produktu jest wymagany!')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('Magazyn').doc(code).set({
        'Nazwa': _nameController.text.trim(),
        'Stan magazynowy': int.tryParse(_stockController.text.trim()) ?? 0,
        'Rezerwacja': int.tryParse(_reservationController.text.trim()) ?? 0,
        'Ilosc dostepna': int.tryParse(_availableController.text.trim()) ?? 0,
        'Zamowienia': int.tryParse(_ordersController.text.trim()) ?? 0,
        'Bilans Zamowien':
            int.tryParse(_orderBalanceController.text.trim()) ?? 0,
        'Dodatkowa informacja': _additionalInfoController.text.trim(),
        'Bilans produkcji':
            int.tryParse(_productionBalanceController.text.trim()) ?? 0,
        'Kod kontrahenta': _contractorCodeController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produkt został dodany!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Błąd: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj Produkt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField('Kod produktu (unikalny)', _codeController),
              _buildTextField('Nazwa', _nameController),
              _buildTextField('Stan magazynowy', _stockController),
              _buildTextField('Rezerwacja', _reservationController),
              _buildTextField('Ilość dostępna', _availableController),
              _buildTextField('Zamówienia', _ordersController),
              _buildTextField('Bilans Zamówień', _orderBalanceController),
              _buildTextField(
                  'Dodatkowa informacja', _additionalInfoController),
              _buildTextField('Bilans produkcji', _productionBalanceController),
              _buildTextField('Kod kontrahenta', _contractorCodeController),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final clipboardData = await Clipboard.getData('text/plain');
                  if (clipboardData?.text != null) {
                    pasteData(clipboardData!.text!);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Schowek jest pusty.')),
                    );
                  }
                },
                child: const Text('Wklej dane z Excela'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addProduct,
                child: const Text('Zapisz Produkt'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
        keyboardType: (label.contains('Stan') ||
                label.contains('Bilans') ||
                label.contains('Ilość'))
            ? TextInputType.number
            : TextInputType.text,
      ),
    );
  }
}

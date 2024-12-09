import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddRecepturaScreen extends StatefulWidget {
  const AddRecepturaScreen({Key? key}) : super(key: key);

  @override
  _AddRecepturaScreenState createState() => _AddRecepturaScreenState();
}

class _AddRecepturaScreenState extends State<AddRecepturaScreen> {
  final TextEditingController indeksController = TextEditingController();
  final List<TextEditingController> skladnikiControllers =
      List.generate(20, (index) => TextEditingController());
  final List<TextEditingController> ilosciControllers =
      List.generate(20, (index) => TextEditingController());

  @override
  void dispose() {
    indeksController.dispose();
    for (var controller in skladnikiControllers) {
      controller.dispose();
    }
    for (var controller in ilosciControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void pasteData(String clipboardData) {
    final List<String> lines = clipboardData.split('\n');
    for (int i = 0; i < lines.length && i < 20; i++) {
      final List<String> columns = lines[i].split('\t');
      if (columns.isNotEmpty) {
        skladnikiControllers[i].text = columns[0].trim(); // Pierwsza kolumna
      }
      if (columns.length > 1) {
        ilosciControllers[i].text = columns[1].trim(); // Druga kolumna
      }
    }
  }

  void saveReceptura() async {
    // Pobieramy indeks paczki i zamieniamy '/' na '_'
    final String indeksPaczki =
        indeksController.text.trim().replaceAll('/', '_');

    if (indeksPaczki.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Proszę podać indeks paczki.')),
      );
      return;
    }

    final Map<String, dynamic> skladnikiData = {};
    for (int i = 0; i < 20; i++) {
      final String skladnik = skladnikiControllers[i].text.trim();
      final String iloscText = ilosciControllers[i].text.trim();
      if (skladnik.isNotEmpty && iloscText.isNotEmpty) {
        try {
          final int ilosc = int.parse(iloscText);
          skladnikiData['skladnik${i + 1}'] = {'Kod': skladnik, 'ilosc': ilosc};
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Błędna ilość dla składnika ${i + 1}: $iloscText'),
            ),
          );
          return;
        }
      }
    }

    if (skladnikiData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Proszę dodać przynajmniej jeden składnik.')),
      );
      return;
    }

    try {
      // Zapisujemy dane do Firestore
      await FirebaseFirestore.instance
          .collection('Receptury')
          .doc(indeksPaczki)
          .set(skladnikiData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Receptura została zapisana.')),
      );

      // Czyszczenie formularza
      indeksController.clear();
      for (var controller in skladnikiControllers) {
        controller.clear();
      }
      for (var controller in ilosciControllers) {
        controller.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wystąpił błąd: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj Recepturę'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Indeks Paczki:', style: TextStyle(fontSize: 18)),
              TextField(
                controller: indeksController,
                decoration: const InputDecoration(
                  hintText: 'Podaj indeks paczki',
                ),
              ),
              const SizedBox(height: 20),
              const Text('Składniki i Ilości:', style: TextStyle(fontSize: 18)),
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
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 20,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: skladnikiControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Składnik ${index + 1}',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: ilosciControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Ilość',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: saveReceptura,
                  child: const Text('Zapisz'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

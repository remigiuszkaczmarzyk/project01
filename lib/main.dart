import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project01/Screen1.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Konfiguracja Firebase
  const firebaseConfig = FirebaseOptions(
    apiKey: "AIzaSyB7sVQAjM1UCHumjP3l-tO28NoB4uPMGm4",
    authDomain: "produkcja2.firebaseapp.com",
    projectId: "produkcja2",
    storageBucket: "produkcja2.firebasestorage.app",
    messagingSenderId: "286512059249",
    appId: "1:286512059249:web:de42e0ebbb26e5b3111cd0",
  );

  // Inicjalizacja Firebase
  await Firebase.initializeApp(options: firebaseConfig);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Screen1(),
    );
  }
}

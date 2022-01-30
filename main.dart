import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:tp5_evenement_a_venir/pages/page_connexion.dart';
import 'package:tp5_evenement_a_venir/pages/page_demarrage.dart';
import 'package:tp5_evenement_a_venir/pages/page_evenement.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Événements à venir',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // return PageEvenement();
    // return const PageConnexion();
    return const PageDemarrage();
  }
}

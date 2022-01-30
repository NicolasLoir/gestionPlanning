// ignore_for_file: non_constant_identifier_names

import 'package:tp5_evenement_a_venir/modeles/utilisateur.dart';
import 'package:tp5_evenement_a_venir/pages/page_connexion.dart';
import 'package:tp5_evenement_a_venir/pages/page_evenement.dart';
import 'package:tp5_evenement_a_venir/utils/firebase_authentification.dart';
import 'package:flutter/material.dart';

class PageDemarrage extends StatefulWidget {
  const PageDemarrage({Key? key}) : super(key: key);

  @override
  _PageDemarrageState createState() => _PageDemarrageState();
}

class _PageDemarrageState extends State<PageDemarrage> {
  @override
  void initState() {
    _initialiser();
    super.initState();
  }

  Future _initialiser() async {
    final FirebaseAuthentification f = FirebaseAuthentification();
    Utilisateur u = await f.lireUtilisateur();
    setState(() {
      // to do: si utilisateur non connecter, afficher un message d'erreur dans le try catch

      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (BuildContext context) => PageEvenement("test")));

      if (u.isAnonymous!) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const PageConnexion()));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => PageEvenement(u.uid!)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chargement'),
      ),
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.black,
          valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

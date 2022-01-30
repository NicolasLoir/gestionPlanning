import 'package:flutter/material.dart';
import 'package:tp5_evenement_a_venir/pages/page_evenement.dart';
import 'package:tp5_evenement_a_venir/utils/firebase_authentification.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PageConnexion extends StatefulWidget {
  const PageConnexion({Key? key}) : super(key: key);

  @override
  _PageConnexionState createState() => _PageConnexionState();
}

class _PageConnexionState extends State<PageConnexion> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: '_pageConnexion');
  final mailController = TextEditingController();
  final mdpController = TextEditingController();

  String? _idUtilisateur;
  String? _mdpUtilisatuer;
  String? _emailUtilisateur;

  bool _estConnectable = true;
  String _message = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connexion"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      buildMail(),
                      const SizedBox(
                        height: 30,
                      ),
                      buildMdp(),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              boutonPrincipal(),
              boutonSecondaire(),
              const SizedBox(
                height: 10,
              ),
              messageValidation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMail() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: mailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'Adresse mail',
            icon: Icon(Icons.mail_outline),
          ),
          validator: (name) =>
              name != null && name.isEmpty ? 'Saisir une adresse mail' : null,
        ),
      );

  Widget buildMdp() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: mdpController,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'Mot de passe',
            icon: Icon(Icons.lock),
          ),
          validator: (name) =>
              name != null && name.isEmpty ? 'Saisir un mot de passe' : null,
        ),
      );

  Widget boutonPrincipal() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 22),
          primary: Theme.of(context).colorScheme.primary,
          onPrimary: Colors.white,
          side: BorderSide(
              color: Theme.of(context).colorScheme.primary), //  Work!
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22.0),
              side: const BorderSide(width: 3) // (Not working - Read note!!)
              ),
        ),
        child: _estConnectable
            ? const Text('Connexion')
            : const Text('Créer un compte'),
        onPressed: () async {
          final isValid = _formKey.currentState!.validate();

          if (isValid) {
            setState(() {
              _message = "";
            });
            soumettre();
          } else {
            setState(() {
              _message = "Veuillez remplir les champs ci dessus";
            });
          }
        },
      );

  Widget boutonSecondaire() => TextButton(
        style: TextButton.styleFrom(
          primary: Colors.grey,
        ),
        child: _estConnectable
            ? const Text(
                'Créer un compte',
                style: TextStyle(fontSize: 18),
              )
            : const Text('Connexion'),
        onPressed: () {
          setState(() {
            _estConnectable = !_estConnectable;
          });
        },
      );
  Widget messageValidation() => Text(
        _message,
        style: const TextStyle(fontSize: 16, color: Colors.red),
      );

  Future soumettre() async {
    final FirebaseAuthentification f = FirebaseAuthentification();

    _emailUtilisateur = mailController.text;
    _mdpUtilisatuer = mdpController.text;
    if (_estConnectable) {
      try {
        _idUtilisateur =
            await f.connexion(_emailUtilisateur!, _mdpUtilisatuer!);
        // print("connexion ok " + _idUtilisateur!);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    PageEvenement(_idUtilisateur!)));
        _message = "Connexion réussi";
      } on FirebaseAuthException catch (e) {
        // print('Failed with error code: ${e.code}');
        // print(e.message);
        _message = e.message!;
      }
    } else {
      print("creer un compte");
      _message = await f.inscription(_emailUtilisateur!, _mdpUtilisatuer!);
    }

    setState(() {
      _message = _message;
    });
  }
}

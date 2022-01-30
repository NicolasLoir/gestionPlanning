// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:tp5_evenement_a_venir/modeles/detail_evenement.dart';
import 'package:tp5_evenement_a_venir/modeles/favori.dart';
import 'package:tp5_evenement_a_venir/pages/page_connexion.dart';
import 'package:tp5_evenement_a_venir/utils/firebase_authentification.dart';
import 'package:tp5_evenement_a_venir/utils/gestion_firestore_database.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PageEvenement extends StatefulWidget {
  String idUtilisateur;
  PageEvenement(this.idUtilisateur, {Key? key}) : super(key: key);

  @override
  _PageEvenementState createState() => _PageEvenementState();
}

class _PageEvenementState extends State<PageEvenement> {
  //---------------------
  //Affichage des evenement et gestion favoris
  //-------------------------------

  late List<DetailEvenement> listEvenement;
  late List<Favori> favoris;
  int nombreEvenement = 0;

  @override
  void initState() {
    if (mounted) {
      GestionFirestoreDatabase.lireListeDetails().then((evenement) {
        setState(() {
          listEvenement = evenement;
          nombreEvenement = listEvenement.length;
        });
      });

      GestionFirestoreDatabase.lireFavoris(widget.idUtilisateur).then((value) {
        setState(() {
          favoris = value;
        });
      });
      super.initState();
    }
  }

  bool estFavori(String? idEvenement) {
    bool retour = false;
    if (favoris.isNotEmpty) {
      Favori favori = favoris.firstWhere(
          (favori) => (favori.idEvenement == idEvenement),
          orElse: () =>
              Favori(idEvenement: "0", idUtilisateur: "0", idFavori: "0"));
      if (favori.idEvenement != "0") retour = true;
    }
    return retour;
  }

  void basculerEtatFavori(DetailEvenement detail) async {
    if (estFavori(detail.id)) {
      Favori favori = favoris
          .firstWhere((Favori favori) => (favori.idEvenement == detail.id));
      String? idFavori = favori.idFavori;
      await GestionFirestoreDatabase.detruireFavori(idFavori!);
    } else {
      GestionFirestoreDatabase.ajouterFavori(detail, widget.idUtilisateur);
    }
    List<Favori> majFavoris =
        await GestionFirestoreDatabase.lireFavoris(widget.idUtilisateur);
    setState(() {
      favoris = majFavoris;
    });
  }

  //------------------------------
  //Ajouter un evenement
  //------------------------------

  final GlobalKey<FormState> _formKeyEvenement =
      GlobalKey<FormState>(debugLabel: '_ajouterEvenement');
  final animateurController = TextEditingController();
  final dateController = TextEditingController();
  final heureDebutController = TextEditingController();
  final heureFinController = TextEditingController();
  final descriptionController = TextEditingController();

  void afficherMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter un événement'),
          content: Form(
            key: _formKeyEvenement,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buildAnimateur(),
                  buildDate(),
                  buildHeureDebut(),
                  buidHeureFin(),
                  buildDescription(),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(),
              child: const Text('Ajouter'),
              onPressed: () async {
                final isValid = _formKeyEvenement.currentState!.validate();

                if (isValid) {
                  DetailEvenement evenement = DetailEvenement(
                      null,
                      const Uuid().v4(),
                      descriptionController.text,
                      dateController.text,
                      heureDebutController.text,
                      heureFinController.text,
                      animateurController.text,
                      false);

                  await GestionFirestoreDatabase.ajouterEvenement(evenement);
                  GestionFirestoreDatabase.lireListeDetails().then((evenement) {
                    setState(() {
                      listEvenement = evenement;
                      nombreEvenement = listEvenement.length;
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildAnimateur() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: animateurController,
          decoration: const InputDecoration(
            hintText: 'Animateur',
            icon: Icon(Icons.accessibility),
          ),
          validator: (name) =>
              name != null && name.isEmpty ? 'Saisir un animateur' : null,
        ),
      );

  Widget buildDate() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: dateController,
          decoration: const InputDecoration(
            hintText: 'Date',
            icon: Icon(Icons.date_range_outlined),
          ),
          validator: (name) =>
              name != null && name.isEmpty ? 'Saisir une date' : null,
        ),
      );

  Widget buildHeureDebut() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: heureDebutController,
          decoration: const InputDecoration(
            hintText: 'Heure de début',
            icon: Icon(Icons.query_builder),
          ),
          validator: (name) =>
              name != null && name.isEmpty ? "Saisir l'heure de début" : null,
        ),
      );

  Widget buidHeureFin() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: heureFinController,
          decoration: const InputDecoration(
            hintText: 'Heure de fin',
            icon: Icon(Icons.share_arrival_time_outlined),
          ),
          validator: (name) =>
              name != null && name.isEmpty ? "Saisir l'heure de fin" : null,
        ),
      );

  Widget buildDescription() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          controller: descriptionController,
          decoration: const InputDecoration(
            hintText: 'Description',
            icon: Icon(Icons.description_outlined),
          ),
          validator: (name) =>
              name != null && name.isEmpty ? "Saisir une description" : null,
        ),
      );

  //----------------------
  //Build
  //---------------------

  @override
  Widget build(BuildContext context) {
    final FirebaseAuthentification authentification =
        FirebaseAuthentification();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Evénements'),
        actions: [
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                authentification.deconnecter().then((resultat) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PageConnexion()));
                });
              }),
        ],
      ),
      body: ListView.builder(
        itemCount: nombreEvenement,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: Slidable(
              actionPane: const SlidableDrawerActionPane(),
              child: buildListTitle(
                listEvenement[position],
              ),
              actions: <Widget>[
                buildDeleteEevent(listEvenement[position]),
              ],
              secondaryActions: <Widget>[
                buildDeleteEevent(listEvenement[position]),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          afficherMessage(context);
        },
      ),
    );
  }

  Widget buildListTitle(DetailEvenement evenement) => ListTile(
        title: Text(evenement.description),
        subtitle: Text(
            "${evenement.date} - ${evenement.heureDebut} - ${evenement.heureFin}"),
        trailing: IconButton(
          icon: Icon(
            Icons.star,
            color: estFavori(evenement.id) ? Colors.amber : Colors.grey,
          ),
          onPressed: () {
            basculerEtatFavori(evenement);
          },
        ),
      );

  Widget buildDeleteEevent(DetailEvenement evenement) => IconSlideAction(
        caption: 'Delete',
        color: Colors.red,
        icon: Icons.delete,
        onTap: () async {
          await GestionFirestoreDatabase.deleteEvenement(evenement);
          GestionFirestoreDatabase.lireListeDetails().then((evenement) {
            setState(() {
              listEvenement = evenement;
              nombreEvenement = listEvenement.length;
            });
          });
        },
      );
}

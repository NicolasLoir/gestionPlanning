import 'package:tp5_evenement_a_venir/modeles/detail_evenement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tp5_evenement_a_venir/modeles/favori.dart';
import 'package:uuid/uuid.dart';

class GestionFirestoreDatabase {
  static final FirebaseFirestore bdd = FirebaseFirestore.instance;

  static Future<List<DetailEvenement>> lireListeDetails() async {
    FirebaseFirestore bdd = FirebaseFirestore.instance;
    var data = await bdd.collection('details_evenement').get();
    var details =
        data.docs.map((detail) => DetailEvenement.fromMap(detail)).toList();
    return details;
  }

  static Future ajouterEvenement(DetailEvenement evenement) {
    var resultat = bdd.collection('details_evenement').add(evenement.toMap())
        // .then((valeur) => print(valeur))
        .catchError((error) {
      print(error);
    });
    return resultat;
  }

  static Future deleteEvenement(DetailEvenement evenement) async {
    await bdd.collection('details_evenement').doc(evenement.id).delete();
    lireFavorisEvenement(evenement.id!).then((listFavori) {
      for (var favori in listFavori) {
        detruireFavori(favori.idFavori!);
      }
    });
  }

  static Future ajouterFavori(DetailEvenement detail, String idUtilisateur) {
    Favori favori = Favori(
        idEvenement: detail.id!,
        idUtilisateur: idUtilisateur,
        idFavori: const Uuid().v4());
    var resultat = bdd
        .collection('favoris')
        .add(favori.toMap())
        // .then((valeur) => print(valeur))
        .catchError((error) => print(error));
    return resultat;
  }

  static Future detruireFavori(String idFavori) async {
    await bdd.collection('favoris').doc(idFavori).delete();
  }

  static Future<List<Favori>> lireFavoris(String idUtilisateur) async {
    List<Favori> favoris;
    QuerySnapshot docs = await bdd
        .collection('favoris')
        .where('idUtilisateur', isEqualTo: idUtilisateur)
        .get();
    favoris = docs.docs.map((donnees) => Favori.fromMap(donnees)).toList();
    return favoris;
  }

  static Future<List<Favori>> lireFavorisEvenement(String idEvenement) async {
    List<Favori> favoris;
    QuerySnapshot docs = await bdd
        .collection('favoris')
        .where('idEvenement', isEqualTo: idEvenement)
        .get();
    favoris = docs.docs.map((donnees) => Favori.fromMap(donnees)).toList();
    return favoris;
  }
}

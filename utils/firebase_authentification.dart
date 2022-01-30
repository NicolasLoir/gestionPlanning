// import 'dart:async';

// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:tp5_evenement_a_venir/modeles/utilisateur.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';

class FirebaseAuthentification {
  final FirebaseAuth _authentificationFirebase = FirebaseAuth.instance;

  Future<String> connexion(String email, String mdp) async {
    await _authentificationFirebase.signInWithEmailAndPassword(
        email: email, password: mdp);
    return _authentificationFirebase.currentUser!.uid;
  }

  Future<String> inscription(String email, String mdp) async {
    try {
      await _authentificationFirebase.createUserWithEmailAndPassword(
          email: email, password: mdp);
    } on FirebaseAuthException catch (e) {
      // print('Failed with error code: ${e.code}');
      // print(e.message);
      return e.message!;
    }
    return 'Inscription réussi. Vous pouvez vous connecter';
  }

  Future deconnecter() async {
    await _authentificationFirebase.signOut();
  }

  Future<Utilisateur> lireUtilisateur() async {
    final firebase_user = _authentificationFirebase.currentUser;
    print(firebase_user);
    final Utilisateur un_utilisateur = Utilisateur();
    if (firebase_user == null) {
      un_utilisateur.isAnonymous = true;
    } else {
      un_utilisateur
        ..isAnonymous = firebase_user.isAnonymous
        ..email = firebase_user.email!
        ..uid = firebase_user.uid;
    }
    return un_utilisateur;
  }
}

// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class DetailEvenement {
  String? id;
  late String _description;
  late String _date;
  late String _heureDebut;
  late String _heureFin;
  late String _animateur;
  late bool _estFavori;

  DetailEvenement(
    Key? key,
    this.id,
    String description,
    String date,
    String heureDebut,
    String heureFin,
    String animateur,
    bool estFavori,
  ) {
    _description = description;
    _date = date;
    _heureDebut = heureDebut;
    _heureFin = heureFin;
    _animateur = animateur;
    _estFavori = estFavori;
  }

  String get description => _description;
  String get date => _date;
  String get heureDebut => _heureDebut;
  String get heureFin => _heureFin;
  String get animateur => _animateur;
  bool get estFavori => _estFavori;

  static const String CHAMP_DESCRIPTION = 'description';
  static const String CHAMP_DATE = 'date';
  static const String CHAMP_HEURE_DEBUT = 'heure_debut';
  static const String CHAMP_HEURE_FIN = 'heure_fin';
  static const String CHAMP_ANIMATEUR = 'animateur';
  static const String CHAMP_EST_FAVORI = 'est_favori';

  DetailEvenement.fromMap(dynamic obj) {
    id = obj.id;
    _description = obj[CHAMP_DESCRIPTION];
    _date = obj[CHAMP_DATE];
    _heureDebut = obj[CHAMP_HEURE_DEBUT];
    _heureFin = obj[CHAMP_HEURE_FIN];
    _animateur = obj[CHAMP_ANIMATEUR];
    _estFavori = obj[CHAMP_EST_FAVORI];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map[CHAMP_DESCRIPTION] = _description;
    map[CHAMP_DATE] = _date;
    map[CHAMP_HEURE_DEBUT] = _heureDebut;
    map[CHAMP_HEURE_FIN] = _heureFin;
    map[CHAMP_ANIMATEUR] = _animateur;
    map[CHAMP_EST_FAVORI] = _estFavori;
    return map;
  }
}

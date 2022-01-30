class Favori {
  String? idFavori;
  late String _idEvenement;
  late String _idUtilisateur;

  Favori(
      {this.idFavori,
      required String idEvenement,
      required String idUtilisateur}) {
    _idEvenement = idEvenement;
    _idUtilisateur = idUtilisateur;
  }

  String get idEvenement => _idEvenement;
  String get idUtilisateur => _idUtilisateur;

  static const String CHAMP_ID_EVENEMENT = 'idEvenement';
  static const String CHAMP_ID_UTILISATEUR = 'idUtilisateur';

  Favori.fromMap(dynamic obj) {
    idFavori = obj.id;
    _idEvenement = obj[CHAMP_ID_EVENEMENT];
    _idUtilisateur = obj[CHAMP_ID_UTILISATEUR];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map[CHAMP_ID_EVENEMENT] = _idEvenement;
    map[CHAMP_ID_UTILISATEUR] = _idUtilisateur;
    return map;
  }
}

class Fournisseur {
  final int idFr;
  final String nomFr;
  final String telephone;

  Fournisseur({
    required this.idFr,
    required this.nomFr,
    required this.telephone,
  });

  factory Fournisseur.fromJson(Map<String, dynamic> json) {
    return Fournisseur(
      idFr: json['idFr'],
      nomFr: json['nomFr'],
      telephone: json['telephone'],
    );
  }
}
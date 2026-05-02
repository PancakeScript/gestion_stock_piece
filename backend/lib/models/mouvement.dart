class Mouvement {
  int? id;
  int piece_id;
  String type;
  int quantite;

  Mouvement({
    this.id,
    required this.piece_id,
    required this.type,
    required this.quantite,
  });
}
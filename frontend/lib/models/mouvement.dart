class Mouvement {
  final int id;
  final int piece_id;
  final String type;
  final int quantite;

  Mouvement({
    required this.id,
    required this.piece_id,
    required this.type,
    required this.quantite,
  });

  factory Mouvement.fromJson(Map<String, dynamic> json) {
    return Mouvement(
      id: json['id'],
      piece_id: json['piece_id'],
      type: json['type'],
      quantite: json['quantite'],
    );
  }
}
class Piece {
  final int idPiece;
  final String nomPiece;
  final String reference;
  final double prix;
  final int quantite_stock;

  Piece({
    required this.idPiece,
    required this.nomPiece,
    required this.reference,
    required this.prix,
    required this.quantite_stock,
  });

  factory Piece.fromJson(Map<String, dynamic> json) {
    return Piece(
      idPiece: json['idPiece'],
      nomPiece: json['nomPiece'],
      reference: json['reference'],
      prix: double.parse(json['prix'].toString()),
      quantite_stock: json['quantite_stock'],
    );
  }
}
class Piece {
  int? idPiece;
  String nomPiece;
  String reference;
  double prix;
  int quantite_stock;
  int? idCat;

  Piece({
    this.idPiece,
    required this.nomPiece,
    required this.reference,
    required this.prix,
    required this.quantite_stock,
    this.idCat,
  });
}
class FilmCardModel {
  final String? picture;
  final String name;
  final double? rating;
  final String? description;
  FilmCardModel(
      {this.picture = null,
      required this.name,
      this.description = null,
      required this.rating});
}

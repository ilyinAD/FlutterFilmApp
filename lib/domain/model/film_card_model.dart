import '../../constants/constants.dart';

class FilmCardModel {
  final String? picture;
  final String name;
  final double? rating;
  final String? description;
  int status;
  int id;
  FilmCardModel(
      {this.picture,
      required this.name,
      this.description,
      required this.rating,
      this.status = untracked,
      required this.id});
}

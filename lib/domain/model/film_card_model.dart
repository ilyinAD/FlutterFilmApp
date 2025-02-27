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

  Map<String, dynamic> toJson() {
    return {
      'picture': picture,
      'name': name,
      'description': description,
      'id': id,
      'status': status,
      'rating': rating,
    };
  }

  factory FilmCardModel.fromJson(Map<String, dynamic> json) {
    return FilmCardModel(
      name: json['name'],
      picture: json['picture'],
      description: json['description'],
      id: json['id'],
      rating: json['rating'].toDouble(),
      status: json['status'],
    );
  }
}

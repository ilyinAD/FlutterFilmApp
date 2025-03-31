import '../../constants/constants.dart';

class FilmCardModel {
  final String? picture;
  final String name;
  final double? rating;
  final String? description;
  final String? userDescription;
  final double? userRating;
  final String? filmURL;
  final List<String>? genres;
  int status;
  int id;
  FilmCardModel(
      {this.picture,
      required this.name,
      this.description,
      required this.rating,
      this.status = untracked,
      required this.id,
      this.userDescription,
      this.userRating,
      this.filmURL,
      this.genres});

  Map<String, dynamic> toJson() {
    return {
      'picture': picture,
      'name': name,
      'description': description,
      'id': id,
      'status': status,
      'rating': rating,
      'user_description': userDescription,
      'user_rating': userRating,
      'film_url': filmURL,
    };
  }

  factory FilmCardModel.fromJson(Map<String, dynamic> json) {
    print(json['user_rating']);
    return FilmCardModel(
        name: json['name'],
        picture: json['picture'],
        description: json['description'],
        id: json['id'],
        rating: json['rating'].toDouble(),
        status: json['status'],
        userDescription: json['user_description'],
        userRating: json['user_rating']?.toDouble(),
        filmURL: json['film_url']);
  }
}

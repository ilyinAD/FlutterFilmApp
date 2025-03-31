import 'package:logger/logger.dart';

class ApiFilmCard {
  final String? picture;
  final String name;
  final double? rating;
  final String? description;
  final int id;
  final String? filmURL;
  final List<dynamic>? genres;
  ApiFilmCard(
      {required this.name,
      required this.rating,
      required this.picture,
      required this.description,
      required this.id,
      required this.filmURL,
      required this.genres});

  ApiFilmCard.fromJson(Map<String, dynamic> json)
      : name = json["show"]["name"],
        rating = json["show"]["rating"] != null
            ? double.tryParse(json["show"]["rating"]["average"].toString())
            : null,
        picture = json["show"]["image"] != null
            ? json["show"]["image"]["medium"]
            : null,
        description = json["show"]["summary"],
        id = json["show"]["id"],
        filmURL = json["show"]["url"],
        genres = json["show"]["genres"];
}

// String getName(Map<String, dynamic> json) {
//   String ans = "";
//   try {
//     ans = json["show"]["name"];
//   } catch (e) {
//     final logger = Logger();
//     logger.w("No name in request");
//   }
//   return ans;
// }
//
// String getRating(Map<String, dynamic> json) {
//   double ans = "";
//   try {
//     ans = json["show"]["name"];
//   } catch (e) {
//     final logger = Logger();
//     logger.w("No name in request");
//   }
//   return ans;
// }

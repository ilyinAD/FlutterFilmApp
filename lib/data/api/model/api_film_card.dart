import 'package:logger/logger.dart';

class ApiFilmCard {
  final String? picture;
  final String name;
  final double? rating;
  final String? description;
  final int id;
  // ApiFilmCard(
  //     {this.picture = null,
  //     required this.name,
  //     required this.rating,
  //     this.description = null});
  ApiFilmCard(
      {required this.name,
      required this.rating,
      required this.picture,
      required this.description,
      required this.id});

  ApiFilmCard.fromJson(Map<String, dynamic> json)
      : name = json["show"]["name"],
        rating = json["show"]["rating"] != null
            ? double.tryParse(json["show"]["rating"]["average"].toString())
            : null,
        picture = json["show"]["image"] != null
            ? json["show"]["image"]["medium"]
            : null,
        description = json["show"]["summary"],
        id = json["show"]["id"];
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

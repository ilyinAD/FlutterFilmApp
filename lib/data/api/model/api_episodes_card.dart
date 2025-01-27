class ApiEpisodeCard {
  double? rating;
  int id;
  String? image;
  String? description;
  int? number;
  ApiEpisodeCard(
      {required this.id,
      this.rating,
      this.image,
      this.description,
      this.number});

  ApiEpisodeCard.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        rating = json["rating"] != null ? json["rating"]["average"] : null,
        image = json["image"] != null ? json["image"]["medium"] : null,
        description = json["summary"],
        number = json["number"];
}

// class ApiEpisodesList {
//   List<ApiEpisodeCard> episodes;
//   ApiEpisodesList({required this.episodes});
// }

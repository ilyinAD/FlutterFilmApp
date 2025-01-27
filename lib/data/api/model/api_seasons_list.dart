import 'package:chck_smth_in_flutter/data/api/model/api_episodes_card.dart';

class ApiSeasonCard {
  int id;
  int number;
  String? image;
  String? description;
  List<ApiEpisodeCard>? episodes;
  ApiSeasonCard(
      {required this.id, required this.number, this.image, this.description});

  ApiSeasonCard.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        number = json["number"],
        image = json["image"] != null ? json["image"]["medium"] : null,
        description = json["summary"];
}

class ApiSeasonsList {
  List<ApiSeasonCard> seasons;
  ApiSeasonsList({required this.seasons});
}

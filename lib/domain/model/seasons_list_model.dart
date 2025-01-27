import 'package:chck_smth_in_flutter/domain/model/episodes_card_model.dart';

class SeasonCardModel {
  int id;
  int number;
  String? image;
  String? description;
  List<EpisodeCardModel>? episodes;
  SeasonCardModel(
      {required this.id,
      required this.number,
      this.image,
      this.description,
      this.episodes});
}

class SeasonsListModel {
  List<SeasonCardModel> seasons;
  SeasonsListModel({required this.seasons});
}

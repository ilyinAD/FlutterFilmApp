import 'package:chck_smth_in_flutter/data/api/model/api_episodes_card.dart';
import 'package:chck_smth_in_flutter/data/api/model/api_seasons_list.dart';
import 'package:chck_smth_in_flutter/data/mapper/episode_card_mapper.dart';
import 'package:chck_smth_in_flutter/domain/model/episodes_card_model.dart';
import 'package:chck_smth_in_flutter/domain/model/seasons_list_model.dart';
import '../../utils/utils.dart';

class SeasonCardMapper {
  static SeasonCardModel fromApi(ApiSeasonCard season) {
    //String needDescription = parseHtmlString(season.description ?? "");
    String needDescription = season.description ?? "";
    return SeasonCardModel(
        id: season.id,
        number: season.number,
        image: season.image,
        description: needDescription,
        episodes: season.episodes
            ?.map((ApiEpisodeCard e) => EpisodeCardMapper.fromApi(e))
            .toList());
  }
}

class SeasonsListMapper {
  static SeasonsListModel fromApi(ApiSeasonsList seasons) {
    return SeasonsListModel(
        seasons: seasons.seasons
            .map((ApiSeasonCard e) => SeasonCardMapper.fromApi(e))
            .toList());
  }
}

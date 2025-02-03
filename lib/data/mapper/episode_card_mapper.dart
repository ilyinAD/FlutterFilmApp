import 'package:chck_smth_in_flutter/data/api/model/api_episodes_card.dart';
import 'package:chck_smth_in_flutter/domain/model/episodes_card_model.dart';
import '../../utils/utils.dart';

class EpisodeCardMapper {
  static EpisodeCardModel fromApi(ApiEpisodeCard episode) {
    //String needDescription = parseHtmlString(episode.description ?? "");
    String needDescription = episode.description ?? "";
    return EpisodeCardModel(
        id: episode.id,
        rating: episode.rating,
        image: episode.image,
        description: needDescription,
        number: episode.number);
  }
}

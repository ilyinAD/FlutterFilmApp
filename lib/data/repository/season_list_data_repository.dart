import 'package:chck_smth_in_flutter/data/api/api_utils.dart';
import 'package:chck_smth_in_flutter/domain/model/seasons_list_model.dart';

import '../../domain/repository/season_list_repository.dart';

class SeasonListDataRepository extends SeasonListRepository {
  ApiUtil apiUtil;
  SeasonListDataRepository({required this.apiUtil});
  @override
  Future<SeasonsListModel> getSeasonList({required int seriesId}) {
    return apiUtil.getSeasonList(seriesId);
  }
}

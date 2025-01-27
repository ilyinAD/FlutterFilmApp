import 'package:chck_smth_in_flutter/domain/model/seasons_list_model.dart';

abstract class SeasonListRepository {
  Future<SeasonsListModel> getSeasonList({required int seriesId});
}

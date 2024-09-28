import '../../domain/model/film_list_model.dart';
import '../../domain/repository/film_list_repository.dart';
import '../api/api_utils.dart';

class FilmListDataRepository extends FilmListRepository {
  ApiUtil apiUtil;
  FilmListDataRepository({required this.apiUtil});
  @override
  Future<FilmListModel> getFilmList({required String search}) {
    return apiUtil.getFilmList(search);
  }
}

import 'package:chck_smth_in_flutter/domain/home_bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/model/film_card_model.dart';
import '../pages/add_card_page.dart';
import '../pages/home_page.dart';

class FilmInfo extends StatelessWidget {
  final FilmCardModel result;
  final int index;
  const FilmInfo({super.key, required this.result, required this.index});

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    return InkWell(
      onTap: () {
        homeBloc.add(ChangeIndex(index: index));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
                child: FilmCard.fromFilmCardModel(
                  result: result,
                ),
                value: homeBloc),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: result.picture != null
                ? Image.network(
                    result.picture!,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return CircularProgressIndicator();
                    },
                  )
                : Image.asset('assets/images/sticker.jpg'),
          ),
          //Text(homeState.filmList.results[index].name),
          //Text(homeState.filmList.results[index].rating.toString()),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(result.rating.toString()),
                Text(result.name),
                Text(
                  result.description ?? "",
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
    ;
  }
}

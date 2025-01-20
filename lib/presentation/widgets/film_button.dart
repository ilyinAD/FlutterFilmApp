import 'package:chck_smth_in_flutter/domain/home_bloc/home_bloc.dart';
import 'package:chck_smth_in_flutter/presentation/widgets/query_film_widget.dart';
import 'package:chck_smth_in_flutter/presentation/widgets/tracked_film_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/model/film_card_model.dart';
import '../pages/add_card_page.dart';
import '../pages/home_page.dart';
import '../../presentation/widgets/film_info.dart';

class FilmButton extends StatefulWidget {
  FilmCardModel result;
  final bool isTracked;
  FilmButton({super.key, required this.result, required this.isTracked});

  @override
  State<FilmButton> createState() => _FilmButtonState();
}

class _FilmButtonState extends State<FilmButton> {
  void onUpdate({required FilmCardModel updatedResult}) {
    setState(() {
      widget.result = updatedResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final homeBloc = BlocProvider.of<HomeBloc>(context);
    return InkWell(
      onTap: () async {
        //homeBloc.add(ChangeIndex(index: index));
        var updateResult;
        if (!widget.isTracked) {
          updateResult = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QueryFilmWidget(film: widget.result)),
          );
        } else {
          updateResult = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TrackedFilmWidget(id: widget.result.id)),
          );
          onUpdate(updatedResult: updateResult);
        }

        if (updateResult != null) {
          //onUpdate(updatedResult: updatedResult);
          setState(() {});
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: widget.result.picture != null
                ? Image.network(
                    widget.result.picture!,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return const CircularProgressIndicator();
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
                Text(widget.result.rating.toString()),
                Text(widget.result.name),
                Text(
                  widget.result.description ?? "",
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

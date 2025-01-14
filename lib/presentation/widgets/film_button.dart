import 'package:chck_smth_in_flutter/domain/home_bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/model/film_card_model.dart';
import '../pages/add_card_page.dart';
import '../pages/home_page.dart';
import '../../presentation/widgets/film_info.dart';

class FilmButton extends StatefulWidget {
  FilmCardModel result;
  final int? index;
  FilmButton({super.key, required this.result, this.index});

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
        final updatedResult = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FilmInfo.fromFilmCardModel(
              result: widget.result,
            ),
          ),
        );

        if (updatedResult != null) {
          onUpdate(updatedResult: updatedResult);
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

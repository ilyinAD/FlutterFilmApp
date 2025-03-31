import 'package:chck_smth_in_flutter/domain/home_bloc/home_bloc.dart';
import 'package:chck_smth_in_flutter/presentation/pages/query_film_page.dart';
import 'package:chck_smth_in_flutter/presentation/pages/tracked_film_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/model/film_card_model.dart';
import '../pages/add_card_page.dart';
import '../pages/home_page.dart';
import '../../presentation/widgets/film_info_widget.dart';

class FilmButton extends StatefulWidget {
  FilmCardModel result;
  final bool isTracked;
  VoidCallback? notifyParent;
  FilmButton(
      {super.key,
      required this.result,
      required this.isTracked,
      this.notifyParent});

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

        if (widget.notifyParent != null) {
          widget.notifyParent!();
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRect(
              child:
                  widget.result.picture != null && widget.result.picture != ""
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
          ),
          //Text(homeState.filmList.results[index].name),
          //Text(homeState.filmList.results[index].rating.toString()),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.result.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.result.rating == null
                          ? "-.-"
                          : widget.result.rating.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.result.description ?? "",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

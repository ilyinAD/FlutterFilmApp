import 'package:chck_smth_in_flutter/domain/model/film_card_model.dart';
import 'package:chck_smth_in_flutter/internal/dependencies/tracked_film_repository_module.dart';
import 'package:chck_smth_in_flutter/presentation/widgets/add_series_in_tracked_button.dart';
import 'package:chck_smth_in_flutter/presentation/widgets/delete_series_from_tracked_button.dart';
import 'package:chck_smth_in_flutter/presentation/widgets/film_info_widget.dart';
import 'package:flutter/material.dart';

class TrackedFilmWidget extends StatefulWidget {
  final int id;
  const TrackedFilmWidget({super.key, required this.id});

  @override
  State<TrackedFilmWidget> createState() => _TrackedFilmWidgetState();
}

class _TrackedFilmWidgetState extends State<TrackedFilmWidget> {
  late FilmCardModel film;
  //bool isLoading = true;
  void doUpdate() async {
    //isLoading = true;
    // var result = await TrackedFilmRepositoryModule.trackedFilmMapRepository()
    //     .getFilm(id: widget.id);

    setState(() {
      film = TrackedFilmRepositoryModule.trackedFilmMapRepository()
          .films[widget.id]!;
    });

    // setState(() {
    //   film = result;
    //   isLoading = false;
    // });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   doUpdate();
  // }

  @override
  Widget build(BuildContext context) {
    film = TrackedFilmRepositoryModule.trackedFilmMapRepository()
        .films[widget.id]!;
    //doUpdate();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        if (context.mounted) {
          Navigator.pop(context, film);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Информация о фильме'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FilmInfo.fromFilmCardModel(result: film),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DeleteSeriesButton(film: film),
                AddSeriesButton(
                  film: film,
                  onUpdate: doUpdate,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

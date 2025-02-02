import 'dart:math';

import 'package:chck_smth_in_flutter/domain/model/film_card_model.dart';
import 'package:chck_smth_in_flutter/domain/season_bloc/seasons_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'episodes_widget.dart';
import 'main_series_info_widget.dart';

class FilmInfo extends StatefulWidget {
  double? rating;
  String? picture;
  String? name;
  String? description;
  FilmCardModel film;

  FilmInfo.fromFilmCardModel({super.key, required FilmCardModel result})
      : rating = result.rating,
        picture = result.picture,
        name = result.name,
        description = result.description,
        film = result;

  @override
  State<FilmInfo> createState() => _FilmInfoState();
}

class _FilmInfoState extends State<FilmInfo>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  List<bool> isExpandedSeasons = [];
  late SeasonsBloc seasonsBloc;
  void onUpdate({required FilmCardModel updatedFilm}) {
    setState(() {
      widget.film = updatedFilm;
      widget.rating = updatedFilm.rating;
      widget.picture = updatedFilm.picture;
      widget.name = updatedFilm.name;
      widget.description = updatedFilm.description;
    });
  }

  @override
  void initState() {
    super.initState();
    seasonsBloc = SeasonsBloc();
    if (widget.film.id <= 0) {
      seasonsBloc.add(SeasonsLoadEmpty());
    } else {
      seasonsBloc.add(SeasonsIsNotLoaded());
      seasonsBloc.add(SeasonsLoadedEvent(seriesId: widget.film.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SeasonsBloc>(
      create: (context) => seasonsBloc,
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              MainSeriesInfo.fromFilmCardModel(result: widget.film),
              BlocBuilder<SeasonsBloc, SeasonsState>(builder: (context, state) {
                if (state.seasonsListModel == null) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final seasons = state.seasonsListModel!.seasons;
                if (isExpandedSeasons.isEmpty) {
                  isExpandedSeasons =
                      List.generate(seasons.length, (index) => false);
                }

                // return Column(
                //   children:
                //       List.generate(100, (index) => Text("Элемент $index")),
                // );

                return Column(
                    children: List.generate(seasons.length, (index) {
                  final season = seasons[index];
                  //bool isExpandedSeason = false;
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${season.number}-ый сезон",
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: season.image != null
                              ? Image.network(
                                  season.image!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                )
                              : widget.picture != null
                                  ? Image.network(
                                      widget.picture!,
                                      fit: BoxFit.contain,
                                      height: 200,
                                      width: double.infinity,
                                    )
                                  : Container(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isExpandedSeasons[index]
                                    ? widget.description!
                                    : "${widget.description!.substring(0, min(widget.description!.length, 100))}...",
                                softWrap: true,
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isExpandedSeasons[index] =
                                        !isExpandedSeasons[index];
                                  });
                                },
                                child: Text(isExpandedSeasons[index]
                                    ? "Скрыть"
                                    : "Показать больше"),
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EpisodesPage(season: season),
                                    ),
                                  );
                                },
                                child: const Text('Подробнее о сезоне'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }));
              }),
            ],
          ),
        ),
      ),
    );
  }
}

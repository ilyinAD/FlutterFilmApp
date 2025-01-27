import 'dart:math';

import 'package:chck_smth_in_flutter/domain/model/film_card_model.dart';
import 'package:chck_smth_in_flutter/domain/model/seasons_list_model.dart';
import 'package:chck_smth_in_flutter/domain/season_bloc/seasons_bloc.dart';
import 'package:chck_smth_in_flutter/presentation/pages/add_card_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilmInfo extends StatefulWidget {
  double? rating;
  String? picture;
  String? name;
  String? description;
  FilmCardModel film;
  //FilmInfo({super.key});
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
      seasonsBloc.add(DataLoadEmpty());
    } else {
      print("id > 0");
      seasonsBloc.add(DataIsNotLoaded());
      seasonsBloc.add(DataLoadedEvent(seriesId: widget.film.id));
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
            //mainAxisSize: MainAxisSize.min,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                //mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.picture != null)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Align(
                          alignment: Alignment.topCenter,
                          heightFactor: 0.5,
                          child: Image.network(
                            widget.picture!,
                            fit: BoxFit.cover,
                            height: 600,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  if (widget.name != null)
                    Text(
                      widget.name!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  const SizedBox(height: 8),
                  if (widget.rating != null)
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          widget.rating.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                ],
              ),
              if (widget.description != null)
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isExpanded
                              ? widget.description!
                              : "${widget.description!.substring(0, min(widget.description!.length, 100))}...",
                          softWrap: true,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          child:
                              Text(isExpanded ? "Скрыть" : "Показать больше"),
                        ),
                      ],
                    ),
                  ),
                ),
              BlocBuilder<SeasonsBloc, SeasonsState>(builder: (context, state) {
                if (state.seasonsListModel == null) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final seasons = state.seasonsListModel!.seasons;
                return ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: seasons.length,
                  itemBuilder: (context, index) {
                    final season = seasons[index];
                    //return Text("aaaaaaa");
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                            child: season.image != null
                                ? Image.network(
                                    season.image!,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Container(),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  season.description ?? "",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
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
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class EpisodesPage extends StatelessWidget {
  final SeasonCardModel season;

  const EpisodesPage({required this.season, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список серий'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: season.episodes != null ? season.episodes!.length : 0,
        itemBuilder: (context, index) {
          final episode = season.episodes![index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: episode.image != null
                  ? Image.network(
                      episode.image!,
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    )
                  : Image.asset('assets/images/sticker.jpg'),
            ),
            title: Text('Серия ${episode.number}'),
            subtitle: Text(
              episode.description ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
    );
  }
}

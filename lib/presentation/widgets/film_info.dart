import 'dart:math';

import 'package:chck_smth_in_flutter/domain/model/film_card_model.dart';
import 'package:chck_smth_in_flutter/presentation/pages/add_card_page.dart';
import 'package:flutter/material.dart';

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
  void onUpdate({required FilmCardModel updatedFilm}) {
    setState(() {
      widget.film = updatedFilm;
      widget.rating = updatedFilm.rating;
      widget.picture = updatedFilm.picture;
      widget.name = updatedFilm.name;
      widget.description = updatedFilm.description;
    });
  }

  Future<PopInvokedWithResultCallback?> _onWillPop() async {
    Navigator.pop(context, widget.film);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        if (context.mounted) {
          Navigator.pop(context, widget.film);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Информация о фильме'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
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
                Expanded(
                  // Делаем оставшееся пространство прокручиваемым
                  child: SingleChildScrollView(
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
                ),
              // Text(widget.film.status == null
              //     ? widget.film.status.toString()
              //     : "qqq"),
              Align(
                alignment: Alignment.bottomRight,
                child: RawMaterialButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              FilmCard.fromFilmCardModel(
                                result: widget.film,
                              )),
                    );
                    if (result != null) {
                      onUpdate(updatedFilm: result);
                    }
                  },
                  elevation: 2.0,
                  fillColor: Colors.white,
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                  child: const Icon(
                    Icons.add,
                    size: 35.0,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

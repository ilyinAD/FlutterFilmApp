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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      child: Text(isExpanded ? "Скрыть" : "Показать больше"),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

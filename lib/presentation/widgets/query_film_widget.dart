import 'package:chck_smth_in_flutter/domain/model/film_card_model.dart';
import 'package:chck_smth_in_flutter/presentation/widgets/add_film_in_tracked_button.dart';
import 'package:chck_smth_in_flutter/presentation/widgets/film_info.dart';
import 'package:flutter/material.dart';

class QueryFilmWidget extends StatefulWidget {
  final FilmCardModel film;
  const QueryFilmWidget({super.key, required this.film});
  @override
  State<QueryFilmWidget> createState() => _QueryFilmWidgetState();
}

class _QueryFilmWidgetState extends State<QueryFilmWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Информация о фильме'),
        ),
        //body: FilmInfo.fromFilmCardModel(result: widget.film)
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FilmInfo.fromFilmCardModel(result: widget.film),
            AddFilmButton(film: widget.film),
          ],
        ));
  }
}

import 'package:chck_smth_in_flutter/domain/model/film_card_model.dart';
import 'package:flutter/material.dart';

import '../pages/add_card_page.dart';

class AddSeriesButton extends StatelessWidget {
  final FilmCardModel film;
  final VoidCallback? onUpdate;
  const AddSeriesButton({super.key, required this.film, this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: RawMaterialButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => FilmCard.fromFilmCardModel(
                        result: film,
                      )),
            );
            if (onUpdate != null) {
              onUpdate!();
            }
            // if (result != null) {
            //   onUpdate(updatedFilm: result);
            // }
          },
          elevation: 2.0,
          fillColor: Colors.white,
          padding: const EdgeInsets.all(15.0),
          shape: const CircleBorder(),
          child: const Icon(
            Icons.edit,
            size: 35.0,
          ),
        ),
      ),
    );
  }
}

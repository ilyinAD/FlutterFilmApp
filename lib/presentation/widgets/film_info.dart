import 'package:chck_smth_in_flutter/domain/model/film_card_model.dart';
import 'package:chck_smth_in_flutter/presentation/pages/add_card_page.dart';
import 'package:flutter/material.dart';

class FilmInfo extends StatefulWidget {
  double? rating;
  String? picture;
  String? name;
  String? description;
  final FilmCardModel? film;
  //FilmInfo({super.key});
  FilmInfo.fromFilmCardModel({super.key, FilmCardModel? result})
      : rating = result?.rating,
        picture = result?.picture,
        name = result?.name,
        description = result?.description,
        film = result;

  @override
  State<FilmInfo> createState() => _FilmInfoState();
}

class _FilmInfoState extends State<FilmInfo>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                if (widget.description != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          _isExpanded
                              ? widget.description!
                              : '${widget.description!.substring(0, 100)}...',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        child: Text(
                          _isExpanded ? 'Свернуть' : 'Подробнее',
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                Text(widget.film?.status == null
                    ? widget.film!.status.toString()
                    : "qqq")
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: RawMaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            FilmCard.fromFilmCardModel(
                              result: widget.film,
                            )),
                  );
                },
                elevation: 2.0,
                fillColor: Colors.white,
                child: Icon(
                  Icons.add,
                  size: 35.0,
                ),
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

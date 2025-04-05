import 'package:flutter/material.dart';

class Genres extends StatefulWidget {
  final List<String> genres = [
    'Action',
    'Anime',
    'Adventure',
    'Comedy',
    'Crime',
    'Science-Fiction',
    'Drama',
    'Fantasy',
    'Horror',
    'Mystery',
    'Romance',
    'Thriller',
    'Food',
    'War',
    'Music'
  ];
  List<String> selectedGenres;
  Genres({super.key, required this.selectedGenres});

  @override
  State<Genres> createState() => _GenresState();
}

class _GenresState extends State<Genres> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setStateDialog) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Choose genres'),
            actions: [
              TextButton(
                child: const Text('Apply'),
                onPressed: () => Navigator.pop(context, widget.selectedGenres),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  children: widget.genres.map((genre) {
                    return CheckboxListTile(
                      title: Text(genre),
                      value: widget.selectedGenres.contains(genre),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            widget.selectedGenres.add(genre);
                          } else {
                            widget.selectedGenres.remove(genre);
                          }
                        });
                        setStateDialog(() {});
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

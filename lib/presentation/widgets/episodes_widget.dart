import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/model/seasons_list_model.dart';

class EpisodesPage extends StatefulWidget {
  final SeasonCardModel season;
  const EpisodesPage({required this.season, Key? key}) : super(key: key);

  @override
  State<EpisodesPage> createState() => _EpisodesPageState();
}

class _EpisodesPageState extends State<EpisodesPage> {
  late List<bool> isExpandedEpisodes;
  @override
  void initState() {
    super.initState();
    isExpandedEpisodes = List.generate(
        widget.season.episodes != null ? widget.season.episodes!.length : 0,
        (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список серий'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount:
            widget.season.episodes != null ? widget.season.episodes!.length : 0,
        itemBuilder: (context, index) {
          final episode = widget.season.episodes![index];
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
            title: Row(children: [
              Text('Серия ${episode.number}'),
              if (episode.rating != null)
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      episode.rating.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
            ]),
            subtitle: Column(
              children: [
                Text(
                  isExpandedEpisodes[index]
                      ? episode.description!
                      : "${episode.description!.substring(0, min(episode.description!.length, 100))}...",
                  softWrap: true,
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      isExpandedEpisodes[index] = !isExpandedEpisodes[index];
                    });
                  },
                  child: Text(
                      isExpandedEpisodes[index] ? "Скрыть" : "Показать больше"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

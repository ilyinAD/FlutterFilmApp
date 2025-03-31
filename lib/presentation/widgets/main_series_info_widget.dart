import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/model/film_card_model.dart';

class MainSeriesInfo extends StatefulWidget {
  double? rating;
  String? picture;
  String? name;
  String? description;
  String? userDescription;
  double? userRating;
  String? filmURL;
  //FilmCardModel film;

  MainSeriesInfo.fromFilmCardModel({super.key, required FilmCardModel result})
      : rating = result.rating,
        picture = result.picture,
        name = result.name,
        description = result.description,
        //film = result,
        userDescription = result.userDescription,
        userRating = result.userRating,
        filmURL = result.filmURL;

  @override
  State<MainSeriesInfo> createState() => _MainSeriesInfoState();
}

class _MainSeriesInfoState extends State<MainSeriesInfo> {
  Logger logger = Logger();
  Future<void> _goToURL(BuildContext context) async {
    logger.i(widget.filmURL);
    if (widget.filmURL == null || widget.filmURL!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Watch URL is not available for this film'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final Uri url = Uri.parse(widget.filmURL!);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        logger.e('Could not launch ${widget.filmURL}');
      }
    } catch (e) {
      logger.e('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                child: widget.picture != null
                    ? Container(
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
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 200,
                                  width: double.infinity,
                                  color: Colors.grey.shade300,
                                  child: const Center(
                                    child: Icon(Icons.image_not_supported,
                                        size: 50),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    : Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.movie, size: 50),
                        ),
                      ),
              ),
              if (widget.rating != null)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          widget.rating!.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (widget.userRating != null)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.indigo.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          widget.userRating!.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.name != null)
                  Text(
                    widget.name!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 8),
                if (widget.description != null)
                  ExpandedText(description: widget.description!),
                if (widget.userDescription != null &&
                    widget.userDescription!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Your Notes:",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: ExpandedText(
                                description: widget.userDescription)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _goToURL(context);
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Watch'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExpandedText extends StatefulWidget {
  String? description;

  ExpandedText({super.key, required this.description});

  @override
  State<ExpandedText> createState() => _ExpandedTextState();
}

class _ExpandedTextState extends State<ExpandedText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isExpanded
              ? widget.description!
              : "${widget.description!.substring(0, min(widget.description!.length, 100))}...",
          softWrap: true,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(isExpanded ? "hide" : "Show more"),
        ),
      ],
    );
  }
}

import 'package:chck_smth_in_flutter/domain/model/film_card_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilmCard extends StatefulWidget {
  double? rating;
  String? picture;
  String? name;
  String? description;
  FilmCard({super.key});
  FilmCard.fromFilmCardModel({FilmCardModel? result})
      : rating = result?.rating,
        picture = result?.picture,
        name = result?.name,
        description = result?.description;

  @override
  State<FilmCard> createState() => _FilmCardState();
}

class _FilmCardState extends State<FilmCard> {
  double? rating;
  String? picture;
  String? name;
  String? description;
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController descriptionEditingController = TextEditingController();
  TextEditingController ratingEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    name = widget.name;
    rating = widget.rating;
    picture = widget.picture;
    description = widget.description;
    nameEditingController.text = name != null ? name! : "";
    descriptionEditingController.text = description != null ? description! : "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                /*child: AspectRatio(
                  aspectRatio: 0.1,
                  child: Align(
                    alignment: Alignment.topLeft,*/
                child: picture != null
                    ? Image.network(
                        fit: BoxFit.contain,
                        picture!,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return CircularProgressIndicator();
                        },
                      )
                    : Image.asset('assets/images/sticker.jpg'),
              ),
              //),
              //),
              Expanded(
                flex: 2,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(),
                        ),
                        controller: nameEditingController,
                        //initialValue: name != null ? name! : "",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Rating",
                          border: OutlineInputBorder(),
                        ),
                        controller: ratingEditingController,
                        //initialValue: name != null ? name! : "",
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 4),
            child: SizedBox(
              height: 200,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 25.0,
                    horizontal: 10.0,
                  ),
                ),
                controller: descriptionEditingController,
                //initialValue: name != null ? name! : "",
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text("Save"),
      ),
    );
  }
}

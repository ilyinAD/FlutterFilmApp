import 'package:chck_smth_in_flutter/domain/model/film_card_model.dart';
import 'package:chck_smth_in_flutter/internal/dependencies/general_film_repository_module.dart';
import 'package:chck_smth_in_flutter/internal/dependencies/tracked_film_repository_module.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/constants.dart';

class FilmCard extends StatefulWidget {
  final double? rating;
  final String? picture;
  final String? name;
  final String? description;
  final String? userDescription;
  final double? userRating;
  final int status;
  final String? filmURL;
  String addedAt;
  String viewedAt;
  //final FilmCardModel film;
  final int id;
  //FilmCard({super.key});
  FilmCard.fromFilmCardModel({super.key, required FilmCardModel result})
      : rating = result.rating,
        picture = result.picture,
        name = result.name,
        description = result.description,
        //film = result,
        id = result.id,
        userRating = result.userRating,
        userDescription = result.userDescription,
        filmURL = result.filmURL,
        addedAt = result.addedAt,
        viewedAt = result.viewedAt,
        status = result.status;

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
  TextEditingController addedAtEditingController = TextEditingController();
  TextEditingController viewedAtEditingController = TextEditingController();
  final List<String> statusOptions = [
    'Viewed',
    'In process',
    'Wanna watch',
  ];

  final Map<String, int> statusMap = {
    "Viewed": 0,
    "In process": 1,
    "Wanna watch": 2
  };

  String? selectedStatus;
  bool _ratingControllerErr = false;
  @override
  void initState() {
    super.initState();
    name = widget.name;
    rating = widget.rating;
    picture = widget.picture;
    description = widget.description;
    nameEditingController.text = name != null ? name! : "";
    if (widget.status != untracked) {
      descriptionEditingController.text = widget.userDescription ?? "";
      ratingEditingController.text =
          widget.userRating != null ? widget.userRating!.toString() : "";
      viewedAtEditingController.text = widget.viewedAt.toString();
      addedAtEditingController.text = widget.addedAt.toString();
    }

    selectedStatus = widget.status == untracked
        ? statusOptions[0]
        : statusOptions[widget.status];
  }

  void changeDateControllerText() {
    if (statusMap[selectedStatus] == 0) {
      viewedAtEditingController.text = widget.viewedAt.toString();
      addedAtEditingController.text = widget.addedAt.toString();
    } else if (statusMap[selectedStatus] == 1) {
      viewedAtEditingController.text = "";
      addedAtEditingController.text = widget.addedAt.toString();
    } else {
      viewedAtEditingController.text = "";
      addedAtEditingController.text = "";
    }
  }

  @override
  void dispose() {
    nameEditingController.dispose();
    ratingEditingController.dispose();
    descriptionEditingController.dispose();
    addedAtEditingController.dispose();
    viewedAtEditingController.dispose();
    super.dispose();
  }

  String? _errorText1;
  String? _errorText2;

  final _dateFormat = DateFormat('dd.MM.yyyy');

  bool _isValidDate(String input) {
    try {
      final parsedDate = _dateFormat.parseStrict(input);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Widget _buildDateField(
  //   TextEditingController controller,
  //   String label,
  //   String? errorText,
  //   int fieldIndex,
  // ) {
  //   return TextField(
  //     controller: controller,
  //     keyboardType: TextInputType.datetime,
  //     decoration: InputDecoration(
  //       labelText: label,
  //       hintText: 'dd.mm.yyyy',
  //       border: OutlineInputBorder(),
  //       suffixIcon: Icon(Icons.calendar_today),
  //       errorText: errorText,
  //     ),
  //     onChanged: (value) {
  //       setState(() {
  //         final isValid = _isValidDate(value);
  //         if (fieldIndex == 1) {
  //           _errorText1 =
  //               isValid || value.isEmpty ? null : 'Invalid date format';
  //         } else if (fieldIndex == 2) {
  //           _errorText2 =
  //               isValid || value.isEmpty ? null : 'Invalid date format';
  //         }
  //       });
  //     },
  //   );
  // }

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
                            alignment: Alignment.topLeft,
                            child: Image.network(
                              widget.picture!,
                              fit: BoxFit.contain,
                              width: double.infinity,
                            ),
                          ),
                        ),
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
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Series status',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        value: selectedStatus,
                        items: statusOptions.map((String status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedStatus = newValue;
                            changeDateControllerText();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        controller: nameEditingController,
                        //initialValue: name != null ? name! : "",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          errorText: _ratingControllerErr
                              ? "Rating is a number between 0 and 10"
                              : null,
                          labelText: "Rating",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
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
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 200,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 25.0,
                      horizontal: 10.0,
                    ),
                  ),
                  controller: descriptionEditingController,

                  maxLines: null,

                  //initialValue: name != null ? name! : "",
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 4),
            child: TextField(
              controller: addedAtEditingController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: "Start watching series date",
                hintText: 'dd.mm.yyyy',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
                errorText: _errorText1,
              ),
              enabled: statusMap[selectedStatus] != wish,
              onChanged: (value) {
                setState(() {
                  final isValid = _isValidDate(value);
                  _errorText1 =
                      isValid || value.isEmpty ? null : 'Invalid date format';
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 4),
            child: TextField(
              controller: viewedAtEditingController,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                labelText: "End watching series date",
                hintText: 'dd.mm.yyyy',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
                errorText: _errorText2,
              ),
              enabled: statusMap[selectedStatus] == viewed,
              onChanged: (value) {
                setState(() {
                  final isValid = _isValidDate(value);
                  _errorText2 =
                      isValid || value.isEmpty ? null : 'Invalid date format';
                });
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (nameEditingController.text == "") {
            return;
          }

          setState(() async {
            late double? userRating;
            if (ratingEditingController.text == "") {
              userRating = null;
            } else {
              try {
                userRating = double.parse(ratingEditingController.text);
              } catch (e) {
                userRating = null;
                _ratingControllerErr = true;
                return;
              }
            }

            if (userRating != null && (userRating > 10 || userRating < 0)) {
              _ratingControllerErr = true;
              return;
            }

            FilmCardModel film = FilmCardModel(
              name: nameEditingController.text,
              userRating: userRating,
              rating: widget.rating,
              id: widget.id,
              description: widget.description,
              userDescription: descriptionEditingController.text,
              status: statusMap[selectedStatus] ?? 0,
              picture: picture,
              filmURL: widget.filmURL,
              viewedAt: viewedAtEditingController.text,
              addedAt: addedAtEditingController.text,
            );
            // TrackedFilmRepositoryModule.trackedFilmMapRepository()
            //     .addFilm(film: film);
            await GeneralFilmRepositoryModule.generalFilmRepository()
                .addFilm(film);
            Navigator.pop(context, film);
          });
        },
        label: const Text("Save"),
        //child: const Text("Сохранить"),
      ),
    );
  }
}

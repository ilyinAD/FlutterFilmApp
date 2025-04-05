import 'package:chck_smth_in_flutter/domain/model/updates_type_enum.dart';
import 'package:chck_smth_in_flutter/domain/updates_bloc/updates_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../widgets/film_button.dart';
import '../widgets/genres_widget.dart';

class UpdatedFilms extends StatefulWidget {
  const UpdatedFilms({super.key});

  @override
  State<UpdatedFilms> createState() => _UpdatedFilmsState();
}

class _UpdatedFilmsState extends State<UpdatedFilms> {
  List<String> selectedGenres = [];
  VoidCallback get _showGenreDialog => () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Genres(
                    selectedGenres: selectedGenres,
                  )),
        );
        setState(() {
          selectedGenres = result;
          currentPage = 1;
          _findUpdates();
        });
      };

  final FocusNode _focusNode = FocusNode();
  final List<String> updatesOptions = [];
  Map<String, UpdatesType> mapUpdates = {};
  late TextEditingController queryEditingController;
  late String updatesType;
  final UpdatesBloc updatesBloc = UpdatesBloc();
  @override
  void initState() {
    super.initState();
    for (var type in UpdatesType.values) {
      updatesOptions.add(type.name);
      mapUpdates[type.name] = type;
    }

    queryEditingController = TextEditingController();
    updatesType = updatesOptions[0];
    _findUpdates();
    //updatesBloc = BlocProvider.of<UpdatesBloc>(context);
  }

  void _findUpdates() {
    updatesBloc.add(FilmsIsNotLoaded());
    updatesBloc.add(FilmsLoadedEvent(
        name: mapUpdates[updatesType]!,
        pageNumber: currentPage,
        partNumber: currentPart,
        selectedGenres: selectedGenres));
  }

  int currentPage = 1;
  int currentPart = 1;
  bool isLastUpdateEmpty = false;
  Logger logger = Logger();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UpdatesBloc>(create: (context) => updatesBloc),
      ],
      child: Scaffold(
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButtonFormField<String>(
                focusNode: _focusNode,
                decoration: InputDecoration(
                  labelText: 'Since',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: _showGenreDialog,
                  ),
                ),
                value: updatesType,
                items: updatesOptions.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    updatesType = newValue!;
                    currentPage = 1;
                    _findUpdates();
                    //update(query: queryEditingController.text);
                  });
                  _focusNode.unfocus();
                },
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: ElevatedButton(
            //       onPressed: () {
            //         _findUpdates();
            //       },
            //       child: const Text("Find")),
            // ),

            BlocBuilder<UpdatesBloc, UpdatesState>(
              builder: (context, state) {
                if (state.isLoading == false &&
                    state.isGeted == true &&
                    state.filmList!.results.isEmpty) {
                  isLastUpdateEmpty = true;
                } else {
                  isLastUpdateEmpty = false;
                }
                if (state.isLoading == true) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state.isGeted == false) {
                  return Container(
                    child: Text("HX"),
                  );
                } else {
                  if (state.filmList != null &&
                      !state.filmList!.results.isEmpty) {
                    logger.i(
                        "UI: results length: ${state.filmList!.results.length}");
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.filmList != null
                            ? state.filmList!.results.length
                            : 0,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              FilmButton(
                                result: state.filmList!.results[index],
                                isTracked: false,
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        Text("End of the update list"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  if (currentPart == 1) {
                                    return;
                                  }
                                  setState(() {
                                    --currentPart;
                                    currentPage = 1;
                                    _findUpdates();
                                  });
                                },
                                child: Text("Load previous")),
                            ElevatedButton(
                                onPressed: () {
                                  if (currentPage <= 1 && isLastUpdateEmpty) {
                                    return;
                                  }
                                  setState(() {
                                    ++currentPart;
                                    currentPage = 1;
                                    _findUpdates();
                                  });
                                },
                                child: Text("Load more")),
                          ],
                        ),
                      ],
                    );
                  }
                }
              },
            ),
            //const Expanded(child: SizedBox()),
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      if (currentPage == 1) {
                        return;
                      }

                      setState(() {
                        currentPage -= 1;
                        _findUpdates();
                      });
                    },
                  ),
                  Text(
                    currentPage.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      if (isLastUpdateEmpty) {
                        return;
                      }

                      setState(() {
                        currentPage += 1;
                        _findUpdates();
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

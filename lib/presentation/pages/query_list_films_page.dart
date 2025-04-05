import 'package:chck_smth_in_flutter/domain/home_bloc/home_bloc.dart';
import 'package:chck_smth_in_flutter/presentation/widgets/main_navigation_panel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../widgets/film_button.dart';
import '../widgets/genres_widget.dart';

class ListOfFilms extends StatefulWidget {
  final TextEditingController textEditingController;
  const ListOfFilms({super.key, required this.textEditingController});

  @override
  State<ListOfFilms> createState() => _ListOfFilmsState();
}

class _ListOfFilmsState extends State<ListOfFilms> {
  List<String> selectedGenres = [];
  late HomeBloc homeBloc;
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
          homeBloc.add(FilmsIsNotLoaded());
          homeBloc.add(FilmsLoadedEvent(
              search: widget.textEditingController.text,
              selectedGenres: selectedGenres));
        });
      };

  @override
  void initState() {
    super.initState();
    homeBloc = BlocProvider.of<HomeBloc>(context);
  }

  Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    //final HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: const Text("Series"),
      // ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: widget.textEditingController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: _showGenreDialog,
                ),
                hintText: 'Searc series...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              onChanged: (text) {
                homeBloc.add(FilmsIsNotLoaded());
                homeBloc.add(FilmsLoadedEvent(
                    search: widget.textEditingController.text,
                    selectedGenres: selectedGenres));
              },
            ),
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state.isLoading == true) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (state.isGeted == false) {
                return Container();
              } else {
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.filmList != null
                        ? state.filmList!.results.length
                        : 0,
                    itemBuilder: (context, index) {
                      if (state.filmList != null) {
                        return Column(
                          children: [
                            FilmButton(
                              result: state.filmList!.results[index],
                              isTracked: false,
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

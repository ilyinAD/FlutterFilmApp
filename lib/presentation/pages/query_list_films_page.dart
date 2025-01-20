import 'package:chck_smth_in_flutter/domain/home_bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/film_button.dart';

class ListOfFilms extends StatelessWidget {
  final TextEditingController textEditingController;
  const ListOfFilms({super.key, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    final HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);
    return ListView(
      children: [
        TextField(
          controller: textEditingController,
          onChanged: (text) {
            homeBloc.add(DataIsNotLoaded());
            homeBloc.add(DataLoadedEvent(search: textEditingController.text));
          },
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
              return ListView.builder(
                shrinkWrap: true,
                itemCount:
                    state.filmList != null ? state.filmList!.results.length : 0,
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
              );
            }
          },
        ),
      ],
    );
  }
}

import 'package:chck_smth_in_flutter/domain/home_bloc/home_bloc.dart';
import 'package:chck_smth_in_flutter/presentation/widgets/film_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController textEditingController;
  final HomeBloc homeBloc = HomeBloc();
  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    homeBloc.add(DataIsNotGeted());

    return BlocProvider<HomeBloc>(
      create: (context) => homeBloc,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              homeBloc.add(DataIsNotLoaded());
              homeBloc.add(DataLoadedEvent(search: textEditingController.text));
            },
            tooltip: "update",
            child: Icon(Icons.update)),
        body: BlocBuilder<HomeBloc, HomeState>(
            bloc: homeBloc,
            builder: (context, state) {
              // return Align(
              //   child: state.chosenIndex != -1
              //       ? FilmInfo(
              //           result: state.filmList!.results[state.chosenIndex],
              //           index: state.chosenIndex)
              //       : ListOfFilms(
              //           textEditingController: textEditingController,
              //         ),
              // );
              return Align(
                child: ListOfFilms(
                  textEditingController: textEditingController,
                ),
              );
            }),
      ),
    );
  }
}

// class ChosenCard extends StatelessWidget {
//   const ChosenCard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
//         return FilmInfo(
//             result: state.filmList!.results[state.chosenIndex],
//             index: state.chosenIndex);
//       }),
//     );
//   }
// }

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
                    return FilmButton(
                      result: state.filmList!.results[index],
                      index: index,
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

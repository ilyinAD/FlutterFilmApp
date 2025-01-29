import 'package:chck_smth_in_flutter/presentation/pages/query_list_films_page.dart';
import 'package:chck_smth_in_flutter/presentation/pages/tracked_list_films_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/home_bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController textEditingController;
  int _selectedIndex = 0;
  late List<Widget> _pages;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final HomeBloc homeBloc = HomeBloc();
  @override
  void initState() {
    super.initState();
    homeBloc.add(FilmsIsNotGeted());
    textEditingController = TextEditingController();
    _pages = [
      ListOfFilms(textEditingController: textEditingController),
      const TrackedListOfFilms(),
    ];
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //homeBloc.add(DataIsNotGeted());
    return BlocProvider<HomeBloc>(
      create: (context) => homeBloc,
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //     onPressed: () {
        //       homeBloc.add(DataIsNotLoaded());
        //       homeBloc.add(DataLoadedEvent(search: textEditingController.text));
        //     },
        //     tooltip: "update",
        //     child: Icon(Icons.update)),
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
              return _pages[_selectedIndex];
              // return Align(
              //   child: ListOfFilms(
              //     textEditingController: textEditingController,
              //   ),
              // );
            }),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Поиск',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Список фильмов',
            ),
          ],
        ),
      ),
    );
  }
}

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   late TextEditingController textEditingController;
//   int _selectedIndex = 0;
//   late List<Widget> _pages;
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     textEditingController = TextEditingController();
//     _pages = [
//       ListOfFilms(textEditingController: textEditingController),
//       const TrackedListOfFilms(),
//     ];
//   }
//
//   @override
//   void dispose() {
//     textEditingController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Поиск',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.business),
//             label: 'Список фильмов',
//           ),
//         ],
//       ),
//     );
//   }
// }

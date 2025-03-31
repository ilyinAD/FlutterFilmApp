import 'package:chck_smth_in_flutter/domain/backend_bloc/backend_bloc.dart';
import 'package:chck_smth_in_flutter/internal/dependencies/backend_repository_module.dart';
import 'package:chck_smth_in_flutter/presentation/pages/query_list_films_page.dart';
import 'package:chck_smth_in_flutter/presentation/pages/tracked_list_films_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/home_bloc/home_bloc.dart';
import '../widgets/settings_widget.dart';

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
  final BackendBloc backendBloc = BackendBloc();
  @override
  void initState() {
    super.initState();
    homeBloc.add(FilmsIsNotGeted());
    backendBloc.add(BackendIsNotLoaded());
    print("START LOADING");
    backendBloc.add(BackendLoadedEvent());
    textEditingController = TextEditingController();
    print("done bloc");
    _pages = [
      ListOfFilms(textEditingController: textEditingController),
      const TrackedListOfFilms(),
      const Settings(),
    ];
    print("don");
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //homeBloc.add(DataIsNotGeted());
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(create: (context) => homeBloc),
        BlocProvider<BackendBloc>(create: (context) => backendBloc),
      ],
      //create: (context) => homeBloc,
      child: Scaffold(
        // appBar: AppBar(
        //   actions: [
        //     IconButton(
        //         onPressed: () {
        //           Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                   builder: (context) => const Settings()));
        //         },
        //         icon: const Icon(Icons.settings)),
        //   ],
        // ),
        // floatingActionButton: FloatingActionButton(
        //     onPressed: () {
        //       homeBloc.add(DataIsNotLoaded());
        //       homeBloc.add(DataLoadedEvent(search: textEditingController.text));
        //     },
        //     tooltip: "update",
        //     child: Icon(Icons.update)),
        body: BlocBuilder<BackendBloc, BackendState>(
            bloc: backendBloc,
            builder: (context, state) {
              return state.isLoading == true
                  ? Container()
                  : BlocBuilder<HomeBloc, HomeState>(
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
                        print("Selected index");
                        print(_selectedIndex);
                        return _pages[_selectedIndex];
                        // return Align(
                        //   child: ListOfFilms(
                        //     textEditingController: textEditingController,
                        //   ),
                        // );
                      });
            }),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Series list',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            )
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

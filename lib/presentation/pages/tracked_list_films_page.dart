import 'package:chck_smth_in_flutter/domain/model/film_card_model.dart';
import 'package:chck_smth_in_flutter/domain/repository/tracked_film_map_repository.dart';
import 'package:flutter/material.dart';

import '../../internal/dependencies/tracked_film_repository_module.dart';
import '../widgets/film_button.dart';
import 'add_card_page.dart';

class TrackedListOfFilms extends StatefulWidget {
  const TrackedListOfFilms({super.key});

  @override
  State<TrackedListOfFilms> createState() => _TrackedListOfFilmsState();
}

class _TrackedListOfFilmsState extends State<TrackedListOfFilms>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController queryEditingController;
  final Map<int, List<FilmCardModel>> _groupedFilms = {};
  int sortedFilter = 0;
  final List<String> filterOptions = [
    'Без фильтра',
    'По возрастанию рейтинга',
    'По убыванию рейтинга',
  ];

  final Map<String, int> filterMap = {
    "Без фильтра": 0,
    "По возрастанию рейтинга": 1,
    "По убыванию рейтинга": 2
  };

  void clearGroupedFilms() {
    _groupedFilms[0] = [];
    _groupedFilms[1] = [];
    _groupedFilms[2] = [];
  }

  void sortGroupedFilms({required int sortedFilter}) {
    if (sortedFilter > 0 && sortedFilter <= 2) {
      _groupedFilms[0]!
          .sort((a, b) => (a.rating ?? 0).compareTo(b.rating ?? 0));
      _groupedFilms[1]!
          .sort((a, b) => (a.rating ?? 0).compareTo(b.rating ?? 0));
      _groupedFilms[2]!
          .sort((a, b) => (a.rating ?? 0).compareTo(b.rating ?? 0));
    }

    if (sortedFilter == 2) {
      _groupedFilms[0] = _groupedFilms[0]!.reversed.toList();
      _groupedFilms[1] = _groupedFilms[1]!.reversed.toList();
      _groupedFilms[2] = _groupedFilms[2]!.reversed.toList();
    }
  }

  void updateGroupedFilms({required String query}) {
    final films = TrackedFilmRepositoryModule.trackedFilmMapRepository().films;
    films.forEach((key, value) {
      if (value.status != 3 &&
          value.name.toLowerCase().contains(query.toLowerCase(), 0)) {
        _groupedFilms[value.status]!.add(value);
      }
    });
    sortGroupedFilms(sortedFilter: sortedFilter);
  }

  void update({String query = ""}) {
    setState(() {
      clearGroupedFilms();
      //print("Update TrackedListOfFilms");
      updateGroupedFilms(query: query);
    });
  }

  @override
  void initState() {
    super.initState();
    queryEditingController = TextEditingController();
    clearGroupedFilms();

    _tabController = TabController(length: 3, vsync: this);
    updateGroupedFilms(query: "");
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Отмеченные сериалы"),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilmCard.fromFilmCardModel(
                      result: FilmCardModel(
                          name: "",
                          rating: null,
                          id: -TrackedFilmRepositoryModule
                                  .trackedFilmMapRepository()
                              .films
                              .length),
                    ),
                  ),
                );
                update(query: queryEditingController.text);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: queryEditingController,
                decoration: InputDecoration(
                  hintText: 'Поиск по отмеченным сериалам...',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey.shade600),
                    onPressed: () {
                      queryEditingController.text = "";
                      update();
                    },
                  ),
                ),
                onChanged: (value) {
                  update(query: value);
                  //print("Search query: $value");
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: DropdownButtonFormField<String>(
                focusNode: _focusNode,
                decoration: InputDecoration(
                  labelText: 'Фильтр',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                value: filterOptions[sortedFilter],
                items: filterOptions.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    sortedFilter = filterMap[newValue]!;
                    update(query: queryEditingController.text);
                  });
                  _focusNode.unfocus();
                },
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            TabBar(
              controller: _tabController,
              tabs: const <Widget>[
                Tab(text: 'Просмотренные'),
                Tab(text: 'В процессе'),
                Tab(text: 'Хочу посмотреть'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  ListView.builder(
                    itemCount: _groupedFilms[0]!.length,
                    itemBuilder: (context, index) {
                      return FilmButton(
                        result: _groupedFilms[0]![index],
                        isTracked: true,
                        notifyParent: update,
                      );
                    },
                  ),
                  ListView.builder(
                    itemCount: _groupedFilms[1]!.length,
                    itemBuilder: (context, index) {
                      return FilmButton(
                        result: _groupedFilms[1]![index],
                        isTracked: true,
                        notifyParent: update,
                      );
                    },
                  ),
                  ListView.builder(
                    itemCount: _groupedFilms[2]!.length,
                    itemBuilder: (context, index) {
                      return FilmButton(
                        result: _groupedFilms[2]![index],
                        isTracked: true,
                        notifyParent: update,
                      );
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

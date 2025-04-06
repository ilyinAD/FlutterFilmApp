import 'package:chck_smth_in_flutter/domain/model/film_card_model.dart';
import 'package:chck_smth_in_flutter/domain/repository/tracked_film_map_repository.dart';
import 'package:chck_smth_in_flutter/presentation/widgets/main_navigation_panel_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../internal/dependencies/tracked_film_repository_module.dart';
import '../../utils/utils.dart';
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
    'Without filter',
    'In ascending of rating',
    'In descending of rating',
  ];

  final Map<String, int> filterMap = {
    "Without filter": 0,
    "In ascending of rating": 1,
    "In descending of rating": 2
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
    for (var entry in films.entries) {
      final value = entry.value;
      if (value.status != 3 && isMovieMatch(value.name, query)) {
        final fromDate = fromDateEditingController.text;
        if (fromDate != "" && value.addedAt != "") {
          if (_dateFormat
              .parseStrict(value.addedAt)
              .isBefore(_dateFormat.parseStrict(fromDate))) {
            continue;
          }
        }

        final toDate = toDateEditingController.text;
        if (toDate != "" && value.viewedAt != "") {
          if (_dateFormat
              .parseStrict(value.viewedAt)
              .isAfter(_dateFormat.parseStrict(toDate))) {
            continue;
          }
        }
        _groupedFilms[value.status]!.add(value);
      }
    }
    sortGroupedFilms(sortedFilter: sortedFilter);
  }

  void update({String query = ""}) {
    if (_errorText2 != null || _errorText1 != null) {
      return;
    }
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
    //clearGroupedFilms();

    _tabController = TabController(length: 3, vsync: this);
    //updateGroupedFilms(query: "");
    update();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final FocusNode _focusNode = FocusNode();

  TextEditingController fromDateEditingController = TextEditingController();
  TextEditingController toDateEditingController = TextEditingController();

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

  bool _isDropdownVisible = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  TextField(
                    controller: queryEditingController,
                    decoration: InputDecoration(
                      hintText: 'Search on marked series...',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      prefixIcon:
                          Icon(Icons.search, color: Colors.grey.shade600),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                      suffixIcon: IconButton(
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
                    ),
                    onChanged: (value) {
                      update(query: value);
                      //print("Search query: $value");
                    },
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 0, 4),
                    child: TextField(
                      controller: fromDateEditingController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: "From",
                        hintText: 'dd.mm.yyyy',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                fromDateEditingController.text = "";
                                _errorText1 = null;
                                update(query: queryEditingController.text);
                              });
                            },
                            icon: const Icon(Icons.clear)),
                        errorText: _errorText1,
                      ),
                      onChanged: (value) {
                        setState(() {
                          final isValid = _isValidDate(value);
                          _errorText1 = isValid || value.isEmpty
                              ? null
                              : 'Invalid date format';
                          update(query: queryEditingController.text);
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 0, 4),
                    child: TextField(
                      controller: toDateEditingController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: "To",
                        hintText: 'dd.mm.yyyy',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                toDateEditingController.text = "";
                                _errorText2 = null;
                                update(query: queryEditingController.text);
                              });
                            },
                            icon: const Icon(Icons.clear)),
                        errorText: _errorText2,
                      ),
                      onChanged: (value) {
                        setState(() {
                          final isValid = _isValidDate(value);
                          _errorText2 = isValid || value.isEmpty
                              ? null
                              : 'Invalid date format';
                          update(query: queryEditingController.text);
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: DropdownButtonFormField<String>(
                focusNode: _focusNode,
                decoration: InputDecoration(
                  labelText: 'Filter',
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
                Tab(text: 'viewed'),
                Tab(text: 'In process'),
                Tab(text: 'Wanna watch'),
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

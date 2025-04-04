import 'package:chck_smth_in_flutter/presentation/pages/home_page.dart';
import 'package:chck_smth_in_flutter/presentation/widgets/settings_widget.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = HomePage();
        break;
      case 1:
        page = Settings();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(
            // leading: IconButton(
            //   onPressed: () {},
            //   icon: Icon(Icons.arrow_back),
            // ),
            title: Text("SerialTracker"),
          ),
          drawer: Drawer(
            child: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: true,
                    selectedIndex: selectedIndex,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings),
                        label: Text('Settings'),
                      ),
                    ],
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                        Navigator.pop(context);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          body: page,
        );
      });
    });
  }
}

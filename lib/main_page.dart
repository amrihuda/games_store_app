import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:games_store_app/helpers/xml_http.dart';
import 'package:games_store_app/menu.dart';
import 'package:games_store_app/pages/home/game.dart';
import 'package:games_store_app/pages/home/genre.dart';
import 'package:games_store_app/home.dart';
import 'package:games_store_app/pages/menu/profile.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    _homeNavigatorKey,
    _menuNavigatorKey,
  ];

  Future<bool> _systemBackButtonPressed() async {
    if (_navigatorKeys[_selectedIndex].currentState!.canPop()) {
      _navigatorKeys[_selectedIndex]
          .currentState!
          .pop(_navigatorKeys[_selectedIndex].currentContext);
      return true;
    } else {
      SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _systemBackButtonPressed,
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: IndexedStack(
            index: _selectedIndex,
            children: const <Widget>[
              HomeNavigator(),
              Text(
                'Index 1: Search',
                style: optionStyle,
              ),
              Text(
                'Index 2: Cart',
                style: optionStyle,
              ),
              MenuNavigator(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Menu',
            ),
          ],
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class HomeNavigator extends StatefulWidget {
  const HomeNavigator({super.key});

  @override
  State<HomeNavigator> createState() => _HomeNavigatorState();
}

GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();

class _HomeNavigatorState extends State<HomeNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _homeNavigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            switch (settings.name) {
              case '/':
                return const HomePage();
              case '/genres':
                return const GenrePage();
              case '/games':
                return const GamePage();
              default:
                return const HomePage();
            }
          },
        );
      },
    );
  }
}

class MenuNavigator extends StatefulWidget {
  const MenuNavigator({super.key});

  @override
  State<MenuNavigator> createState() => _MenuNavigatorState();
}

GlobalKey<NavigatorState> _menuNavigatorKey = GlobalKey<NavigatorState>();

class _MenuNavigatorState extends State<MenuNavigator> {
  var profile = {};

  @override
  void initState() {
    super.initState();

    getProfile().then((result) {
      setState(() {
        profile = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _menuNavigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            switch (settings.name) {
              case '/':
                return MenuPage(
                  profile: profile,
                );
              case '/profile':
                return const ProfilePage();
              default:
                return MenuPage(
                  profile: profile,
                );
            }
          },
        );
      },
    );
  }
}

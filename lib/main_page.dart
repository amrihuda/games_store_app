import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:games_store_app/menu.dart';
import 'package:games_store_app/pages/home/genre.dart';
import 'package:games_store_app/home.dart';
import 'package:games_store_app/pages/menu/profile.dart';
import 'package:games_store_app/search.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> _searchNavigatorKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> _menuNavigatorKey = GlobalKey<NavigatorState>();

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  int _selectedGame = -1;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    _homeNavigatorKey,
    _searchNavigatorKey,
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
    List<Widget> optionWidget = [
      Navigator(
        key: _homeNavigatorKey,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => HomePage(
              onMoreGamesPressed: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
              onGamePressed: (gameId) {
                setState(() {
                  _selectedGame = gameId;
                  _selectedIndex = 1;
                });
              },
            ),
          );
        },
      ),
      Navigator(
        key: _searchNavigatorKey,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => SearchPage(
              gameId: _selectedGame,
              onGamePressed: (gameId) {
                setState(() {
                  _selectedGame = gameId;
                });
              },
            ),
          );
        },
      ),
      const Text(
        'Index 2: Cart',
        style: optionStyle,
      ),
      Navigator(
        key: _menuNavigatorKey,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const MenuPage(),
          );
        },
      ),
    ];
    return WillPopScope(
      onWillPop: _systemBackButtonPressed,
      child: Scaffold(
        body: SafeArea(
          top: false,
          child: optionWidget.elementAt(_selectedIndex),
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

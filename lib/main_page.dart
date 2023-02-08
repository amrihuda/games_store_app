import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:games_store_app/helpers/xml_http.dart';
import 'package:games_store_app/menu.dart';
import 'package:games_store_app/pages/home/game_genre.dart';
import 'package:games_store_app/pages/home/genre.dart';
import 'package:games_store_app/home.dart';
import 'package:games_store_app/pages/menu/profile.dart';
import 'package:games_store_app/search.dart';

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

  var genres = [];
  var games = [];

  @override
  void initState() {
    super.initState();

    getGenres().then((result) {
      setState(() {
        genres = result;
      });
    });
    getGames().then((result) {
      setState(() {
        games = result;
      });
    });
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
            children: <Widget>[
              HomeNavigator(genres: genres, games: games),
              SearchNavigator(games: games),
              const Text(
                'Index 2: Cart',
                style: optionStyle,
              ),
              const MenuNavigator(),
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
  const HomeNavigator({
    Key? key,
    required this.genres,
    required this.games,
  }) : super(key: key);

  final List genres;
  final List games;

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
                return HomePage(
                  genres: widget.genres,
                  games: widget.games,
                );
              case '/genres':
                return GenrePage(
                  genres: widget.genres,
                );
              case '/games':
                return GameGenrePage(
                  games: widget.games,
                );
              default:
                return HomePage(
                  genres: widget.genres,
                  games: widget.games,
                );
            }
          },
        );
      },
    );
  }
}

class SearchNavigator extends StatefulWidget {
  const SearchNavigator({Key? key, required this.games}) : super(key: key);

  final List games;

  @override
  State<SearchNavigator> createState() => _SearchNavigatorState();
}

GlobalKey<NavigatorState> _searchNavigatorKey = GlobalKey<NavigatorState>();

class _SearchNavigatorState extends State<SearchNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _searchNavigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            switch (settings.name) {
              case '/':
                return SearchPage(
                  games: widget.games,
                );
              // case '/details':
              //   return ProfilePage(
              //     profile: profile,
              //   );
              default:
                return SearchPage(
                  games: widget.games,
                );
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

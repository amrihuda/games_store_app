import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:games_store_app/menu.dart';
import 'package:games_store_app/home.dart';
import 'package:games_store_app/search.dart';
import 'package:games_store_app/cart.dart';
import 'package:games_store_app/helpers/xml_http.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> _searchNavigatorKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> _cartNavigatorKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> _menuNavigatorKey = GlobalKey<NavigatorState>();

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  int _selectedGame = -1;
  int _selectedGenre = -1;

  int _countCart = 0;

  bool _alertVisible = false;
  var _textAlert = '';

  void showAlert(text) {
    setState(() {
      _alertVisible = false;
      _textAlert = text;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _alertVisible = true;
      });
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          _alertVisible = false;
        });
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    _homeNavigatorKey,
    _searchNavigatorKey,
    _cartNavigatorKey,
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
  void initState() {
    super.initState();

    getCart().then((result) {
      setState(() {
        _countCart = result.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int genreId = _selectedGenre;
    setState(() {
      _selectedGenre = -1;
    });
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
              genreId: genreId,
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
              onSelectedGenre: (genreId) {
                setState(() {
                  _selectedGenre = genreId;
                  _selectedIndex = 0;
                });
              },
              onAddedtoCart: (text) {
                setState(() {
                  _countCart++;
                });
                showAlert(text);
              },
              onGotoCart: () {
                setState(() {
                  _selectedIndex = 2;
                });
              },
            ),
          );
        },
      ),
      Navigator(
        key: _cartNavigatorKey,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => CartPage(
              onClearCart: (text) {
                setState(() {
                  _countCart = 0;
                });
                showAlert(text);
              },
            ),
          );
        },
      ),
      Navigator(
        key: _menuNavigatorKey,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => MenuPage(
              onSelectedGenre: (genreId) {
                setState(() {
                  _selectedGenre = genreId;
                  _selectedIndex = 0;
                });
              },
              onUpdateSuccess: (text) {
                showAlert(text);
              },
            ),
          );
        },
      ),
    ];
    return WillPopScope(
      onWillPop: _systemBackButtonPressed,
      child: Scaffold(
        body: SafeArea(
            top: false,
            child: Stack(
              children: [
                optionWidget.elementAt(_selectedIndex),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: Visibility(
                    key: ValueKey<bool>(_alertVisible),
                    visible: _alertVisible,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 55, left: 20, right: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              side: const BorderSide(color: Colors.blue),
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white),
                          onPressed: () {
                            setState(() {
                              _alertVisible = false;
                            });
                          },
                          child: Text(
                            _textAlert,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart),
                  Positioned(
                    top: -8,
                    right: -8,
                    child: _countCart > 0
                        ? Container(
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                            child: Center(
                              child: Text(
                                '$_countCart',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : Container(),
                  )
                ],
              ),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Menu',
            ),
          ],
          iconSize: 26,
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

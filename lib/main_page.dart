import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetOptions = <Widget>[
      Navigator(
        initialRoute: '/',
        onGenerateRoute: (settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case 'genres':
              builder = (context) => const GenrePage();
              break;
            case 'games':
              builder = (context) => const GamePage();
              break;
            default:
              builder = (context) => const HomePage();
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
      const Text(
        'Index 1: Search',
        style: optionStyle,
      ),
      const Text(
        'Index 2: Cart',
        style: optionStyle,
      ),
      Navigator(
        initialRoute: '/',
        onGenerateRoute: (settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case 'profile':
              builder = (context) => const ProfilePage();
              break;
            default:
              builder = (context) => const MenuPage();
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
    ];

    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:games_store_app/login.dart';
import 'package:localstorage/localstorage.dart';
import 'package:games_store_app/genre.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    final LocalStorage storage = LocalStorage('games_store_app');
    List<Widget> widgetOptions = <Widget>[
      Column(
        children: [
          ElevatedButton(
            child: const Text("Go to Genre Page"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const GenrePage();
              }));
            },
          ),
          Text(storage.getItem('user') ?? ''),
          storage.getItem('user') == null
              ? ElevatedButton(
                  child: const Text("Log in"),
                  onPressed: () {
                    storage.clear();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const LoginPage();
                        },
                      ),
                    );
                  },
                )
              : ElevatedButton(
                  child: const Text("Log out"),
                  onPressed: () {
                    storage.clear();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const LoginPage();
                        },
                      ),
                    );
                  },
                ),
        ],
      ),
      const Text(
        'Index 1: Games',
        style: optionStyle,
      ),
      const Text(
        'Index 2: Cart',
        style: optionStyle,
      ),
      const Text(
        'Index 3: Profile',
        style: optionStyle,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Games Store")),
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
            icon: Icon(Icons.sports_esports),
            label: 'Games',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:games_store_app/pages/auth/login.dart';
import 'package:localstorage/localstorage.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key, required this.profile}) : super(key: key);

  final Map profile;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final LocalStorage storage = LocalStorage('games_store_app');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Menu")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            SizedBox(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Image.network(
                      "http://localhost:3000/uploads/${widget.profile['image'] ?? ''}",
                      width: 60,
                      height: 60,
                      errorBuilder: (context, xception, stackTrace) {
                        return Image.asset(
                          'assets/images/game-controller.png',
                          width: 60,
                          height: 60,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.profile['username'] ?? ''),
                        Text(widget.profile['email'] ?? ''),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Divider(),
            SizedBox(
              height: 50,
              child: TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.black),
                onPressed: () {
                  Navigator.pushNamed(context, "/profile");
                },
                child: Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Center(child: Icon(Icons.person)),
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Profile"),
                        ],
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Center(child: Icon(Icons.navigate_next)),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.black),
                onPressed: () {
                  Navigator.pushNamed(context, "/library");
                },
                child: Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Center(child: Icon(Icons.sports_esports)),
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Library"),
                        ],
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: Center(child: Icon(Icons.navigate_next)),
                    )
                  ],
                ),
              ),
            ),
            const Divider(),
            SizedBox(
              height: 50,
              child: TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                onPressed: () {
                  storage.clear();
                  Navigator.of(context, rootNavigator: true).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) {
                        return const LoginPage();
                      },
                    ),
                  );
                },
                child: Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Center(child: Icon(Icons.logout)),
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Logout"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

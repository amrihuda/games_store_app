import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:games_store_app/pages/auth/login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final LocalStorage storage = LocalStorage('games_store_app');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
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
      ),
    );
  }
}

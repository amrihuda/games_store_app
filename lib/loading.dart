import 'package:flutter/material.dart';
import 'package:games_store_app/main_page.dart';
import 'package:games_store_app/pages/auth/login.dart';
import 'package:localstorage/localstorage.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    final LocalStorage storage = LocalStorage('games_store_app');
    Future.delayed(
        const Duration(seconds: 3),
        () => {
              if (storage.getItem('user') == null)
                {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return const LoginPage();
                  }))
                }
              else
                {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return const MainPage();
                  }))
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(color: Colors.white),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    width: 100,
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(top: 30.0),
                        ),
                        Image.asset('assets/images/game-controller.png'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      /// Loader Animation Widget
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:games_store_app/home.dart';
import 'package:games_store_app/login.dart';
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
                    return const HomePage();
                  }))
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: InkWell(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            /// Paint the area where the inner widgets are loaded with the
            /// background to keep consistency with the screen background
            Container(
              decoration: const BoxDecoration(color: Colors.white),
            ),

            /// Render the background image
            // Container(
            //   child: Image.asset(‘assets/somebackground.png’, fit: BoxFit.cover),
            // ),
            /// Render the Title widget, loader and messages below each other
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 30.0),
                      ),
                      // ‘Application Title’,
                    ],
                  )),
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
                      Text('Loading...'),
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

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'helpers/user_http.dart';
import 'package:games_store_app/home.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LocalStorage storage = LocalStorage('games_store_app');
  var form = {
    'usernameOrEmail': '',
    'password': '',
  };

  var tValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Center(
                  child: SizedBox(
                      width: 100,
                      height: 150,
                      child: Image.asset('asset/images/game-controller.png')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                      labelText: 'Username or Email',
                      hintText: 'Enter username or valid email'),
                  onChanged: (value) {
                    setState(() {
                      form['usernameOrEmail'] = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.blue,
                      ),
                      labelText: 'Password',
                      hintText: 'Enter secure password'),
                  onChanged: (value) {
                    setState(() {
                      form['password'] = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  tValue,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () async {
                      try {
                        var response = await userLogin(form);
                        if (response.statusCode == 200) {
                          storage.setItem('user', response.body);
                          if (!mounted) return;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const HomePage();
                              },
                            ),
                          );
                        } else {
                          setState(() {
                            tValue = jsonDecode(response.body)['message'];
                          });
                        }
                      } catch (e) {
                        setState(() {
                          tValue = e.toString();
                        });
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You haven\'t any account?',
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

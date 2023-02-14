import 'package:flutter/material.dart';
import 'package:games_store_app/main_page.dart';
import 'package:games_store_app/pages/auth/register.dart';
import 'package:localstorage/localstorage.dart';
import '../../helpers/xml_http.dart';
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
  bool _passwordVisible = true;

  var _errorMessage = '';

  bool _alertVisible = false;
  var _textAlert = '';

  void showAlert(text) {
    setState(() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset(
                                'assets/images/game-controller.png')),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        "Login to Your Account",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.white70,
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.blue,
                            ),
                            hintText: 'Username or Email'),
                        onChanged: (value) {
                          setState(() {
                            form['usernameOrEmail'] = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: TextField(
                        obscureText: _passwordVisible,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white70,
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.blue,
                          ),
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(_passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(
                                () {
                                  _passwordVisible = !_passwordVisible;
                                },
                              );
                            },
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            form['password'] = value.toString();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          minimumSize: const Size.fromHeight(50),
                        ),
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
                                    return const MainPage();
                                  },
                                ),
                              );
                            } else {
                              setState(() {
                                _errorMessage =
                                    jsonDecode(response.body)['message'];
                              });
                            }
                          } catch (e) {
                            setState(() {
                              _errorMessage = e.toString();
                            });
                          }
                        },
                        child: const Text(
                          'Sign in',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: ((context) {
                                return RegisterPage(
                                  onRegisterSuccess: () {
                                    showAlert(
                                        "Your account was created successfully.");
                                  },
                                );
                              })),
                            );
                          },
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Visibility(
              key: ValueKey<bool>(_alertVisible),
              visible: _alertVisible,
              child: Padding(
                padding: const EdgeInsets.all(20),
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
      ),
    );
  }
}

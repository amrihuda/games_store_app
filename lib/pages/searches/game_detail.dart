import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:games_store_app/helpers/xml_http.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key, required this.gameId}) : super(key: key);

  final int gameId;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Map game = {};

  @override
  void initState() {
    super.initState();

    getGame(widget.gameId).then((result) {
      setState(() {
        game = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: game.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Text(game['name']),
                  Text(game['gameProfile']['developer']),
                  Text(game['price'].toString()),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () async {
                        try {
                          var response = await addCart(game['id']);
                          if (response.statusCode == 200) {
                            if (!mounted) return;
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text(
                                    "Game was added to cart successfully."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            if (!mounted) return;
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title:
                                    Text(jsonDecode(response.body)['message']),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text(e.toString()),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(),
    );
  }
}

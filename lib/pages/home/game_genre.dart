import 'package:flutter/material.dart';

class GameGenrePage extends StatefulWidget {
  const GameGenrePage({Key? key, required this.games}) : super(key: key);

  final List games;

  @override
  State<GameGenrePage> createState() => _GameGenrePageState();
}

class _GameGenrePageState extends State<GameGenrePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Games")),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: widget.games.isNotEmpty
            ? ListView.separated(
                itemCount: widget.games.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 50,
                    child: TextButton(
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.black),
                      onPressed: () {
                        // Navigator.pushNamed(context, "/profile");
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.games[index]['name']),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Container(),
      ),
    );
  }
}

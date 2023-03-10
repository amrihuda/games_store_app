import 'package:flutter/material.dart';
import 'package:games_store_app/pages/home/game_genre.dart';
import 'package:games_store_app/pages/home/genre.dart';
import 'package:intl/intl.dart';
import 'package:games_store_app/helpers/xml_http.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.onMoreGamesPressed,
    required this.onGamePressed,
    required this.genreId,
  }) : super(key: key);

  final VoidCallback onMoreGamesPressed;
  final Function(int) onGamePressed;
  final int genreId;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const TextStyle sectionStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
  var genres = [];
  var games = [];

  @override
  void initState() {
    super.initState();

    getGenres().then((result) {
      setState(() {
        genres = result;
      });
    });

    getGames().then((result) {
      setState(() {
        games = result;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.genreId != -1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameGenrePage(
              genreId: widget.genreId,
              onGamePressed: (gameId) {
                widget.onGamePressed(gameId);
              },
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GameStore")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "BROWSE BY GENRE",
                    style: sectionStyle,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GenrePage(
                              onGamePressed: (gameId) {
                                widget.onGamePressed(gameId);
                              },
                            ),
                          ),
                        );
                      },
                      child: const Text("More"))
                ],
              ),
            ),
            SizedBox(
              height: 100,
              child: genres.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: genres.length < 5 ? genres.length : 5,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GameGenrePage(
                                      genreId: genres[i]['id'],
                                      onGamePressed: (gameId) {
                                        widget.onGamePressed(gameId);
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                genres[i]['name'],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Container(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "ALL GAMES",
                    style: sectionStyle,
                  ),
                  TextButton(
                      onPressed: () => widget.onMoreGamesPressed(),
                      child: const Text("More"))
                ],
              ),
            ),
            games.isNotEmpty
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: games.length < 8 ? games.length : 8,
                    itemBuilder: (ctx, i) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: ElevatedButton(
                          onPressed: () {
                            widget.onGamePressed(games[i]['id']);
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: EdgeInsets.zero,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.zero)),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.network(
                                  "http://localhost:3000/uploads/${games[i]['image']}",
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, exception, stackTrace) {
                                    return Image.asset(
                                      'assets/images/game-default.jpg',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        games[i]['name'],
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        NumberFormat.currency(
                                          locale: "id_ID",
                                          symbol: "Rp ",
                                        ).format(games[i]['price']),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      mainAxisExtent: 200,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

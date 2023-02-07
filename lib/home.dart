import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'helpers/xml_http.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalStorage storage = LocalStorage('games_store_app');
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Games Store")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("BROWSE BY GENRE"),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/genres');
                    },
                    child: const Text("More"))
              ],
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: genres.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text(
                          genres[i]['name'],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("ALL GAMES"),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/games');
                    },
                    child: const Text("More"))
              ],
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: games.length,
              itemBuilder: (ctx, i) {
                return ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.network(
                          "http://localhost:3000/uploads/${games[i]['image'] ?? ''}",
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Image.asset(
                              'assets/images/game-default.jpg',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              games[i]['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  games[i]['price'].toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                crossAxisCount: 2,
                mainAxisExtent: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

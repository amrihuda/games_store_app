import 'package:flutter/material.dart';
import 'package:games_store_app/pages/searches/game_detail.dart';
import 'package:games_store_app/helpers/xml_http.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({
    Key? key,
    required this.onSelectedGenre,
  }) : super(key: key);

  final Function(int) onSelectedGenre;

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  List allGames = [];
  List games = [];

  TextEditingController searchController = TextEditingController();

  void searchGames(String key) {
    setState(() {
      games = allGames
          .where((e) =>
              e['name'].toString().toLowerCase().contains(key.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();

    getUserLibrary().then((result) {
      setState(() {
        allGames = result.map((e) => e['game']).toList();
        games = allGames;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: SizedBox(
            child: TextField(
              controller: searchController,
              maxLines: 1,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  filled: true,
                  fillColor: Colors.white70,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchGames('');
                      searchController.text = '';
                    },
                  ),
                  hintText: 'Search for games'),
              onChanged: (value) {
                searchGames(value);
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                "Your Library",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
            games.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: games.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: SizedBox(
                          height: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.zero)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GamePage(
                                        gameId: games[i]['id'],
                                        onUnselectGame: () {},
                                        onSelectedGenre: (genreId) {
                                          widget.onSelectedGenre(genreId);
                                        },
                                        onGotoCart: () {},
                                      ),
                                    ));
                              },
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 6),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Image.network(
                                              "http://localhost:3000/uploads/${games[i]['image']}",
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, exception,
                                                  stackTrace) {
                                                return Image.asset(
                                                  'assets/images/game-default.jpg',
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            ),
                                          ),
                                          Expanded(
                                            flex: 8,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  games[i]['name'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

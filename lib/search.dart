import 'package:flutter/material.dart';
import 'package:games_store_app/pages/searches/game_detail.dart';
import 'package:games_store_app/helpers/xml_http.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key? key,
    required this.gameId,
    required this.onGamePressed,
  }) : super(key: key);

  final int gameId;
  final Function(int) onGamePressed;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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

    getGames().then((result) {
      setState(() {
        allGames = result;
        games = allGames;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.gameId != -1) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GamePage(
                gameId: widget.gameId,
                onUnselectGame: () {
                  widget.onGamePressed(-1);
                },
              ),
            ));
      }
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
        child: games.isNotEmpty
            ? ListView.separated(
                itemCount: games.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 80,
                    child: TextButton(
                      style:
                          TextButton.styleFrom(foregroundColor: Colors.black),
                      onPressed: () {
                        widget.onGamePressed(games[index]['id']);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GamePage(
                                gameId: games[index]['id'],
                                onUnselectGame: () {
                                  widget.onGamePressed(-1);
                                },
                              ),
                            ));
                      },
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Image.network(
                              "http://localhost:3000/uploads/${games[index]['image']}",
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Image.asset(
                                  'assets/images/game-default.jpg',
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                          Expanded(
                            flex: 9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(games[index]['name']),
                              ],
                            ),
                          ),
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

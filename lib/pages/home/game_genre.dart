import 'package:flutter/material.dart';
import 'package:games_store_app/helpers/xml_http.dart';
import 'package:games_store_app/pages/searches/game_detail.dart';
import 'package:intl/intl.dart';

class GameGenrePage extends StatefulWidget {
  const GameGenrePage({
    Key? key,
    required this.genreId,
    required this.onGamePressed,
  }) : super(key: key);

  final int genreId;
  final Function(int) onGamePressed;

  @override
  State<GameGenrePage> createState() => _GameGenrePageState();
}

class _GameGenrePageState extends State<GameGenrePage> {
  static const TextStyle sectionStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w500);

  List allGames = [];
  List games = [];
  Map genre = {};

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

    getGenre(widget.genreId).then((result) {
      setState(() {
        genre = result;
      });
    });

    getGames().then((result) {
      setState(() {
        allGames = result
            .where(
                (e) => e['genres'].toString().contains("id: ${widget.genreId}"))
            .toList();
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
              genre.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        genre['name'],
                        style: sectionStyle,
                        textAlign: TextAlign.left,
                      ),
                    )
                  : Container(),
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
                                  widget.onGamePressed(games[i]['id']);
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => GamePage(
                                  //         gameId: games[i]['id'],
                                  //         onUnselectGame: () {
                                  //           widget.onGamePressed(-1);
                                  //         },
                                  //       ),
                                  //     ));
                                },
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 4,
                                              child: Image.network(
                                                "http://localhost:3000/uploads/${games[i]['image']}",
                                                fit: BoxFit.cover,
                                                errorBuilder: (context,
                                                    exception, stackTrace) {
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
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      games[i]['name'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          DateFormat('d MMM y').format(
                                            DateTime.parse(
                                              games[i]['gameProfile']
                                                  ['release_date'],
                                            ),
                                          ),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          NumberFormat.currency(
                                            locale: "id_ID",
                                            symbol: "Rp ",
                                          ).format(games[i]['price']),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
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
          )),
    );
  }
}

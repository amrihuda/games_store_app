import 'package:flutter/material.dart';
import 'package:games_store_app/helpers/xml_http.dart';

class GameGenrePage extends StatefulWidget {
  const GameGenrePage({Key? key, required this.genreId}) : super(key: key);

  final int genreId;

  @override
  State<GameGenrePage> createState() => _GameGenrePageState();
}

class _GameGenrePageState extends State<GameGenrePage> {
  static const TextStyle sectionStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w500);

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

    getGenres().then((result) {
      setState(() {
        genre = result.firstWhere((e) => e['id'] == widget.genreId);
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
                  ? ListView.separated(
                      shrinkWrap: true,
                      itemCount: games.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: 50,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.black),
                            onPressed: () {
                              // Navigator.pushNamed(context, "/profile");
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(games[index]['name']),
                              ],
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

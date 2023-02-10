import 'package:flutter/material.dart';
import 'package:games_store_app/pages/home/game_genre.dart';
import 'package:games_store_app/helpers/xml_http.dart';

class GenrePage extends StatefulWidget {
  const GenrePage({
    Key? key,
    required this.onGamePressed,
  }) : super(key: key);

  final Function(int) onGamePressed;

  @override
  State<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  List allGenres = [];
  List genres = [];

  TextEditingController searchController = TextEditingController();

  void searchGenres(String key) {
    setState(() {
      genres = allGenres
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
        allGenres = result;
        genres = allGenres;
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
                      searchGenres('');
                      searchController.text = '';
                    },
                  ),
                  hintText: 'Search for genres'),
              onChanged: (value) {
                searchGenres(value);
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: genres.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: genres.length,
                  separatorBuilder: (context, i) => const Divider(),
                  itemBuilder: (context, i) {
                    return SizedBox(
                      height: 40,
                      child: TextButton(
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.black),
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
                              ));
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            genres[i]['name'],
                            style: optionStyle,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            : Container(),
      ),
    );
  }
}

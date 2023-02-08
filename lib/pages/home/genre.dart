import 'package:flutter/material.dart';

class GenrePage extends StatefulWidget {
  const GenrePage({Key? key, required this.genres}) : super(key: key);

  final List genres;

  @override
  State<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  List genres = [];

  TextEditingController seacrhController = TextEditingController();

  void searchGenres(String key) {
    setState(() {
      genres = widget.genres
          .where((e) =>
              e['name'].toString().toLowerCase().contains(key.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      genres = widget.genres;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              child: TextField(
                controller: seacrhController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    filled: true,
                    fillColor: Colors.white70,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchGenres('');
                        seacrhController.text = '';
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: genres.isNotEmpty
            ? ListView.separated(
                itemCount: genres.length,
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
                          Text(genres[index]['name']),
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

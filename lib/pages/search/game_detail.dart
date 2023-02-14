import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:games_store_app/helpers/xml_http.dart';

class GamePage extends StatefulWidget {
  const GamePage({
    Key? key,
    required this.gameId,
    required this.onUnselectGame,
    required this.onSelectedGenre,
    required this.onAddedtoCart,
    required this.onGotoCart,
  }) : super(key: key);

  final int gameId;
  final VoidCallback onUnselectGame;
  final Function(int) onSelectedGenre;
  final Function(String) onAddedtoCart;
  final VoidCallback onGotoCart;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const TextStyle infoStyle = TextStyle(
    fontWeight: FontWeight.w500,
  );
  Map game = {};
  int inLibrary = 0;
  int inCart = 0;

  Future<bool> _unselectGame() async {
    widget.onUnselectGame();
    return true;
  }

  @override
  void initState() {
    super.initState();

    getGame(widget.gameId).then((result) {
      setState(() {
        game = result;
      });
      getUserLibrary().then((result) {
        if (result.where((e) => e['gameId'] == game['id']).isEmpty) {
          setState(() {
            inLibrary = 1;
          });
        } else {
          setState(() {
            inLibrary = 2;
          });
        }
      });
      getCart().then((result) {
        if (result.where((e) => e['gameId'] == game['id']).isEmpty) {
          setState(() {
            inCart = 1;
          });
        } else {
          setState(() {
            inCart = 2;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _unselectGame,
      child: Scaffold(
        appBar: AppBar(),
        body: game.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          "http://localhost:3000/uploads/${game['image']}",
                          fit: BoxFit.cover,
                          errorBuilder: (context, exception, stackTrace) {
                            return Image.asset(
                              'assets/images/game-default.jpg',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        game['name'],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              flex: 2,
                              child: Text("Developer", style: infoStyle),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(game['gameProfile']['developer'],
                                  style: infoStyle),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(
                              flex: 2,
                              child: Text("Publisher", style: infoStyle),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(game['gameProfile']['publisher'],
                                  style: infoStyle),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(
                              flex: 2,
                              child: Text("Released", style: infoStyle),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                  DateFormat('d MMMM y').format(
                                    DateTime.parse(
                                      game['gameProfile']['release_date'],
                                    ),
                                  ),
                                  style: infoStyle),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(game['gameProfile']['desc']),
                    ),
                    game['genres'].length != 0
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("GENRES",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: SizedBox(
                                    height: 40,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: game['genres'].length < 5
                                          ? game['genres'].length
                                          : 5,
                                      itemBuilder: (context, i) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: SizedBox(
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                shape: const StadiumBorder(),
                                                side: const BorderSide(
                                                    color: Colors.blue),
                                              ),
                                              onPressed: () {
                                                widget.onSelectedGenre(
                                                    game['genres'][i]['id']);
                                              },
                                              child: Text(
                                                game['genres'][i]['name'],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: inLibrary != 0
                          ? inLibrary == 1
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Buy ${game['name']}",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        )),
                                    Text(
                                        NumberFormat.currency(
                                          locale: "id_ID",
                                          symbol: "Rp ",
                                        ).format(game['price']),
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: inCart != 0
                                          ? inCart == 1
                                              ? ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        const StadiumBorder(),
                                                    minimumSize:
                                                        const Size.fromHeight(
                                                            50),
                                                  ),
                                                  onPressed: () async {
                                                    try {
                                                      var response =
                                                          await addCart(
                                                              game['id']);
                                                      if (response.statusCode ==
                                                          201) {
                                                        setState(() {
                                                          inCart = 2;
                                                        });
                                                        widget.onAddedtoCart(
                                                            "Game was added to cart successfully.");
                                                      } else {
                                                        widget.onAddedtoCart(
                                                            jsonDecode(response
                                                                    .body)[
                                                                'message']);
                                                      }
                                                    } catch (e) {
                                                      widget.onAddedtoCart(
                                                          e.toString());
                                                    }
                                                  },
                                                  child: const Text(
                                                    'Add to Cart',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                )
                                              : ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        const StadiumBorder(),
                                                    minimumSize:
                                                        const Size.fromHeight(
                                                            50),
                                                  ),
                                                  onPressed: () {
                                                    widget.onGotoCart();
                                                  },
                                                  child: const Text(
                                                    'Go to Cart',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                )
                                          : Container(),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "You already own this game",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: const StadiumBorder(),
                                          minimumSize:
                                              const Size.fromHeight(50),
                                        ),
                                        onPressed: () {},
                                        child: const Text(
                                          'Install',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                          : Container(),
                    ),
                  ],
                ),
              )
            : Container(),
      ),
    );
  }
}

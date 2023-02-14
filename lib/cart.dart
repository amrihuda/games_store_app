import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:games_store_app/helpers/xml_http.dart';
import 'dart:convert';
import 'package:games_store_app/pages/cart/payment.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key, required this.onClearCart}) : super(key: key);

  final Function(String) onClearCart;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool loading = true;
  List cart = [];
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();

    getCart().then((result) {
      setState(() {
        cart = result.map((e) => e['game']).toList();
      });
      for (Map game in cart) {
        setState(() {
          totalPrice += game['price'];
        });
      }
    }).then((_) {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Cart")),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: !loading
            ? cart.isNotEmpty
                ? Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () async {
                            try {
                              var response = await deleteAllCart();
                              if (response.statusCode == 200) {
                                setState(() {
                                  cart = [];
                                  totalPrice = 0;
                                });
                                widget.onClearCart(
                                    "All items was removed from cart successfully.");
                              } else {
                                widget.onClearCart(
                                    jsonDecode(response.body)['message']);
                              }
                            } catch (e) {
                              widget.onClearCart(e.toString());
                            }
                          },
                          child: const Text("Remove all items"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: cart.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: SizedBox(
                              height: 70,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.all(Radius.zero)),
                                  ),
                                  onPressed: () {},
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
                                                  "http://localhost:3000/uploads/${cart[i]['image']}",
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
                                                      const EdgeInsets.only(
                                                          left: 6),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          cart[i]['name'],
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: Text(
                                                          NumberFormat.currency(
                                                            locale: "id_ID",
                                                            symbol: "Rp ",
                                                          ).format(
                                                              cart[i]['price']),
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                locale: "id_ID",
                                symbol: "Rp ",
                              ).format(totalPrice),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              minimumSize: const Size.fromHeight(50),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentPage(
                                    onPaymentSuccess: () {
                                      setState(() {
                                        cart = [];
                                        totalPrice = 0;
                                      });
                                      widget.onClearCart("Payment Success!");
                                    },
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Go to Payments',
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
                  ])
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(50),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Icon(
                              Icons.shopping_cart,
                              color: Colors.blue.withOpacity(0.5),
                              size: 200,
                            ),
                          ),
                          const Text(
                            "Your cart is empty",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const Text(
                            "Looks like you haven't added any games to your cart yet.",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
            : Container(),
      ),
    );
  }
}

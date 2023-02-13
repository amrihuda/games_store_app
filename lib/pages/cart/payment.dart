import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:games_store_app/helpers/xml_http.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key, required this.onPaymentSuccess})
      : super(key: key);

  final VoidCallback onPaymentSuccess;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

enum SingingCharacter { paybro, gobayar, donepay, credit }

class _PaymentPageState extends State<PaymentPage> {
  SingingCharacter? _character = SingingCharacter.paybro;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

  Map form = {
    'payment': 'paybro',
    'status': 'settled',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      height: 60,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          foregroundColor: Colors.black,
                          textStyle: optionStyle,
                          side: const BorderSide(color: Colors.blue),
                        ),
                        onPressed: () {
                          setState(() {
                            _character = SingingCharacter.paybro;
                            form['payment'] = 'paybro';
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("PayBro"),
                            Radio<SingingCharacter>(
                              value: SingingCharacter.paybro,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value) {
                                setState(() {
                                  _character = value;
                                  form['payment'] = 'paybro';
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      height: 60,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          foregroundColor: Colors.black,
                          textStyle: optionStyle,
                          side: const BorderSide(color: Colors.blue),
                        ),
                        onPressed: () {
                          setState(() {
                            _character = SingingCharacter.gobayar;
                            form['payment'] = 'gobayar';
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("GoBayar"),
                            Radio<SingingCharacter>(
                              value: SingingCharacter.gobayar,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value) {
                                setState(() {
                                  _character = value;
                                  form['payment'] = 'gobayar';
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      height: 60,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          foregroundColor: Colors.black,
                          textStyle: optionStyle,
                          side: const BorderSide(color: Colors.blue),
                        ),
                        onPressed: () {
                          setState(() {
                            _character = SingingCharacter.donepay;
                            form['payment'] = 'donepay';
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Done Pay"),
                            Radio<SingingCharacter>(
                              value: SingingCharacter.donepay,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value) {
                                setState(() {
                                  _character = value;
                                  form['payment'] = 'donepay';
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      height: 60,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          foregroundColor: Colors.black,
                          textStyle: optionStyle,
                          side: const BorderSide(color: Colors.blue),
                        ),
                        onPressed: () {
                          setState(() {
                            _character = SingingCharacter.credit;
                            form['payment'] = 'credit';
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Credit Card"),
                            Radio<SingingCharacter>(
                              value: SingingCharacter.credit,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value) {
                                setState(() {
                                  _character = value;
                                  form['payment'] = 'credit';
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () async {
                  try {
                    var response = await addTransaction(form);
                    if (response.statusCode == 201) {
                      if (!mounted) return;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text("Payment Success!"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      ).then((value) {
                        widget.onPaymentSuccess();
                        Navigator.pop(context);
                      });
                    } else {
                      if (!mounted) return;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text(jsonDecode(response.body)['message']),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(e.toString()),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const PaymentPage(),
                  //   ),
                  // );
                },
                child: const Text(
                  'Buy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

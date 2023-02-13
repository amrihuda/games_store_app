import 'package:flutter/material.dart';
import 'package:games_store_app/helpers/xml_http.dart';
import 'package:intl/intl.dart';
import 'package:games_store_app/pages/menu/receipt.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List transactions = [];

  @override
  void initState() {
    super.initState();

    getTransactions().then((result) {
      setState(() {
        transactions = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transactions")),
      body: ListView.separated(
        padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
        itemCount: transactions.length,
        separatorBuilder: (context, i) => const Divider(),
        itemBuilder: (context, i) {
          return SizedBox(
            height: 70,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                side: const BorderSide(color: Colors.blue),
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReceiptPage(
                        order: transactions[i],
                      ),
                    ));
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat('d/M/y').format(DateTime.parse(
                          transactions[i]['createdAt'],
                        ))),
                        Text(
                            toBeginningOfSentenceCase(transactions[i]['status'])
                                .toString()),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: transactions[i]['orders'][0]['game']
                                          ['name']),
                                  transactions[i]['orders'].length > 1
                                      ? TextSpan(
                                          text:
                                              " and ${transactions[i]['orders'].length - 1} more",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold))
                                      : const TextSpan(),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              NumberFormat.currency(
                                locale: "id_ID",
                                symbol: "Rp ",
                              ).format(transactions[i]['total_price']),
                              style: const TextStyle(fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

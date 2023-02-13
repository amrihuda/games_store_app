import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({Key? key, required this.order}) : super(key: key);

  final Map order;

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              children: <TextSpan>[
                const TextSpan(
                    text: "Order ID: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: widget.order['id'].toString()),
              ],
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.only(top: 10, bottom: 8),
            shrinkWrap: true,
            itemCount: widget.order['orders'].length,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Text(
                            widget.order['orders'][i]['game']['name'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          NumberFormat.currency(
                            locale: "id_ID",
                            symbol: "Rp ",
                          ).format(widget.order['orders'][i]['price']),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Divider(),
          ),
          Row(
            children: [
              const Expanded(
                  flex: 8,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Total"),
                  )),
              Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    NumberFormat.currency(
                      locale: "id_ID",
                      symbol: "Rp ",
                    ).format(widget.order['total_price']),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

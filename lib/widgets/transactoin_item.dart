import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    this.transaction,
    this.deleteTx,
  }) : super(key: key);

  final Transactions transaction;
  final Function deleteTx;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bgColor;

  @override
  void initState() {
    const availableColors = [
      Colors.red,
      Colors.black,
      Colors.amber,
      Colors.purple,
    ];

    _bgColor = availableColors[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      elevation: 7,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: FittedBox(
              child: Text('\$${widget.transaction.amount.toStringAsFixed(2)}'),
            ),
          ),
        ),
        title: Text(
          widget.transaction.tittle,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            // ignore: deprecated_member_use
            ? FlatButton.icon(
                icon: Icon(Icons.delete_forever_sharp),
                textColor: Colors.amber[700],
                label: Text('Delete'),
                onPressed: () => widget.deleteTx(widget.transaction.id),
              )
            : IconButton(
                icon: Icon(Icons.delete_forever_sharp),
                // ignore: deprecated_member_use
                color: Theme.of(context).accentColor,
                onPressed: () => widget.deleteTx(widget.transaction.id),
              ),
      ),
    );
  }
}

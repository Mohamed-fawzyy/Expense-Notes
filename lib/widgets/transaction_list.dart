import 'package:flutter/material.dart';

import '../widgets/transactoin_item.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transactions> transactions;
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (context, constrains) {
            return Column(
              children: [
                Text(
                  'No transactoins added yet !',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  //padding: EdgeInsets.symmetric(vertical: 10),
                  height: constrains.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView(
            children: transactions
                .map((tx) => TransactionItem(
                      key: ValueKey(tx.id),
                      transaction: tx,
                      deleteTx: deleteTx,
                    ))
                .toList(),
            scrollDirection: Axis.vertical,
          );
  }
}

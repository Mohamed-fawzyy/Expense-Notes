import 'package:flutter/foundation.dart';

class Transactions {
  String id;
  final String tittle;
  final double amount;
  final DateTime date;

  Transactions({
    this.amount,
    this.date,
    this.id,
    this.tittle,
  });
}

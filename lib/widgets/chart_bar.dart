import 'package:flutter/material.dart';

class CharBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctTotal;

  CharBar(
    this.label,
    this.spendingAmount,
    this.spendingPctTotal,
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        return Column(
          children: [
            Container(
              height: constrains.maxHeight * 0.15,
              child: FittedBox(
                child: Text(
                  '\$${spendingAmount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: constrains.maxHeight * 0.05),
            Container(
              height: constrains.maxHeight * 0.6,
              width: 10,
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: spendingPctTotal,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: constrains.maxHeight * 0.05),
            Container(
              height: constrains.maxHeight * 0.15,
              child: FittedBox(
                child: Text(label),
              ),
            ),
          ],
        );
      },
    );
  }
}

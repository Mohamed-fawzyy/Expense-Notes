import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/adaptive_flat_button.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function newTx;

  NewTransaction(this.newTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _tittleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void submitedData() {
    final titleInput = _tittleController.text;
    final amountInput = double.parse(_amountController.text);

    if (titleInput.isEmpty || amountInput <= 0 || _selectedDate == null) {
      return;
    }

    // if (_amountController.text.isEmpty || _tittleController.text.isEmpty) {
    //   return;
    // }

    widget.newTx(
      titleInput,
      amountInput,
      _selectedDate,
    );

    // thats for avoiding close the tab by clicking on it
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            left: 20,
            top: 14,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 14,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Tittle'),
                controller: _tittleController,
                onSubmitted: (_) =>
                    submitedData(), //(_)ik it needs a para. but ingore it
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => submitedData(),
              ),

              Container(
                height: 70,
                padding: EdgeInsets.symmetric(horizontal: 3),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No Date Choosen !'
                            : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}',
                      ),
                    ),
                    AdaptiveFlatButton('Choose Date', _presentDatePicker),
                  ],
                ),
              ),

              // ignore: deprecated_member_use
              RaisedButton(
                onPressed: submitedData,
                child: Text(
                  'Add Transaction',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
              ),
            ],
          ),
        ),
        elevation: 10,
      ),
    );
  }
}

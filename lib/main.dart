import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/chart.dart';
import './widgets/new_transaction.dart';
import '../models/transaction.dart';
import 'widgets/transaction_list.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]); ## this for avoiding app rotation or disable rotation for this app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                // headline instead of tittle
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              button: TextStyle(color: Colors.white),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  // headline instead of tittle
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transactions> _userTransactions = [];
  bool _showChart = false;

  void _addNewTransaction(
    String txTittle,
    double txAmount,
    DateTime datePicked,
  ) {
    final newTx = Transactions(
      amount: txAmount,
      date: datePicked,
      id: DateTime.now().toString(),
      tittle: txTittle,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  List<Transactions> get _recentTransactions {
    return _userTransactions.where(
      (tx) {
        return tx.date.isAfter(DateTime.now().subtract(
          Duration(days: 7),
        ));
      },
    ).toList();
  }

  List<Widget> _buildLandscapeContent(
      Container txListWidget, Container chartLandScapeWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.headline6,
          ),
          Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          )
        ],
      ),
      _showChart ? chartLandScapeWidget : txListWidget
    ];
  }

  Widget _buildAppBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Personal Expnses',
              style: TextStyle(
                fontFamily: 'OpenSans',
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(
                    CupertinoIcons.add,
                    color: Theme.of(context).accentColor,
                  ),
                  onTap: () => _startAddNewTransaction(context),
                ),
              ],
            ),
          )
        : AppBar(
            title: Text(
              'Personal Expnses',
              style: TextStyle(
                fontFamily: 'OpenSans',
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => _startAddNewTransaction(context),
                icon: Icon(Icons.add_outlined),
              ),
            ],
          );
  }

  // ignore: unused_element
  Widget _buildPortriatContent(
      MediaQueryData mediaQuery, CupertinoNavigationBar appBar) {
    return Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.2,
      child: Chart(_recentTransactions),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandScape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = _buildAppBar();
    final chartLandScapeWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: Chart(_recentTransactions),
    );
    final chartPortriatWidget = Platform.isIOS
        ? Container(
            height: (mediaQuery.size.height -
                    appBar.preferredSize.height -
                    mediaQuery.padding.top) *
                0.2,
            child: Chart(_recentTransactions),
          )
        : Container(
            height: (mediaQuery.size.height -
                    appBar.preferredSize.height -
                    mediaQuery.padding.top) *
                0.3,
            child: Chart(_recentTransactions),
          );
    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top -
              50) *
          0.8,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandScape)
              ..._buildLandscapeContent(txListWidget, chartLandScapeWidget),
            if (!isLandScape) chartPortriatWidget,
            if (!isLandScape) txListWidget
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.addchart),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}

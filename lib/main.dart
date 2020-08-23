import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Compras'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _GroceryListHome createState() => _GroceryListHome();
}

class _GroceryListHome extends State<MyHomePage> {
  static final _moneyFormat =
      NumberFormat.currency(locale: "pt_BR", symbol: "R\$");

  var _items = [];
  var _total = 999.0;

  void _addItem() {
    setState(() {
      _items.add("Item ${_items.length + 1}");
    });
  }

  String _formattedTotal() {
    return _moneyFormat.format(_total);
  }

  Text _totalDisplay() {
    return Text(
      "${_formattedTotal()}",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 40, fontWeight: FontWeight.bold, color: Colors.green),
    );
  }

  ListView _groceryItemsListView() {
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        return Dismissible(
          key: Key(item),
          background: Container(color: Colors.green),
          onDismissed: (direction) {
            setState(() {
              _items.removeAt(index);
              _total += 1;
            });
          },
          child: ListTile(
            title: Text(item),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: screenSize.width,
            height: screenSize.height * 0.3,
            child: Center(child: _totalDisplay()),
          ),
          Container(
              width: screenSize.width,
              height: screenSize.height * 0.5,
              child: _groceryItemsListView()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Add item',
        child: Icon(Icons.add),
      ),
    );
  }
}

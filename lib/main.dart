import 'package:flutter/material.dart';
import 'package:groceries/grocery_event_store.dart';
import 'package:groceries/grocery_list_tile.dart';
import 'package:groceries/item_name_dialog.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compras',
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
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  final _groceries = GroceryEventStore();

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
            child: _groceriesListView(),
          ),
        ],
      ),
      floatingActionButton: _addItemButton(),
    );
  }

  GestureDetector _totalDisplay() => GestureDetector(
        onLongPress: () => setState(() {
          _groceries.clearPurchases();
        }),
        child: Text(
          '${_moneyFormat.format(_groceries.total())}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      );

  ListView _groceriesListView() => ListView.separated(
        itemCount: _groceries.length(),
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final item = _groceries.get(index);
          return GroceryListTileBuilder.build(
            context: context,
            item: item,
            onPurchase: (price) => setState(() {
              _groceries.purchase(item, price);
            }),
            onDismiss: () => setState(() {
              _groceries.cancel(item);
            }),
          );
        },
      );

  FloatingActionButton _addItemButton() => FloatingActionButton(
        onPressed: () => ItemNameDialog.show(
          context: context,
          onValidInput: (name) => setState(() {
            _groceries.add(name);
          }),
        ),
        tooltip: 'Add item',
        child: Icon(Icons.add),
      );
}

import 'package:flutter/material.dart';
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
      NumberFormat.currency(locale: "pt_BR", symbol: "R\$");

  var _activeItems = [];
  var _total = 0.0;

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
        onPressed: () => ItemNameDialog.show(
            context: context,
            onValidInput: (name) => setState(() {
                  _activeItems.add(name);
                })),
        tooltip: 'Add item',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView _groceryItemsListView() => ListView.separated(
        itemCount: _activeItems.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final item = _activeItems[index];
          return GroceryListTileBuilder.build(
              context: context,
              item: item,
              onPurchase: (price) => setState(() {
                    _total += price;
                  }),
              onDismiss: () => setState(() {
                    _activeItems.removeAt(index);
                  }));
        },
      );

  Text _totalDisplay() => Text(
        "${_moneyFormat.format(_total)}",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 40, fontWeight: FontWeight.bold, color: Colors.green),
      );
}

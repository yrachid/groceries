import 'package:flutter/material.dart';
import 'package:groceries/grocery_list_tile.dart';
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

  final _itemNameController = TextEditingController();

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
        onPressed: _addItem,
        tooltip: 'Add item',
        child: Icon(Icons.add),
      ),
    );
  }

  void _addItem() async {
    await showDialog(
        context: context,
        builder: (buildContext) {
          return AlertDialog(
            content: Row(children: <Widget>[
              (Expanded(
                child: TextField(
                  controller: _itemNameController,
                  keyboardType: TextInputType.name,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'Nome do item',
                  ),
                ),
              )),
            ]),
            actions: <Widget>[_okButton(context)],
          );
        });

    setState(() {
      var itemName = (_itemNameController.text ?? "").trim();
      if (itemName.isNotEmpty) {
        _activeItems.add(itemName);
        _itemNameController.clear();
      }
    });
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

  String _formattedTotal() => _moneyFormat.format(_total);

  Text _totalDisplay() => Text(
        "${_formattedTotal()}",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 40, fontWeight: FontWeight.bold, color: Colors.green),
      );

  FlatButton _okButton(BuildContext context) => FlatButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text("Ok"),
      );
}

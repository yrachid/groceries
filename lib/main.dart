import 'package:flutter/material.dart';
import 'package:groceries/price_dialog.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as dev;

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
              _itemNameTextField(),
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
          return Dismissible(
              key: Key(item),
              background: _buyGroceryDismissBackground(),
              secondaryBackground: _deleteGroceryDismissBackground(context),
              onDismissed: (direction) {
                setState(() {
                  _activeItems.removeAt(index);
                });
              },
              child: ListTile(
                title: Text(item),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  return true;
                }

                var priceDialog = PriceDialog();

                await showDialog(
                    context: context,
                    builder: priceDialog.buildDialog(context, item));

                var price = priceDialog.getPrice();

                if (price != null) {
                  setState(() {
                    _total += price;
                  });
                  return true;
                }

                dev.log('>>>>>>> Price is null');
                return false;
              });
        },
      );

  Container _deleteGroceryDismissBackground(context) => Container(
      color: Colors.red,
      child: Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width - 100,
              ),
              Icon(
                Icons.delete_sweep,
                color: Colors.white,
              ),
              Text(
                " Apagar",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          )));

  Expanded _expandedTextField(controller, label, textType) => Expanded(
        child: TextField(
          controller: controller,
          keyboardType: textType,
          autofocus: true,
          decoration: new InputDecoration(
            labelText: label,
          ),
        ),
      );

  Expanded _itemNameTextField() => _expandedTextField(
      _itemNameController, 'Nome do item', TextInputType.name);

  String _formattedTotal() => _moneyFormat.format(_total);

  Text _totalDisplay() => Text(
        "${_formattedTotal()}",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 40, fontWeight: FontWeight.bold, color: Colors.green),
      );

  Container _buyGroceryDismissBackground() => Container(
      color: Colors.green,
      child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.add_shopping_cart,
                color: Colors.white,
              ),
              Text(
                " Carrinho",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          )));

  FlatButton _okButton(BuildContext context) => FlatButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text("Ok"),
      );
}

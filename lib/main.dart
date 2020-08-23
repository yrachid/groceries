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

  static const _initialItemMultiplier = "1";
  final _priceInputController = TextEditingController();
  final _itemMultiplierController = TextEditingController(text: _initialItemMultiplier);
  final _itemNameController = TextEditingController();

  var _items = [];
  var _total = 0.0;

  void _addItem() async {
    await showDialog(
        context: context,
        builder: (buildContext) {
          return AlertDialog(
            content: Row(children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _itemNameController,
                  keyboardType: TextInputType.name,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'Nome do item',
                  ),
                ),
              ),
            ]),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("Ok"),
              )
            ],
          );
        });

    setState(() {
      _items.add(_itemNameController.text);
      _itemNameController.clear();
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
              });
            },
            child: ListTile(
              title: Text(item),
            ),
            confirmDismiss: (direction) async {
              var dialogResult = await showDialog(
                  context: context,
                  builder: (buildContext) {
                    return AlertDialog(
                      content: Row(children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _priceInputController,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: false, decimal: true),
                            autofocus: true,
                            decoration: new InputDecoration(
                              labelText: 'Valor: $item',
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _itemMultiplierController,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: false, decimal: false),
                            autofocus: true,
                            decoration: new InputDecoration(
                              labelText: 'Quantidade:',
                            ),
                          ),
                        ),
                      ]),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text("Ok"),
                        )
                      ],
                    );
                  });

              setState(() {
                _total += double.parse(_priceInputController.text) * int.parse(_itemMultiplierController.text);
                _priceInputController.clear();
                _itemMultiplierController.text = _initialItemMultiplier;
              });

              return dialogResult;
            });
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

import 'package:flutter/material.dart';
import 'package:groceries/grocery_event_store.dart';
import 'package:groceries/grocery_list_tile.dart';
import 'package:groceries/item_name_dialog.dart';
import 'package:groceries/purchase_list_tile.dart';
import 'package:groceries/storage.dart';
import 'package:intl/intl.dart';
import 'package:groceries/whatsapp_sharing.dart' as whatsapp;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de compras',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Lista de compras'),
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

  GroceryEventStore _groceries = GroceryEventStore();
  int _activeViewIndex = 0;

  @override
  void initState() {
    super.initState();
    Storage.restore().then((value) => setState(() {
          _groceries = value;
        }));
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    if (_groceries != null) {
      Storage.save(_groceries);
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    final List<Widget> views = <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: screenSize.width,
            height: screenSize.height * 0.3,
            child: Center(
              child: _totalDisplay(),
            ),
          ),
          Container(
            width: screenSize.width,
            height: screenSize.height * 0.5,
            child: _activeGroceriesListView(),
          ),
        ],
      ),
      Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Container(
          width: screenSize.width,
          height: screenSize.height * 0.3,
          child: Center(
            child: _totalDisplay(),
          ),
        ),
        Container(
          width: screenSize.width,
          height: screenSize.height * 0.5,
          child: _purchasesListView(),
        ),
      ])
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton(
              itemBuilder: (_) => <PopupMenuItem<String>>[
                    new PopupMenuItem<String>(
                      child: const Text('Whatsapp'),
                      value: 'Whatsapp',
                    )
                  ],
              onSelected: (item) => {
                    if (item == 'Whatsapp') {whatsapp.share(_groceries)}
                  }),
        ],
      ),
      body: views.elementAt(_activeViewIndex),
      floatingActionButton: _addItemButton(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _activeViewIndex,
        onTap: (index) => setState(() {
          _activeViewIndex = index;
        }),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Lista',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Compras',
          ),
        ],
      ),
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

  ListView _activeGroceriesListView() => ListView.separated(
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

  ListView _purchasesListView() => ListView.separated(
        itemCount: _groceries.purchasesLength(),
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final PurchasedGrocery purchase = _groceries.getPurchase(index);
          return PurchaseListTile.build(
            context: context,
            item: purchase,
            onItemRestored: () => setState(() {
              _groceries.restoreItem(purchase);
            }),
            onPurchaseDeleted: () => setState(() {
              _groceries.deletePurchase(purchase);
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

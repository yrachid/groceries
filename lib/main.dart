import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groceries/grocery_event_store.dart';
import 'package:groceries/grocery_list_tile.dart';
import 'package:groceries/purchase_list_tile.dart';
import 'package:groceries/storage.dart';
import 'package:intl/intl.dart';
import 'package:groceries/whatsapp_sharing.dart' as whatsapp;

void main() {
  runApp(MyApp());
}

const MaterialColor macondoOrange = MaterialColor(
  0xFFFF9E80,
  <int, Color>{
    50: Color(0xFFFBE9E7),
    100: Color(0xFFFFD0B0),
    200: Color(0xFFFFD0B0),
    300: Color(0xFFFFD0B0),
    400: Color(0xFFFF9E80),
    500: Color(0xFFFF9E80),
    600: Color(0xFFFF9E80),
    700: Color(0xFFFF9E80),
    800: Color(0xFFFF9E80),
    900: Color(0xFFFF9E80),
  },
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de compras',
      theme: ThemeData(
        primarySwatch: macondoOrange,
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

  var _itemController = TextEditingController();

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
            width: screenSize.width * 0.8,
            height: screenSize.height * 0.1,
            child: Center(
              child: TextField(
                onSubmitted: _addItem,
                keyboardType: TextInputType.name,
                controller: _itemController,
                decoration: new InputDecoration(
                  hintText: "Adicionar Item",
                ),
              ),
            ),
          ),
          Container(
            width: screenSize.width,
            height: screenSize.height * 0.2,
            child: Center(
              child: _totalDisplay(),
            ),
          ),
          Container(
            width: screenSize.width * 0.9,
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
            color: macondoOrange,
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

  void _addItem(String text) {
    if (_itemController.text.isNotEmpty) {
      _groceries.add(_capitalize(_itemController.text));
    }
    _itemController.clear();
  }

  static String _capitalize(String value) =>
      value.substring(0, 1).toUpperCase() + value.substring(1);
}

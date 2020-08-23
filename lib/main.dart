import 'package:flutter/material.dart';

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
      home: MyHomePage(title: 'Groceries'),
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
  var _count = 0;
  var _items = [];
  var _total = 999.0;

  void _addItem() {
    setState(() {
      _count++;
      _items.add("Item $_count");
    });
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
            color: Colors.black,
            child: Center(
                child: Text(
              "R\$$_total",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )),
          ),
          Container(
              width: screenSize.width,
              height: screenSize.height * 0.5,
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Dismissible(
                    key: Key(item),
                    background: Container(color: Colors.lightGreen),
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
              )),
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

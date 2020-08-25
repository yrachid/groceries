class GroceryEventStore {
  final List<String> _activeGroceries = [];
  final List<_PurchasedGrocery> _purchasedGroceries = [];

  add(String name) {
    _activeGroceries.add(name);
  }

  cancel(String name) {
    _activeGroceries.remove(name);
  }

  get(int index) {
    return _activeGroceries[index];
  }

  length() {
    return _activeGroceries.length;
  }

  clearPurchases() {
    _purchasedGroceries.clear();
  }

  purchase(String name, double price) {
    _activeGroceries.remove(name);
    _purchasedGroceries.add(
      _PurchasedGrocery(
        name: name,
        price: price,
      ),
    );
  }

  total() {
    return _purchasedGroceries
        .map((e) => e.price)
        .fold(0.0, (value, element) => value + element);
  }
}

class _PurchasedGrocery {
  final String name;
  final double price;

  _PurchasedGrocery({this.name, this.price});
}

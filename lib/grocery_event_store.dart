class GroceryEventStore {
  final List<String> _activeGroceries;
  final List<PurchasedGrocery> _purchasedGroceries;

  GroceryEventStore()
      : _activeGroceries = [],
        _purchasedGroceries = [];

  GroceryEventStore.fromJson(json)
      : _activeGroceries = _decodeActiveGroceries(json['active']),
        _purchasedGroceries = _decodePurchases(json['purchased']);

  static List<String> _decodeActiveGroceries(List<dynamic> groceries) =>
      groceries.map((e) => e as String).toList();

  static _decodePurchases(List<dynamic> purchases) => purchases
      .map((e) => e as Map<String, dynamic>)
      .map((e) => PurchasedGrocery(
            name: e['name'] as String,
            price: e['price'] as double,
          ))
      .toList();

  add(String name) {
    _activeGroceries.add(name);
  }

  cancel(String name) {
    _activeGroceries.remove(name);
  }

  get(int index) {
    return _activeGroceries.elementAt(index);
  }

  length() {
    return _activeGroceries.length;
  }

  purchasesLength() {
    return _purchasedGroceries.length;
  }

  getPurchase(int index) {
    return _purchasedGroceries.elementAt(index);
  }

  clearPurchases() {
    _purchasedGroceries.clear();
  }

  restoreItem(PurchasedGrocery purchase) {
    _purchasedGroceries.remove(purchase);
    _activeGroceries.add(purchase.name);
  }

  deletePurchase(purchase) {
    _purchasedGroceries.remove(purchase);
  }

  purchase(String name, double price) {
    _activeGroceries.remove(name);
    _purchasedGroceries.add(
      PurchasedGrocery(
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

  Map<String, dynamic> toJson() => {
        'active': _activeGroceries,
        'purchased': _purchasedGroceries
            .map((g) => {
                  'name': g.name,
                  'price': g.price,
                })
            .toList(),
      };
}

class PurchasedGrocery {
  final String name;
  final double price;

  PurchasedGrocery({this.name, this.price});
}

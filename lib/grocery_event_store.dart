class GroceryEventStore {
  final List<String> _activeGroceries = [];
  final List<PurchasedGrocery> _purchasedGroceries = [];

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
}

class PurchasedGrocery {
  final String name;
  final double price;

  PurchasedGrocery({this.name, this.price});
}

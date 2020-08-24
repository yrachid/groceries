import 'package:flutter/material.dart';
import 'package:groceries/price_dialog.dart';

class GroceryListTileBuilder {
  static Dismissible build(
      {@required BuildContext context,
      @required String item,
      @required onPurchase,
      @required onDismiss}) {
    return Dismissible(
        key: Key(item),
        background: _purchaseBackground(),
        secondaryBackground: _deletionBackground(context),
        onDismissed: (direction) {
          onDismiss();
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
            onPurchase(price);
            return true;
          }

          return false;
        });
  }

  static Container _purchaseBackground() => Container(
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

  static Container _deletionBackground(context) => Container(
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
}

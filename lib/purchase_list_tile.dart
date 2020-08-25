import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:groceries/grocery_event_store.dart';

class PurchaseListTile {
  static final _moneyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  static Dismissible build({
    @required BuildContext context,
    @required PurchasedGrocery item,
    @required onItemRestored,
    @required onPurchaseDeleted,
  }) {
    return Dismissible(
      key: Key(item.name),
      background: _restoreItemBackground(),
      secondaryBackground: _deletionBackground(context),
      onDismissed: (direction) {
        direction == DismissDirection.startToEnd
            ? onItemRestored()
            : onPurchaseDeleted();
      },
      child: ListTile(
        title: Text(item.name),
        subtitle: Text(_moneyFormat.format(item.price)),
      ),
    );
  }

  static Container _restoreItemBackground() => Container(
      color: Colors.green,
      child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.restore,
                color: Colors.white,
              ),
              Text(
                'Restarurar',
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              )
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
                'Apagar ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      );
}

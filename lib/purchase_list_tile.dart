import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:groceries/grocery_event_store.dart';

class PurchaseListTile {
  static final _moneyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  static Dismissible build(
      {@required BuildContext context,
      @required PurchasedGrocery item,
      @required onDismiss}) {
    return Dismissible(
      key: Key(item.name),
      background: _deletionBackground(context),
      secondaryBackground: _deletionBackground(context),
      onDismissed: (direction) {
        onDismiss();
      },
      child: ListTile(
        title: Text(item.name),
        subtitle: Text(_moneyFormat.format(item.price)),
      ),
    );
  }

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

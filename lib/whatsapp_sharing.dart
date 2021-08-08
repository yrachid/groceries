import 'dart:developer' as dev;

import 'package:groceries/grocery_event_store.dart';
import 'package:intl/intl.dart' as intl;
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

share(GroceryEventStore groceries) async {
  final Uri uri = Uri(
      scheme: 'whatsapp',
      host: 'send',
      queryParameters: {'text': _format(groceries)});

  dev.log('Whatsapp URI: ${uri.toString()}');

  if (await urlLauncher.canLaunch(uri.toString())) {
    await urlLauncher.launch(uri.toString());
  } else {
    dev.log('Could not launch URL: ${uri.toString()}');
  }
}

String _format(GroceryEventStore groceries) => [
      "*Lista de compras* - ${_todayAsString()}",
      _formatPendingItems(groceries),
      _formatPurchasedItems(groceries)
    ].join("\n");

String _formatPendingItems(GroceryEventStore groceries) {
  return groceries.pendingItems().isEmpty
      ? ""
      : """

*Pendentes:*

${groceries.pendingItems().map(_formatPending).join("\n")}
    """;
}

String _formatPurchasedItems(GroceryEventStore groceries) {
  return (groceries.purchasedItems().isEmpty)
      ? ""
      : """

*Comprados:*

${groceries.purchasedItems().map(_formatPurchase).join("\n")}

*Total:* ${_formatPrice(groceries.total())}
      """;
}

_todayAsString() => new intl.DateFormat("dd/MM/yyyy").format(DateTime.now());

_formatPending(p) => "[ ] - $p";

_formatPurchase(p) => "[X] - ${p.name} (${_formatPrice(p.price)})";

_formatPrice(double price) =>
    intl.NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(price);

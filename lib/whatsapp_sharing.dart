import 'package:groceries/grocery_event_store.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'dart:developer' as dev;
import 'package:intl/intl.dart' as intl;

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
      "*Lista de compras* - ${_todayAsString()}\n",
      "*Pendentes:*",
      groceries.pendingItems().map((i) => "[  ] - $i").join("\n") + "\n",
      "*Comprados:*",
      groceries
          .purchasedItems()
          .map((i) => "[X] - ${i.name} (${_formatPrice(i.price)})")
          .join("\n") + "\n",
      _formatTotal(groceries.total())
    ].join("\n");

_todayAsString() => new intl.DateFormat("dd/MM/yyyy").format(DateTime.now());

_formatTotal(double total) => total > 0 ? "Total: ${_formatPrice(total)}" : "";

_formatPrice(double price) =>
    intl.NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(price);

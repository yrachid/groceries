import 'package:flutter/material.dart';

class PriceDialog {
  static const _initialItemMultiplier = "1";
  final _priceInputController = TextEditingController();
  final _itemMultiplierController =
      TextEditingController(text: _initialItemMultiplier);

  buildDialog(context, title) => (buildContext) {
        return AlertDialog(
          title: Text(title),
          content: Row(children: <Widget>[
            Expanded(
              child: TextField(
                controller: _priceInputController,
                keyboardType: TextInputType.numberWithOptions(
                    signed: false, decimal: true),
                autofocus: true,
                decoration: new InputDecoration(
                  labelText: 'Preço',
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: _itemMultiplierController,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: new InputDecoration(
                  labelText: 'Quantidade:',
                ),
              ),
            ),
          ]),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Ok"),
            )
          ],
        );
      };

  _trimmedText(TextEditingController controller) =>
      (controller.text ?? "").trim();

  getPrice() {
    var priceAsString = _trimmedText(_priceInputController);
    var multiplierAsString = _trimmedText(_itemMultiplierController);

    _priceInputController.clear();
    _itemMultiplierController.text = _initialItemMultiplier;

    return (priceAsString.isEmpty || multiplierAsString.isEmpty)
        ? null
        : double.parse(priceAsString) * double.parse(multiplierAsString);
  }
}

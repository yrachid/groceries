import 'package:flutter/material.dart';

class PriceDialog {
  static const _initialItemMultiplier = "1";

  static show({@required context, @required title}) async {
    final priceController = TextEditingController();
    final multiplierController = TextEditingController(
      text: _initialItemMultiplier,
    );

    await showDialog(
      context: context,
      builder: _build(
        context: context,
        title: title,
        priceController: priceController,
        multiplierController: multiplierController,
      ),
    );

    return _getPrice(priceController, multiplierController);
  }

  static _build({context, title, priceController, multiplierController}) =>
      (buildContext) {
        return AlertDialog(
          title: Text(title),
          content: Row(children: <Widget>[
            Expanded(
              child: TextField(
                controller: priceController,
                keyboardType: TextInputType.numberWithOptions(
                  signed: false,
                  decimal: true,
                ),
                autofocus: true,
                decoration: new InputDecoration(
                  labelText: 'Preço',
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: multiplierController,
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

  static _trimmedText(TextEditingController controller) =>
      (controller.text ?? "").trim();

  static _getPrice(priceController, multiplierController) {
    var priceAsString = _trimmedText(priceController);
    var multiplierAsString = _trimmedText(multiplierController);

    return (priceAsString.isEmpty || multiplierAsString.isEmpty)
        ? null
        : double.parse(priceAsString) * double.parse(multiplierAsString);
  }
}

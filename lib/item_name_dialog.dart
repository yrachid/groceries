import 'package:flutter/material.dart';

class ItemNameDialog {
  static show({@required context, @required onValidInput}) async {
    final nameController = TextEditingController();
    await showDialog(
        context: context,
        builder: (buildContext) {
          return AlertDialog(
            content: Row(children: <Widget>[
              Expanded(
                child: TextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  autofocus: true,
                  decoration: new InputDecoration(
                    labelText: 'Nome do item',
                  ),
                ),
              ),
            ]),
            actions: <Widget>[
              _okButton(context),
            ],
          );
        });

    var itemName = (nameController.text ?? '').trim();
    if (itemName.isNotEmpty) {
      onValidInput(_capitalize(itemName));
    }
  }

  static String _capitalize(String value) =>
      value.substring(0, 1).toUpperCase() + value.substring(1);

  static FlatButton _okButton(BuildContext context) => FlatButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: Text('Ok'),
      );
}

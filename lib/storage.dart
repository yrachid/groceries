import 'package:groceries/grocery_event_store.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:developer' as dev;

class Storage {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/groceries.json');
  }

  static save(GroceryEventStore store) async {
    final file = await _localFile;

    final storeAsJson = jsonEncode(store.toJson());

    dev.log('Saving state as json: $storeAsJson');

    return file.writeAsString(storeAsJson);
  }

  static Future<GroceryEventStore> restore() async {
    final file = await _localFile;

    dev.log('Restoring state as json from: $file');

    final fileExists = await file.exists();

    if (!fileExists) {
      dev.log('State file does not exist, creating new store');
      return Future.value(GroceryEventStore());
    }

    final fileContent = await file.readAsString();
    dev.log('State file retrieved: $fileContent');

    return GroceryEventStore.fromJson(jsonDecode(fileContent));
  }
}

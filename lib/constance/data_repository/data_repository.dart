import 'dart:async';
import 'package:hive/hive.dart';

class DataRepository {
  StreamController<List<String>> dataStreamController = StreamController<List<String>>();
  Box dataBox = Hive.box('notifyData');

  // Initialize and listen for data changes
  DataRepository() {
    print('data length>1> ${dataBox.length}');
    dataBox.watch().listen((event) {
    print('data length>2> ${dataBox.length}');
      dataStreamController.add(dataBox.values.cast<String>().toList());
    });
  }
}
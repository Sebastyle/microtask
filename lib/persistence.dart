import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'model.dart';

class FilePersistence {
  static Future<File> _getFileLocation() async {
    var docDir = await getApplicationDocumentsDirectory();
    return File('${docDir.path}/microtask/tasks.json');
  }

  static void storeTasks(List<TaskEntry> tasks) async {
    var file = await _getFileLocation();
    await file.create(recursive: true);
    await file.writeAsString(jsonEncode(tasks), flush: true);
  }

  static Future<List<TaskEntry>> loadTasks() async {
    var file = await _getFileLocation();
    if (!file.existsSync()) return <TaskEntry>[];
    Iterable jsonList = jsonDecode(await file.readAsString());
    return List<TaskEntry>.from(
        jsonList.map((task) => TaskEntry.fromJson(task)));
  }
}

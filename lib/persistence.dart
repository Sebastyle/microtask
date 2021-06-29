import 'dart:convert';
import 'package:universal_html/html.dart' as web;
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:path_provider/path_provider.dart';

import 'model.dart';



class SimplePersistenceProvider implements SimplePersistence {
  late SimplePersistence instance;
  SimplePersistenceProvider() {
    if(kIsWeb) instance = LocalStoragePersistence();
    else instance = FilePersistence();
  }
  @override
  Future<List<TaskEntry>> loadTasks() {
    return instance.loadTasks();
  }

  @override
  void storeTasks(List<TaskEntry> tasks) {
    instance.storeTasks(tasks);
  }
}

class FilePersistence implements SimplePersistence {
  Future<File> _getFileLocation() async {
    var docDir = await getApplicationDocumentsDirectory();
    return File('${docDir.path}/microtask/tasks.json');
  }

  @override
  void storeTasks(List<TaskEntry> tasks) async {
    var file = await _getFileLocation();
    await file.create(recursive: true);
    await file.writeAsString(jsonEncode(tasks), flush: true);
  }

  @override
  Future<List<TaskEntry>> loadTasks() async {
    var file = await _getFileLocation();
    if (!file.existsSync()) return <TaskEntry>[];
    Iterable jsonList = jsonDecode(await file.readAsString());
    return List<TaskEntry>.from(
        jsonList.map((task) => TaskEntry.fromJson(task)));
  }
}

// TODO currently not working in debug, due to different localhost ports
class LocalStoragePersistence implements SimplePersistence {
  final storageKey = 'microtasks_tasks';

  @override
  Future<List<TaskEntry>> loadTasks() async {
    if (!web.window.localStorage.containsKey(storageKey)) return <TaskEntry>[];
    Iterable jsonList = jsonDecode(web.window.localStorage[storageKey] ?? '[]');
    return List<TaskEntry>.from(
        jsonList.map((task) => TaskEntry.fromJson(task)));
  }

  @override
  void storeTasks(List<TaskEntry> tasks) {
    web.window.localStorage[storageKey] = jsonEncode(tasks);
  }
}

abstract class SimplePersistence {
  void storeTasks(List<TaskEntry> tasks);
  Future<List<TaskEntry>> loadTasks();
}

import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:microtask/model.dart';

class TaskStore extends ChangeNotifier {
  final List<TaskEntry> _allTasks = [];
  UnmodifiableListView<TaskEntry> get allTasks => UnmodifiableListView(_allTasks);


}
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:microtask/model.dart';

///
/// Currently not in use - could be used to omit callbacks
///
class TaskStore extends ChangeNotifier {
  final List<TaskEntry> _allTasks = [];
  UnmodifiableListView<TaskEntry> get allTasks =>
      UnmodifiableListView(_allTasks);
}

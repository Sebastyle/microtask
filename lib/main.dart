import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:microtask/TaskEditWidget.dart';
import 'package:microtask/TaskViewWidget.dart';
import 'package:microtask/persistence.dart';

import 'model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Microtasks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: MyHomePage(title: 'Microtasks'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int editIndex = -1;
  var children = <TaskEntry>[];
  var editTask = TaskEntry();
  bool isLoading = true;

  @override
  void initState() {
    FilePersistence.loadTasks()
        .then((tasks) => setState(() => this.children = tasks))
        .whenComplete(() => setState(() => this.isLoading = false));
    super.initState();
  }

  _onSave(TaskEntry entry) {
    if (this.isLoading) return;
    this.setState(() {
      entry.isPreview = false;
      entry.isEdit = false;
      editIndex = -1;
      FilePersistence.storeTasks(children);
    });
  }

  _onNotifyChange(TaskEntry entry) {
    if (this.isLoading) return;
    this.setState(() {
      if (entry.isEdit) editIndex = children.indexOf(entry);
    });
  }

  _createNewTask() {
    if (this.isLoading) return;
    setState(() {
      if (children.length == 0 || children[0].title.isNotEmpty) {
        var entry = TaskEntry();
        children.insert(0, entry);
      }
      children[0].isPreview = true;
      editIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    var listView = ListView.separated(
      itemCount: children.length,
      itemBuilder: (context, index) => index == editIndex
          ? Column(children: [
              TaskEditWidget(
                taskEntry: children[index],
                onSaveCb: _onSave,
                notifyChangeCb: _onNotifyChange,
              ),
              TaskViewWidget(
                  taskEntry: children[index], notifyChangeCb: _onNotifyChange)
            ])
          : TaskViewWidget(
              taskEntry: children[index], notifyChangeCb: _onNotifyChange),
      separatorBuilder: (context, index) => Divider(height: 1),
    );
    var loadingIndicator = Center(
      child: Transform.scale(
        scale: 4,
        child: CircularProgressIndicator(
          strokeWidth: 1,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Tooltip(
            message: "Create a new Task",
            child: IconButton(onPressed: _createNewTask, icon: Icon(Icons.add)),
          )
        ],
      ),
      body: Padding(
          padding: EdgeInsets.only(top: 4),
          child: isLoading ? loadingIndicator : listView),
    );
  }
}

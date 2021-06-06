import 'package:flutter/material.dart';
import 'package:microtask/TaskEditWidget.dart';
import 'package:microtask/TaskViewWidget.dart';

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

  _onSave(TaskEntry entry) {
    this.setState(() {
      entry.isPreview = false;
      entry.isEdit = false;
      editIndex = -1;
      //TODO just save stuff
    });
  }

  _onNotifyChange(TaskEntry entry) {
    this.setState(() {
      if(entry.isEdit) editIndex = children.indexOf(entry);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  var entry = TaskEntry();
                  entry.isPreview = true;
                  children.insert(0, entry);
                  editIndex = 0;
                });
              },
              icon: Icon(Icons.add))
        ],
      ),

      body: Padding(
        padding: EdgeInsets.only(top: 4),
        child: ListView.separated(
          itemCount: children.length,
          itemBuilder: (context, index) => index == editIndex
              ? Column(children: [ TaskEditWidget(
                  taskEntry: children[index],
                  onSaveCb: _onSave,
                  notifyChangeCb: _onNotifyChange,
                ),TaskViewWidget(taskEntry: children[index], notifyChangeCb: _onNotifyChange)])
              : TaskViewWidget(taskEntry: children[index], notifyChangeCb: _onNotifyChange),
          separatorBuilder: (context, index) => Divider(height: 1),
        ),
      ),
    );
  }
}

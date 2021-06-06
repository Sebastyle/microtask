import 'package:flutter/material.dart';

import 'model.dart';

class TaskEditWidget extends StatefulWidget {
  TaskEditWidget({Key? key, required this.taskEntry, required this.onSaveCb, required this.notifyChangeCb})
      : super(key: key);

  final TaskEntry taskEntry;
  final Function(TaskEntry) onSaveCb;
  
  final Function(TaskEntry) notifyChangeCb;

  @override
  TaskEditState createState() => TaskEditState();
}

class TaskEditState extends State<TaskEditWidget> {
  TextEditingController ctrl = TextEditingController();

  void _inputChanged(String value) {
    setState(() {
      widget.taskEntry.fromInput(ctrl.text);
      widget.notifyChangeCb(widget.taskEntry);
    });
  }

  @override
  void initState() {
    ctrl.text = widget.taskEntry.toInput();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var output = 
      Row(
        children: [
          Flexible(
              child: TextFormField(
            minLines: 2,
            maxLines: 6,
            onChanged: _inputChanged,
            controller: ctrl,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(2),
                hintText: "Task Title 20m\nFurther Task description",
                hintStyle: TextStyle(color: Colors.grey)),
          )),
          IconButton(
              onPressed: ctrl.text.isNotEmpty
                  ? () {
                      widget.onSaveCb(widget.taskEntry.fromInput(ctrl.text));
                      ctrl.text = '';
                    }
                  : null,
              icon: const Icon(Icons.add_task)),
        ],
      );


    return output;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model.dart';

class TaskEditWidget extends StatefulWidget {
  TaskEditWidget(
      {Key? key,
      required this.taskEntry,
      required this.onSaveCb,
      required this.notifyChangeCb,
      required this.focusNode})
      : super(key: key);
  final FocusNode focusNode;
  final TaskEntry taskEntry;
  final Function(TaskEntry) onSaveCb;

  final Function(TaskEntry) notifyChangeCb;

  @override
  TaskEditState createState() => TaskEditState();
}

class SaveIntent extends Intent {}

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
    return Row(
      children: [
        Flexible(
          child: FocusableActionDetector(
            shortcuts: {
              LogicalKeySet(
                LogicalKeyboardKey.control, // .meta for macOS?
                LogicalKeyboardKey.keyS,
              ): SaveIntent()
            },
            actions: {
              SaveIntent: CallbackAction(
                  onInvoke: (i) => widget.onSaveCb(widget.taskEntry)),
            },
            child: TextFormField(
              focusNode: widget.focusNode,
              minLines: 2,
              maxLines: 6,
              onChanged: _inputChanged,
              controller: ctrl,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(2),
                  hintText: "Task Title 20m\nFurther Task description",
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
          ),
        ),
        Tooltip(
          message: "Save Task [Ctrl + S]",
          child: IconButton(
              onPressed: ctrl.text.isNotEmpty
                  ? () {
                      widget.onSaveCb(widget.taskEntry.fromInput(ctrl.text));
                      ctrl.text = '';
                    }
                  : null,
              icon: const Icon(Icons.add_task)),
        ),
      ],
    );
  }
}

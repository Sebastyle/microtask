import 'package:flutter/material.dart';

import 'model.dart';

class TaskViewWidget extends StatefulWidget {
  TaskViewWidget({Key? key, required this.taskEntry, required this.notifyChangeCb }) : super(key: key);

  final TaskEntry taskEntry;
  final Function(TaskEntry) notifyChangeCb;

  @override
  TaskViewState createState() => TaskViewState();
}

class TaskViewState extends State<TaskViewWidget> {
  bool isExpanded = false;


  void _toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void _toggleActive() {
    widget.taskEntry.isActive = !widget.taskEntry.isActive;
    widget.notifyChangeCb(widget.taskEntry);
  }

    void _toggleEdit() {
    widget.taskEntry.isEdit = !widget.taskEntry.isEdit;
    widget.notifyChangeCb(widget.taskEntry);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        color: widget.taskEntry.isPreview?Colors.grey[300]:widget.taskEntry.isActive?Colors.green[50]:null,
        child: Row(
          
          children: [
            MouseRegion(cursor: widget.taskEntry.description.isNotEmpty? SystemMouseCursors.click:SystemMouseCursors.basic,
            child: 
            GestureDetector(
              child: Row(mainAxisSize: MainAxisSize.max,children: [
                Icon(isExpanded ? Icons.expand_less : Icons.expand_more, color: widget.taskEntry.description.isEmpty?Colors.grey:Colors.black,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(widget.taskEntry.title, style: TextStyle(fontWeight: FontWeight.bold),),
                  isExpanded ? Text(widget.taskEntry.description, style: TextStyle(color: Colors.green[900]),):Placeholder(fallbackHeight: 0,fallbackWidth: 0,)
                ],)
                
              ]),
              onTap: widget.taskEntry.description.isNotEmpty?_toggleExpansion:null,
            )),
            Row(
              children: [
                Chip(
                    label: Text(widget.taskEntry.estimateMin == 0 ? '?' : widget.taskEntry.estimateMin.toString() + 'm')),
                IconButton(
                  
                  icon: const Icon(Icons.mode_edit_outlined),
                  onPressed: widget.taskEntry.isPreview ? null : _toggleEdit,
                  splashRadius: 22,
                ),
                IconButton(
                  icon: Icon(
                      widget.taskEntry.isActive ? Icons.pause : Icons.play_arrow_outlined),
                  onPressed: widget.taskEntry.isPreview ? null : _toggleActive,
                  splashRadius: 22,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ));
  }
}

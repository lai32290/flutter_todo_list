import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {

  TextEditingController _taskController = TextEditingController();
  List _tasks = [];

  @override
  initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    String data = '';
    try {
      final file = await _getFile();
      data = await file.readAsString();
    } catch(e) {
      print('failed load data');
      print(e);
      return;
    }

    setState(() {
      _tasks = json.decode(data);
    });
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }

  _saveFile() async {
    var file = await _getFile();
    String data = json.encode(_tasks);
    file.writeAsString(data);
  }

  Map<String, dynamic> _createTask(String taskName) {
    Map<String, dynamic> task = Map();
    task['title'] = taskName;
    task['done'] = false;
    return task;
  }

  _addNewItem() {
    setState(() {
      var newItem = _createTask(_taskController.text);
      _tasks.add(newItem);
    });
    _saveFile();
  }

  onClickAddItem(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add new task'),
          content: TextField(
            decoration: InputDecoration(
              labelText: 'Type your task here',
            ),
            controller: _taskController
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
                _taskController.text = '';
              }
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                _addNewItem();
                Navigator.pop(context);
                _taskController.text = '';
              }
            ),
          ]
        );
      }
    );
  }

  _handleCheckChange(bool isChecked, int index) {
    setState(() {
      _tasks[index]['done'] = isChecked;
    });
    _saveFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List'),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: _tasks.length,
          itemBuilder: (context, index) => CheckboxListTile(
            title: Text(_tasks[index]['title']),
            value: _tasks[index]['done'],
            onChanged: (isChecked) => _handleCheckChange(isChecked, index)
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
        onPressed: () => onClickAddItem(context),
      ),
    );
  }
}

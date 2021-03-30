import 'package:flutter/material.dart';
import 'package:todo_list/pages/todo_list_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      debugShowCheckedModeBanner: false,
      home: TodoListPage()
    );
  }
}

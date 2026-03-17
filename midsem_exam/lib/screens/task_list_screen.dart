import 'package:flutter/material.dart';
import '../models/task.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [
    Task(
      title: "Assignment 1",
      courseCode: "COSC 364",
      dueDate: DateTime.now(),
    ),
    Task(
      title: "Project Work",
      courseCode: "COSC 300",
      dueDate: DateTime.now(),
    ),
    Task(
      title: "Quiz",
      courseCode: "STAT 282",
      dueDate: DateTime.now(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  // ✅ Add Task
  void _addTask(String title, String course) {
    setState(() {
      tasks.add(Task(
        title: title,
        courseCode: course,
        dueDate: DateTime.now(),
      ));
    });
    saveTasks();
  }

  // ✅ Convert Task → JSON
  Map<String, dynamic> taskToJson(Task task) {
    return {
      'title': task.title,
      'courseCode': task.courseCode,
      'dueDate': task.dueDate.toIso8601String(),
      'isComplete': task.isComplete,
    };
  }

  // ✅ Convert JSON → Task
  Task taskFromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      courseCode: json['courseCode'],
      dueDate: DateTime.parse(json['dueDate']),
      isComplete: json['isComplete'],
    );
  }

  // ✅ Save tasks
  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> taskList =
        tasks.map((task) => jsonEncode(taskToJson(task))).toList();

    await prefs.setStringList('tasks', taskList);
  }

  // ✅ Load tasks
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? taskList = prefs.getStringList('tasks');

    if (taskList != null) {
      setState(() {
        tasks = taskList
            .map((task) => taskFromJson(jsonDecode(task)))
            .toList();
      });
    }
  }

  // ✅ Dialog
  void _showDialog() {
    String title = "";
    String course = "";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("New Task"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) => title = value,
              decoration: InputDecoration(labelText: "Title"),
            ),
            TextField(
              onChanged: (value) => course = value,
              decoration: InputDecoration(labelText: "Course Code"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _addTask(title, course);
              Navigator.pop(context);
            },
            child: Text("Save"),
          )
        ],
      ),
    );
  }

  // ✅ UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks"),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (_, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.title),
            subtitle: Text(
              "${task.courseCode} - ${DateFormat('dd/MM/yyyy').format(task.dueDate)}",
            ),
            trailing: Checkbox(
              value: task.isComplete,
              onChanged: (value) {
                setState(() {
                  task.isComplete = value!;
                });
                saveTasks(); // ✅ FIXED
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/task.dart';

class SplashBloc {
  final _splashController = StreamController<List<TaskModel>>();

  Stream<List<TaskModel>> get splashStream => _splashController.stream;

  void fetchTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<TaskModel> tasks = (prefs.getStringList('tasks') ?? [])
        .map((e) => TaskModel.fromJson(jsonDecode(e)))
        .toList();

    _splashController.sink.add(tasks);
  }

  void dispose() {
    _splashController.close();
  }
}

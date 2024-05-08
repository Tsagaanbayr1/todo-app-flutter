import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:todo_app/models/task.dart';
import 'dart:developer' as developer;

class HomePage extends StatefulWidget {
  static const String routeName = 'HomePage';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool dragging = false;
  List<TaskModel> tasks = [];
  final controller = TextEditingController();
  final _scrollController = ScrollController();
  List<TaskModel> checkedTasks = [];

  @override
  void initState() {
    super.initState();

    // Get the tasks from arguments from context
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        tasks = ModalRoute.of(context)!.settings.arguments as List<TaskModel>;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: dragging
          ? AppBar(title: const Text('Todo App'))
          : AppBar(title: const Text('Reorder')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Welcome to Todo App'),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Add new task',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    developer.log('Add new task: ${controller.text}');
                    if (controller.text.trim().isNotEmpty) {
                      setState(() {
                        tasks.add(TaskModel(
                          id: tasks.length + 1,
                          title: controller.text,
                        ));
                        controller.text = '';
                        FocusScope.of(context).requestFocus(FocusNode());
                      });
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ReorderableListView(
                children: <Widget>[
                  for (var item in tasks.where((e) => e.isChecked == false))
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      key: Key('${item.id}'),
                      title: Text(item.title),
                      value: item.isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          item.isChecked = !item.isChecked;
                        });
                      },
                    ),
                  const Text('Completed tasks:', key: Key('completed-tasks')),
                  for (var item in tasks.where((e) => e.isChecked == true))
                    CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      key: Key('${item.id}'),
                      title: Text(item.title),
                      value: item.isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          item.isChecked = !item.isChecked;
                        });
                      },
                    ),
                ],
                onReorderStart: (_) => setState(() => dragging = true),
                onReorderEnd: (_) => setState(() => dragging = false),
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final TaskModel item = tasks.removeAt(oldIndex);
                    tasks.insert(newIndex, item);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

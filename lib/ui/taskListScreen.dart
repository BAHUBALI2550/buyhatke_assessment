
import 'package:buyhatke/ui/taskFormScreen.dart';
import 'package:buyhatke/ui/taskListTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/task_bloc.dart';
import '../bloc/theme_bloc.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(TaskLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BuyHatke Manager'),
        actions: [
          const Text("Light"),
          Switch(
            value: context.watch<ThemeBloc>().state == ThemeMode.dark,
            onChanged: (value) {
              context.read<ThemeBloc>().add(ThemeChanged(value));
            },
          ),
          const Text("Dark"),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoadSuccess) {
            final tasks = state.tasks;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskListTile(task: task);
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskFormScreen(null),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

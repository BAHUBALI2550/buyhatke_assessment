import 'package:buyhatke/ui/taskListScreen.dart';
import 'package:buyhatke/task_repo.dart';
import 'package:buyhatke/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/task_bloc.dart';
import 'bloc/theme_bloc.dart';
import 'models/db_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database
  final databaseHelper = DatabaseHelper.instance;
  await databaseHelper.database;

  // Create the repository
  final taskRepository = TaskRepository(databaseHelper: databaseHelper);

  runApp(
    BlocProvider<TaskBloc>(
      create: (context) => TaskBloc(taskRepository: taskRepository),
      child: BlocProvider<ThemeBloc>(
        create: (context) => ThemeBloc(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Task Manager',
          themeMode: themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
          home: const TaskListScreen(),
        );
      },
    );
  }
}


import 'package:buyhatke/models/db_helper.dart';

import 'models/task.dart';

class TaskRepository {
  final DatabaseHelper _databaseHelper;

  TaskRepository({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  Future<List<Task>> getAllTasks() => _databaseHelper.readAllTasks();

  Future<Task> getTaskById(int id) => _databaseHelper.readTask(id);

  Future<Task> insertTask(Task task) => _databaseHelper.createTask(task);

  Future<int> updateTask(Task task) => _databaseHelper.updateTask(task);

  Future<int> deleteTask(int id) => _databaseHelper.deleteTask(id);
}

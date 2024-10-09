import 'package:flutter_test/flutter_test.dart';

import 'models/task.dart';

void main() {
  group('TaskManager Tests', () {
    late TaskManager taskManager;
    late Task sampleTask;

    setUp(() {
      taskManager = TaskManager();
      sampleTask = Task(
        id: 1,
        title: 'Sample Task',
        description: 'This is a sample task',
        dueDate: DateTime.now(),
        priority: 1,
      );
    });

    test('Add task to task manager', () {
      taskManager.addTask(sampleTask);
      expect(taskManager.tasks.contains(sampleTask), isTrue);
    });

    test('Remove task from task manager', () {
      taskManager.addTask(sampleTask);
      taskManager.removeTask(sampleTask);
      expect(taskManager.tasks.contains(sampleTask), isFalse);
    });

    test('Update task in task manager', () {
      taskManager.addTask(sampleTask);
      final updatedTask = sampleTask.copy(title: 'Updated Task', priority: 2);
      taskManager.updateTask(updatedTask);

      expect(taskManager.getTaskById(sampleTask.id!)?.title, 'Updated Task');
      expect(taskManager.getTaskById(sampleTask.id!)?.priority, 2);
    });

    test('Toggle task completion status', () {
      taskManager.addTask(sampleTask);
      taskManager.toggleTaskCompletion(sampleTask.id!);
      expect(taskManager.getTaskById(sampleTask.id!)?.isCompleted, isTrue);

      taskManager.toggleTaskCompletion(sampleTask.id!);
      expect(taskManager.getTaskById(sampleTask.id!)?.isCompleted, isFalse);
    });

    test('Get task by ID', () {
      taskManager.addTask(sampleTask);
      final result = taskManager.getTaskById(sampleTask.id!);
      expect(result, isNotNull);
      expect(result?.id, sampleTask.id);
    });
  });
}

class TaskManager {
  final List<Task> _tasks = [];

  List<Task> get tasks => List.unmodifiable(_tasks);

  void addTask(Task task) {
    _tasks.add(task);
  }

  void removeTask(Task task) {
    _tasks.remove(task);
  }

  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
    }
  }

  Task? getTaskById(int id) {
    return _tasks.firstWhere((task) => task.id == id, orElse: () => null as Task);
  }

  void toggleTaskCompletion(int id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      final task = _tasks[index];
      _tasks[index] = task.copy(isCompleted: !task.isCompleted);
    }
  }
}


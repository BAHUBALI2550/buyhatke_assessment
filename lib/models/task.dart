import 'package:equatable/equatable.dart';

final String tableTasks = 'tasks';

class TaskFields {
  static const String id = '_id';
  static const String title = 'title';
  static const String description = 'description';
  static const String dueDate = 'dueDate';
  static const String priority = 'priority';
  static const String isCompleted = 'isCompleted';

  static final List<String> values = [
    id,
    title,
    description,
    dueDate,
    priority,
    isCompleted,
  ];
}

class Task extends Equatable {
  final int? id;
  final String title;
  final String description;
  final DateTime dueDate;
  final int priority;
  final bool isCompleted;

  const Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    this.isCompleted = false,
  });

  Task copy({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    int? priority,
    bool? isCompleted,
  }) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        dueDate: dueDate ?? this.dueDate,
        priority: priority ?? this.priority,
        isCompleted: isCompleted ?? this.isCompleted,
      );

  static Task fromJson(Map<String, Object?> json) => Task(
    id: json[TaskFields.id] as int?,
    title: json[TaskFields.title] as String,
    description: json[TaskFields.description] as String,
    dueDate: DateTime.parse(json[TaskFields.dueDate] as String),
    priority: json[TaskFields.priority] as int,
    isCompleted: json[TaskFields.isCompleted] == 1,
  );

  Map<String, Object?> toJson() => {
    TaskFields.id: id,
    TaskFields.title: title,
    TaskFields.description: description,
    TaskFields.dueDate: dueDate.toIso8601String(),
    TaskFields.priority: priority,
    TaskFields.isCompleted: isCompleted ? 1 : 0,
  };

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    dueDate,
    priority,
    isCompleted,
  ];
}

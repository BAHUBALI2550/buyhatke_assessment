part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class TaskLoaded extends TaskEvent {}

class TaskAdded extends TaskEvent {
  final Task task;

  const TaskAdded(this.task);

  @override
  List<Object> get props => [task];
}

class TaskUpdated extends TaskEvent {
  final Task task;

  const TaskUpdated(this.task);

  @override
  List<Object> get props => [task];
}

class TaskDeleted extends TaskEvent {
  final Task task;

  const TaskDeleted(this.task);

  @override
  List<Object> get props => [task];
}

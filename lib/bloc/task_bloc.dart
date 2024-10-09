import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/task.dart';
import '../task_repo.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository taskRepository;

  TaskBloc({required this.taskRepository}) : super(TaskInitial()) {
    on<TaskLoaded>(_onTaskLoaded);
    on<TaskAdded>(_onTaskAdded);
    on<TaskUpdated>(_onTaskUpdated);
    on<TaskDeleted>(_onTaskDeleted);
  }

  void _onTaskLoaded(TaskLoaded event, Emitter<TaskState> emit) async {
    emit(TaskLoadSuccess(tasks: await taskRepository.getAllTasks()));
  }

  void _onTaskAdded(TaskAdded event, Emitter<TaskState> emit) async {
    await taskRepository.insertTask(event.task);
    add(TaskLoaded());
  }

  void _onTaskUpdated(TaskUpdated event, Emitter<TaskState> emit) async {
    await taskRepository.updateTask(event.task);
    add(TaskLoaded());
  }

  void _onTaskDeleted(TaskDeleted event, Emitter<TaskState> emit) async {
    await taskRepository.deleteTask(event.task.id!);
    add(TaskLoaded());
  }
}

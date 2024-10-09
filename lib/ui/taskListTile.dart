import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/task_bloc.dart';
import '../models/task.dart';

class TaskListTile extends StatelessWidget {
  final Task task;

  const TaskListTile({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDueDate = DateFormat('MMM dd, yyyy').format(task.dueDate);

    return ListTile(
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (value) {
          context.read<TaskBloc>().add(
              TaskUpdated(task.copy(isCompleted: value!)));
        },
      ),
      title: Text(task.title, style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.description),
          SizedBox(height: 4),
          Row(
            children: [
              getPriorityIcon(task.priority),
              SizedBox(width: 4),
              Text('Due: $formattedDueDate'),
            ],
          ),
        ],
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'edit') {
            _showUpdateBottomSheet(context, task);
          } else if (value == 'delete') {
            context.read<TaskBloc>().add(TaskDeleted(task));
          }
        },
        itemBuilder: (context) =>
        [
          const PopupMenuItem(value: 'edit', child: Text('Edit')),
          const PopupMenuItem(value: 'delete', child: Text('Delete')),
        ],
      ),
    );
  }

  Widget getPriorityIcon(int priority) {
    switch (priority) {
      case 0:
        return const Icon(Icons.low_priority, color: Colors.green);
      case 1:
        return const Icon(Icons.priority_high, color: Colors.red);
      default:
        return const Icon(Icons.low_priority);
    }
  }

  void _showUpdateBottomSheet(BuildContext context, Task task) {
    final _formKey = GlobalKey<FormState>();
    final _titleController = TextEditingController(text: task.title);
    final _descriptionController = TextEditingController(text: task.description);
    DateTime _selectedDate = task.dueDate;
    int _selectedPriority = task.priority;

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                keyboardType: TextInputType.multiline,
                maxLines: null, // Allow multiple lines
              ),
              Row(
                children: [
                  const Text('Due Date:'),
                  TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        _selectedDate = date;
                      }
                    },
                    child: Text(DateFormat('MMM dd, yyyy').format(_selectedDate)),
                  ),
                ],
              ),
              DropdownButtonFormField<int>(
                value: _selectedPriority,
                onChanged: (value) {
                  _selectedPriority = value!;
                },
                items: const [
                  DropdownMenuItem(value: 0, child: Text('Low')),
                  DropdownMenuItem(value: 1, child: Text('High')),
                ],
                decoration: const InputDecoration(labelText: 'Priority'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedTask = task.copy(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      dueDate: _selectedDate,
                      priority: _selectedPriority,
                    );
                    context.read<TaskBloc>().add(TaskUpdated(updatedTask));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
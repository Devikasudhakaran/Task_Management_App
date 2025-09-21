import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/task_model.dart';
import '../../repositories/task_repository.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TaskRepository repo;
  Stream<List<TaskModel>>? _streamSub;

  TasksBloc({required this.repo}) : super(TasksInitial()) {
    on<LoadTasksForUser>((event, emit) async {
      emit(TasksLoading());

      try {
        _streamSub = repo.tasksForUserStream(event.uid);

        await emit.forEach<List<TaskModel>>(
          _streamSub!,
          onData: (tasks) => TasksLoaded(tasks: tasks),
          onError: (error, stackTrace) {
            return TasksError(
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            );
          },
        );
      } catch (e, st) {
        emit(TasksError(message: e.toString(), stackTrace: st.toString()));
        log(e.toString());
      }
    });
  }
}

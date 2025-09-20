part of 'tasks_bloc.dart';

abstract class TasksState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TasksInitial extends TasksState {}
class TasksLoading extends TasksState {}
class TasksLoaded extends TasksState {
  final List<TaskModel> tasks;
  TasksLoaded({required this.tasks});
}
class TasksError extends TasksState {
  final String message;
  TasksError({required this.message});
}
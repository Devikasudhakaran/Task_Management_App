part of 'tasks_bloc.dart';

abstract class TasksEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTasksForUser extends TasksEvent {
  final String uid;
  LoadTasksForUser({required this.uid});
}
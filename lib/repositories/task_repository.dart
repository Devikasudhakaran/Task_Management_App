import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskRepository {
  final _col = FirebaseFirestore.instance.collection('tasks');

  Future<void> createTask(TaskModel task) async {
    await _col.add(task.toMap());
  }

  Stream<List<TaskModel>> tasksForUserStream(String uid) {
    return _col.where('assignedToUid', isEqualTo: uid).orderBy('start').snapshots().map(
      (snap) => snap.docs.map((d) => TaskModel.fromDoc(d)).toList(),
    );
  }
}
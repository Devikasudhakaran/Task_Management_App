import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String? id;
  final String title;
  final String description;
  final String assignedToUid;
  final Timestamp start;
  final Timestamp end;
  final String assignedToName;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.assignedToUid,
    required this.start,
    required this.end,
    required this.assignedToName,
  });

  factory TaskModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      title: (d['title'] ?? '') as String,
      description: (d['description'] ?? '') as String,
      assignedToUid: (d['assignedToUid'] ?? '') as String,
      assignedToName: (d['assignedToName'] ?? 'Unknown') as String, // ✅ fix here
      start: d['start'] as Timestamp,
      end: d['end'] as Timestamp,
    );
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'assignedToUid': assignedToUid,
    'assignedToName': assignedToName, // ✅ save it too
    'start': start,
    'end': end,
  };
}

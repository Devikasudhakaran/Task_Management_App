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
    required this.assignedToName,
    required this.id,
    required this.title,
    required this.description,
    required this.assignedToUid,
    required this.start,
    required this.end,
  });

  factory TaskModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      title: d['title'] ?? '',
      description: d['description'] ?? '',
      assignedToUid: d['assignedToUid'],
      start: d['start'],
      end: d['end'], assignedToName: d['username'],
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'assignedToUid': assignedToUid,
        'start': start,
        'end': end,
      };
}
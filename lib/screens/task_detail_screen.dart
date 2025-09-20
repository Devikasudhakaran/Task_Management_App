
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {
  final String taskId;
  final Map<String, dynamic> taskData;
  final String employeeName;

  const TaskDetailScreen({
    Key? key,
    required this.taskId,
    required this.taskData,
    required this.employeeName,
  }) : super(key: key);

  Future<void> _deleteTask(BuildContext context) async {
    await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Task deleted successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final start = (taskData['start'] as Timestamp).toDate();
    final end = (taskData['end'] as Timestamp).toDate();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Details", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () => _deleteTask(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(taskData['title'] ?? '',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(taskData['description'] ?? ''),
                const SizedBox(height: 20),
                Text("Assigned To: $employeeName"),
                const SizedBox(height: 10),
                Text("Start: ${start.toString().split(" ")[0]}"),
                Text("End: ${end.toString().split(" ")[0]}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Task"),
        content: const Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task deleted successfully")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final start = (taskData['start'] as Timestamp).toDate();
    final end = (taskData['end'] as Timestamp).toDate();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Details"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () => _deleteTask(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    taskData['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 10),


                  Text(
                    taskData['description'] ?? '',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),

                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.indigo),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Assigned To: $employeeName",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),


                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.green),
                      const SizedBox(width: 10),
                      Text(
                        "Start: ${start.toString().split(" ")[0]}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),


                  Row(
                    children: [
                      const Icon(Icons.event, color: Colors.redAccent),
                      const SizedBox(width: 10),
                      Text(
                        "End: ${end.toString().split(" ")[0]}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


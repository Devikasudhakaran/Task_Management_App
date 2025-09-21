import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/tasks_bloc/tasks_bloc.dart';
import '../repositories/task_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployeeTasksScreen extends StatefulWidget {
  const EmployeeTasksScreen({Key? key}) : super(key: key);

  @override
  State<EmployeeTasksScreen> createState() => _EmployeeTasksScreenState();
}

class _EmployeeTasksScreenState extends State<EmployeeTasksScreen> {

  Future<void> _logout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel",style: TextStyle(color: Colors.black),),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("OK",style: TextStyle(color: Colors.black),),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, "/login");
    }
  }
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return BlocProvider(
      create: (_) => TasksBloc(repo: TaskRepository())..add(LoadTasksForUser(uid: uid)),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "My Tasks",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.indigo,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () => _logout(context),
            ),
          ],
        ),
        body: BlocBuilder<TasksBloc, TasksState>(
          builder: (context, state) {
            if (state is TasksLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TasksLoaded) {
              if (state.tasks.isEmpty) {
                return const Center(child: Text("No tasks assigned."));
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: state.tasks.map((task) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              task.description,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  "Start: ${task.start.toDate().toString().split(" ")[0]}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  "End: ${task.end.toDate().toString().split(" ")[0]}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }

            if (state is TasksError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/task_model.dart';

class AssignTaskScreen extends StatefulWidget {
  const AssignTaskScreen({Key? key}) : super(key: key);

  @override
  State<AssignTaskScreen> createState() => _AssignTaskScreenState();
}

class _AssignTaskScreenState extends State<AssignTaskScreen> {
  String? _selectedEmployee;
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime? _start, _end;

  List<Map<String, String>> _employees = [];

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
  }


  Future<void> _fetchEmployees() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'employee')
        .get();

    final employees = snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'uid': doc.id,
        'name': (data['username'] ?? 'Unnamed').toString(),
        'email': (data['email'] ?? '').toString(),
        'role': (data['role'] ?? '').toString(),
      };
    }).toList();

    setState(() => _employees = employees);
  }
  Future<void> _saveTask() async {
    if (_selectedEmployee == null ||
        _titleCtrl.text.isEmpty ||
        _start == null ||
        _end == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final task = TaskModel(
      id: null,
      assignedToUid: _selectedEmployee!,
      assignedToName: _employees
          .firstWhere((e) => e['uid'] == _selectedEmployee)['name']
          .toString(),
      title: _titleCtrl.text,
      description: _descCtrl.text,
      start: Timestamp.fromDate(_start!),
      end: Timestamp.fromDate(_end!),
    );

    await FirebaseFirestore.instance.collection('tasks').add(task.toMap());

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task assigned successfully')));


    Navigator.pushNamedAndRemoveUntil(context, "/admin", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assign Task"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _employees.isEmpty
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<String>(
              value: _selectedEmployee,
              items: _employees
                  .map((e) => DropdownMenuItem(
                value: e['uid'],
                child: Text(e['name']!),
              ))
                  .toList(),
              onChanged: (val) => setState(() => _selectedEmployee = val),
              decoration: const InputDecoration(
                labelText: "Select Employee",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: "Task Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Task Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(_start == null
                  ? "Select Start Date"
                  : "Start: ${_start.toString().split(" ")[0]}"),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() => _start = picked);
                }
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(_end == null
                  ? "Select End Date"
                  : "End: ${_end.toString().split(" ")[0]}"),
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _start ?? DateTime.now(),
                  firstDate: _start ?? DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() => _end = picked);
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _saveTask,
              child: const Text("Save Task",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}

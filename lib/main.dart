import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_task_manager/blocs/tasks_bloc/tasks_bloc.dart';
import 'package:flutter_task_manager/repositories/task_repository.dart';
import 'package:flutter_task_manager/screens/admin_dashboard.dart';
import 'package:flutter_task_manager/screens/assign_task_screen.dart';
import 'package:flutter_task_manager/screens/employee_tasks_screen.dart';
import 'package:flutter_task_manager/screens/login_screen.dart';
import 'package:flutter_task_manager/screens/sign_up_screen.dart';
import 'package:flutter_task_manager/services/firebase_service.dart';
import 'blocs/auth_bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseService.initializeFCM();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => TasksBloc(repo: TaskRepository())),
        
      ],
      child: MaterialApp(
        title: 'Task Manager',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: const SignUpScreen(),
        routes: {
          '/login': (_) => const LoginScreen(),
          '/admin': (_) => const AdminDashboard(),
          '/employee': (_) => const EmployeeTasksScreen(),
          '/assign': (_) => const AssignTaskScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}


import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Future<void> checkUserRole(User user) async {
  //   DocumentSnapshot doc =
  //   await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
  //
  //   String role = doc["role"];
  //
  //   if (role == "admin") {
  //     Navigator.pushReplacementNamed(context, "/admin");
  //   } else {
  //     Navigator.pushReplacementNamed(context, "/employee");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          // return  Center(child: CircularProgressIndicator());
        }

        if (state is Authenticated) {
          log("User authenticated: email=${state.email}, role=${state.role}");
          if (state.role == "admin") {
            Navigator.pushReplacementNamed(context, "/admin");
          } else {
            Navigator.pushNamed(context, "/employee");
          }
        }

        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.task_alt,
                          size: 60, color: Colors.indigo),
                      const SizedBox(height: 16),
                      const Text(
                        "Task Manager Login",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // TextField(
                      //   controller: _emailCtrl,
                      //   decoration: const InputDecoration(
                      //     labelText: "Email",
                      //     prefixIcon: Icon(Icons.email),
                      //     border: OutlineInputBorder(),
                      //   ),
                      // ),
                      TextFormField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) =>
                            val == null || val.isEmpty ? "Enter Valid Email" : null,
                      ),
                      const SizedBox(height: 12),
                      // TextField(
                      //   controller: _passwordCtrl,
                      //   obscureText: true,
                      //   decoration: const InputDecoration(
                      //     labelText: "Password",
                      //     prefixIcon: Icon(Icons.lock),
                      //     border: OutlineInputBorder(),
                      //   ),
                      // ),
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val != null && val.length < 6
                            ? "Enter Valid Password"
                            : null,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          backgroundColor: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  LoginRequested(
                                    email: _emailCtrl.text.trim(),
                                    password: _passwordCtrl.text.trim(),
                                  ),
                                );
                          }
                        },
                        child: const Text("Login",
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                      const SizedBox(height: 9),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? ",
                              style: TextStyle(
                                color: Colors.black,
                              )),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text('Sign Up',
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

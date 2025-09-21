import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  String? _role;

  final _formKey = GlobalKey<FormState>();

  Future<void> _signup() async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );

      String uid = userCred.user!.uid;

      await _firestore.collection("users").doc(uid).set({
        "username": _usernameCtrl.text.trim(),
        "email": _emailCtrl.text.trim(),
        "role": _role,
        "createdAt": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account created! Role: $_role")),
      );


      if (_role == "admin") {
        if (mounted) Navigator.pushReplacementNamed(context, "/admin");
      } else {
        if (mounted) Navigator.pushReplacementNamed(context, "/employee");
      }


    }
    catch (e,st) {
      log("Error in signup: $e");
      log("Stack trace: $st");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error====================: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.indigo],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.person_add,
                          size: 60, color: Colors.deepPurple),
                      const SizedBox(height: 16),
                      const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        // validator: (val) =>
                        // val == null || val.isEmpty ? "Enter email" : null,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Enter email";
                          }
                          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(val)) {
                            return "Enter a valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _usernameCtrl,
                        decoration: const InputDecoration(
                          labelText: "Username",
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) =>
                        val == null || val.isEmpty ? "Enter Username" : null,
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val != null && val.length < 6
                            ? "Password must be 6+ chars"
                            : null,
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _confirmCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Confirm Password",
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val != _passwordCtrl.text
                            ? "Passwords do not match"
                            : null,
                      ),
                      const SizedBox(height: 12),

                      DropdownButtonFormField<String>(
                        value: _role,
                        items: const [
                          DropdownMenuItem(
                              value: "admin", child: Text("Admin")),
                          DropdownMenuItem(
                              value: "employee", child: Text("Employee")),
                        ],
                        onChanged: (val) => setState(() => _role = val),
                        decoration: const InputDecoration(
                          labelText: "Select Role",
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) =>
                        val == null ? "Please select role" : null,
                      ),
                      const SizedBox(height: 20),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                           _signup();
                          }
                        },
                        child: const Text("Sign Up",
                            style: TextStyle(fontSize: 18,color: Colors.white)),
                      ),

                      const SizedBox(height: 9),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? ",
                              style: TextStyle(
                                color: Colors.black,
                              )
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, "/login");
                            },
                            child: Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.deepPurple,fontSize: 16,fontWeight: FontWeight.bold
                                )
                            ),
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

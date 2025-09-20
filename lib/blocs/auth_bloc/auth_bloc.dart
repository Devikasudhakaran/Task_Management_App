import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fauth;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _auth = fauth.FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  AuthBloc() : super(AuthInitial()) {

    on<LoginRequested>((e, emit) async {
      emit(AuthLoading());
      try {
        final userCred = await _auth.signInWithEmailAndPassword(
          email: e.email,
          password: e.password,
        );
        final user = userCred.user!;

        log(user.uid);


        final doc = await _firestore.collection("users").doc(user.uid).get();

        if (!doc.exists) {
          emit(AuthFailure(message: "User data not found in Firestore"));
          return;
        }

        final data = doc.data()!;
        final role = data["role"];
        final username = data["username"] ?? user.email!.split('@')[0];

        if (role == null) {
          emit(AuthFailure(message: "User role missing in Firestore"));
          return;
        }

        emit(Authenticated(
          uid: user.uid,
          email: user.email!,
          role: role,
          username: username,
        ));
      } catch (err) {
        emit(AuthFailure(message: err.toString()));
      }
    });


    on<LogoutRequested>((e, emit) async {
      await _auth.signOut();
      emit(Unauthenticated());
    });
  }
}
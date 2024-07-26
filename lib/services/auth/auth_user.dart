import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable // makes this class and the sub-classes immunable, which means all the variables must be final or const
class AuthUser {
  final bool isEmailVerified;
  const AuthUser({required this.isEmailVerified});

  factory AuthUser.fromFirebase(User user) => AuthUser(isEmailVerified: user.emailVerified); 
}

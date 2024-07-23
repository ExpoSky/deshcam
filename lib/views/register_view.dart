import 'package:deshcam/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController
      _email; // late keyword tells the compiler that we haven't given any value to it yet but we will give before using it.
  late final TextEditingController _password;

  @override
  void initState() {
    // (Already defined by Flutter) this function creates all the variables at once, when the home page gets called
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    // (Already defined by Flutter) this function disposes the variables after it goets deleted from the RAM.
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false, // hides the suggestions in keypad
            autocorrect: false, // disables auto correction in keypad
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                hintText:
                    "Enter your email here"), // Hint for user in the text field
          ), // The field for user to input Text.

          TextField(
            controller: _password,
            obscureText: true, // hides the characters wirth star signs(*)
            enableSuggestions: false, // hides the suggestions in keypad
            autocorrect: false, // disables auto correction in keypad
            decoration: const InputDecoration(
                hintText:
                    "Enter your password here"), // Hint for user in the text field
          ), // To store the input value, late final TextEditingController has been created above

          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                final userCredential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email,
                  password: password,
                ); // Future function: creates the user in Firebase
                devtools.log(userCredential.toString());
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  devtools.log('Weak Password');
                } else if (e.code == 'email-alrady-in-use') {
                  devtools.log('Email is already in use');
                } else if (e.code == 'invalid-email') {
                  devtools.log('Email is invalid');
                }
              }
            }, // Registiration will be done in Firebase which functions async
            child: const Text("Register"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text('Already have an account? Login here.'))
        ],
      ),
    );
  }
}

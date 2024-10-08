import 'package:deshcam/constants/routes.dart';
import 'package:deshcam/services/auth/auth_exceptions.dart';
import 'package:deshcam/services/auth/auth_service.dart';
import 'package:deshcam/utilities/show_error_dialog.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text('Login'),
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
                await AuthService.firebase().logIn(
                  email: email,
                  password: password,
                );

                if (!context.mounted) return;
                final user = AuthService.firebase().currentUser;
                if (user?.isEmailVerified ?? false) {
                  // user is verified
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } else {
                  // user is NOT verified
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute,
                    (route) => false,
                  );
                }
              } on UserNotFoundAuthException {
                await showErrorDialog(
                  context,
                  'User not found',
                );
              } on WrongPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Wrong password',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Authentication error',
                );
              }
            }, // Registiration will be done in Firebase which functions async
            child: const Text("Login"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('Not registered yet? Register here.'))
        ],
      ),
    );
  }
}

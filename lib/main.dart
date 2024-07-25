import 'package:deshcam/constants/routes.dart';
import 'package:deshcam/services/auth/auth_service.dart';
import 'package:deshcam/views/login_view.dart';
import 'package:deshcam/views/notes_view.dart';
import 'package:deshcam/views/register_view.dart';
import 'package:deshcam/views/verify_email.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized;

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // This is a special builder widget that contains future functions. it has future and builder.

      future: AuthService.firebase().initialize(),

      builder: (context, snapshot) {
        // builder contains the rest of it

        switch (snapshot.connectionState) {
          //snapshot.connectionState is the state of the future function (none, waiting, active, done)

          case ConnectionState
                .done: // when it's done, we can build the rest of it, for other cases "Loading..." text will be printed. (See the default case in this switch statement)
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
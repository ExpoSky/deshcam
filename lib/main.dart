import 'package:deshcam/firebase_options.dart';
import 'package:deshcam/views/login_view.dart';
import 'package:deshcam/views/register_view.dart';
import 'package:deshcam/views/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage
({super.key});

   @override
  Widget build(BuildContext context) {
    return FutureBuilder( // This is a special builder widget that contains future functions. it has future and builder.

        future: Firebase.initializeApp(  // future: contains the future function
                  options: DefaultFirebaseOptions.currentPlatform,
                ), // initializes the Friebase, this should be done before using the function below: FirebaseAuth.instance.createUserWithEmailAndPassword

        builder: (context, snapshot) { // builder contains the rest of it

          switch (snapshot.connectionState) { //snapshot.connectionState is the state of the future function (none, waiting, active, done) 
            
            case ConnectionState.done: // when it's done, we can build the rest of it, for other cases "Loading..." text will be printed. (See the default case in this switch statement)
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                if (user.emailVerified) {
                  print('Email is verified');
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return const LoginView();
              }
             return const Text('Done!');
            default: 
              return const CircularProgressIndicator();
        }

          
        },
      );
  }
}



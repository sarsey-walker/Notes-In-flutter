import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/firebase_options.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/register_view.dart';
import 'package:notes/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
      // textButtonTheme: TextButtonThemeData(
      //   style: ButtonStyle(
      //     foregroundColor: MaterialStateProperty.all(Colors.white),
      //     backgroundColor: MaterialStateProperty.all(Colors.deepOrange),
      //     padding: MaterialStateProperty.all(
      //         const EdgeInsets.only(left: 30, right: 30, top: 15, bottom: 15)),
      //   ),
      // ),
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: Platform.isLinux
            ? DefaultFirebaseOptions.web
            : DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const Text('Something Wrong..');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            return const LoginView();
          } else {
            if (user.emailVerified) {
              return const NotesView();
            } else {
              return const VerifyEmailView();
            }
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

enum MenuActions { logOut }

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My notes'),
        actions: [
          PopupMenuButton<MenuActions>(
            onSelected: ((value) async {
              switch (value) {
                case MenuActions.logOut:
                  final shouldlogOut = await showlogOutDialog(context);
                  if (shouldlogOut) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  }
                  break;
              }
            }),
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuActions>(
                  value: MenuActions.logOut,
                  child: Text('Log out'),
                )
              ];
            },
          ),
        ],
      ),
      body: const Text('hello World!'),
    );
  }
}

Future<bool> showlogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you wanna log ou?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Yes'),
          )
        ],
      );
    },
  ).then((value) => value ?? false);
}

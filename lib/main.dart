import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes/firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: Platform.isLinux
              ? DefaultFirebaseOptions.web
              : DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            print(snapshot.error);
            return const Text('Something Wrong..');
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            final user = FirebaseAuth.instance.currentUser;
            final emailVerified = user?.emailVerified ?? false;
            if (emailVerified) {
              print('You are a verified user.');
            } else {
              print('You need to verify your email first.');
            }
            return const Text('done');
          }
          return const Text('fora dos ifs');
          /*switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              final emailVerified = user?.emailVerified ?? false;
              if (emailVerified) {
                print('You are a verified user.');
              } else {
                print('You need to verify your email first.');
              }
              print('${snapshot.connectionState}');
              return const Text('done');

            default:
              return const Text('Loading..');
          }*/
        },
      ),
    );
  }
}

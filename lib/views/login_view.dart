import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'E-mail',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
          ),
          TextButton(
            onPressed: () async {
              await Firebase.initializeApp(
                options: Platform.isLinux
                    ? DefaultFirebaseOptions.web
                    : DefaultFirebaseOptions.currentPlatform,
              );
              final email = _email.text;
              final password = _password.text;
              try {
                final credential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                print(credential);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'user-not-found') {
                  print('User not found!');
                } else if (e.code == 'wrong-password') {
                  print('Wrong password!');
                } else {
                  print('Something else have happened');
                }
              } catch (e) {
                print(e);
              }

              // final userCredential =
              //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
              //   email: email,
              //   password: password,
              // );
              // print(userCredential);
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/register/', (route) => false);
            },
            child: const Text('Not registered yet?'),
          ),
        ],
      ),
    );
  }
}


/*
retorno
UserCredential(additionalUserInfo: AdditionalUserInfo(isNewUser: true, profile: {}, providerId: null, username: null), credential: null, user: User(displayName: null, email: sarsey.james@gmail.com, emailVerified: false, isAnonymous: false, metadata: UserMetadata(creationTime: 2023-01-30 00:20:20.769Z, lastSignInTime: 2023-01-30 00:20:20.769Z), phoneNumber: null, photoURL: null, providerData, [UserInfo(displayName: null, email: sarsey.james@gmail.com, phoneNumber: null, photoURL: null, providerId: password, uid: sarsey.james@gmail.com)], refreshToken: , tenantId: null, uid: NHw7nXMuRsVM2RGe6ijoDLiBAi73))

 */
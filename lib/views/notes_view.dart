import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/enum/actions_menu.dart';
import 'package:notes/main.dart';
import 'package:notes/services/auth/auth_service.dart';

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
                    await AuthService.firebase().logOut();
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

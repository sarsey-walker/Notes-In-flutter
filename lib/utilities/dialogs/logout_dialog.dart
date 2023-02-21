import 'package:flutter/material.dart';
import 'package:notes/utilities/dialogs/generic_dialog.dart';

Future<bool> showlogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    content: 'Are shure you want to log out?',
    title: 'Log out',
    optionBuilder: () => {
      'Cancel': false,
      'Log out': true,
    },
  ).then(
    (value) => value ?? false,
  );
}

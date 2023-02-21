import 'package:flutter/material.dart';
import 'package:notes/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    content: text,
    title: 'An error occurred',
    optionBuilder: () => {
      'OK': null,
    },
  );
}

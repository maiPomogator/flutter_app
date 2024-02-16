import 'package:flutter/material.dart';

class ErrorDialog {
  static void showError(BuildContext context, String title, String text) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    AlertDialog alert =  AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: [okButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

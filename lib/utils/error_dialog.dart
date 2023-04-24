import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/custom_error.dart';

Future<bool?> errorDialog(BuildContext context, CustomError e) {
  if (Platform.isIOS) {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(e.code),
          content: Text('${e.plugin}\n\n${e.message}'),
          actions: [
            e.code == 'user-not-found'
                ? CupertinoDialogAction(
                    child: const Text('Sign up'),
                    onPressed: () => Navigator.pop(context, true),
                  )
                : Container(),
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        );
      },
    );
  } else {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Unsuccessful login'),
          content: Text('${e.code}\n\n${e.message}'),
          actions: [
            e.code == 'user-not-found'
                ? TextButton(
                    child: const Text('Sign up'),
                    onPressed: () => Navigator.pop(context, true),
                  )
                : Container(),
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        );
      },
    );
  }
}

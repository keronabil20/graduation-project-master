// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:awesome_dialog/awesome_dialog.dart';

class DialogHelper {
  static void showAwesomeDialog({
    required BuildContext context,
    required DialogType dialogType,
    required String title,
    required String message,
    VoidCallback? onOk,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: dialogType,
      animType: AnimType.bottomSlide,
      title: title,
      desc: message,
      btnOkOnPress: onOk ?? () {},
    ).show();
  }
}

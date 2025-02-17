import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ButtonActionType { action, cancel }

Future<ButtonActionType?> showDialogAlert({
  required BuildContext context,
  required String title,
  required String message,
  required String actionButtonTitle,
  Function? actionButtonOnPressed,
  Function? cancelButtonOnPressed,
  String? cancelButtonTitle,
  TextStyle? actionButtonTextStyle,
  TextStyle? cancelButtonTextStyle,
}) {
  return _showDialogAlert(
    context: context,
    title: title,
    message: message,
    actionButtonTitle: actionButtonTitle,
    cancelButtonTitle: cancelButtonTitle,
    actionButtonTextStyle: actionButtonTextStyle,
    cancelButtonTextStyle: cancelButtonTextStyle,
    actionButtonOnPressed: actionButtonOnPressed,
    cancelButtonOnPressed: cancelButtonOnPressed,
  );
}

Future<ButtonActionType?> _showDialogAlert({
  required BuildContext context,
  required String title,
  required String message,
  required String actionButtonTitle,
  Function? actionButtonOnPressed,
  Function? cancelButtonOnPressed,
  String? cancelButtonTitle,
  TextStyle? actionButtonTextStyle,
  TextStyle? cancelButtonTextStyle,
}) {
  final actions = [
    DialogAlertButton(
        onPressed: () {
          actionButtonOnPressed!.call();
          // Navigator.of(context).pop(ButtonActionType.action);
        },
        isDefaultAction: true,
        title: actionButtonTitle,
        textStyle: actionButtonTextStyle),
  ];

  if (cancelButtonTitle != null) {
    actions.insert(
        0,
        DialogAlertButton(
          onPressed: () {
            cancelButtonOnPressed!.call();
            // Navigator.of(context).pop(ButtonActionType.cancel);
          },
          title: cancelButtonTitle,
          textStyle: cancelButtonTextStyle,
        ));
  }

  return _showDialogAlertWidget(context, title, message, actions);
}

Future<ButtonActionType?> _showDialogAlertWidget(
    BuildContext context, String title, String message, List<Widget> actions) {
  // if (!Platform.isIOS) {
  //   return showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //           title: Text(title), content: Text(message, style: TextStyle(fontSize: 14.5),), actions: actions));
  // }
  return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text(message),
        ),
        actions: actions,
      ));
}


class DialogAlertButton extends StatelessWidget {
  const DialogAlertButton({
    Key? key,
    required this.onPressed,
    required this.title,
    this.isDestructiveAction = false,
    this.isDefaultAction = false,
    this.textStyle,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String title;
  final bool isDestructiveAction;
  final bool isDefaultAction;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return !Platform.isIOS
        ? TextButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: textStyle,
      ),
    )
        : CupertinoDialogAction(
      isDestructiveAction: isDestructiveAction,
      isDefaultAction: isDefaultAction,
      onPressed: onPressed,
      child: Text(
        title,
        style: textStyle,
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:scaffold/scaffold_lang.dart';

Future<T?> showAlertDialog<T>({
  required BuildContext context,
  required List<AlertDialogAction<T>> actions,
  Widget? title,
  String? titleText,
  Widget? content,
  String? contentText,
  bool useRootNavigator = true,
  bool isDismissible = false,
}) {
  return showCupertinoDialog<T>(
    context: context,
    builder: (context) => PopScope(
      canPop: isDismissible,
      child: CupertinoAlertDialog(
        title: title ?? titleText?.let((it) => Text(it)),
        content: content ?? contentText?.let((it) => Text(it)),
        actions: actions
            .map((action) => CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: useRootNavigator).pop(action.value);
                  },
                  isDefaultAction: action.isDefaultAction,
                  isDestructiveAction: action.isDestructiveAction,
                  child: action.child ?? Text(action.childText ?? action.value.toString()),
                ))
            .toList(growable: false),
      ),
    ),
    useRootNavigator: useRootNavigator,
    barrierDismissible: isDismissible,
  );
}

class AlertDialogAction<T> {
  final T value;
  final Widget? child;
  final String? childText;
  final bool isDefaultAction;
  final bool isDestructiveAction;

  AlertDialogAction({
    required this.value,
    this.child,
    this.childText,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
  });
}

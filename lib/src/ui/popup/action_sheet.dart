import 'package:flutter/cupertino.dart';

import '../../lang/extensions.dart';

Future<T?> showActionSheet<T>({
  required BuildContext context,
  required List<ActionSheetEntry<T>> entries,
  Widget? title,
  String? titleText,
  Widget? message,
  String? messageText,
  Widget? cancel,
  String? cancelText,
  bool useRootNavigator = true,
  bool isDismissible = true,
}) {
  return showCupertinoModalPopup<T>(
    context: context,
    builder: (context) => PopScope(
      canPop: isDismissible,
      child: CupertinoActionSheet(
        title: title ?? titleText?.let((it) => Text(it)),
        message: message ?? messageText?.let((it) => Text(it)),
        actions: entries
            .map((entry) => CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: useRootNavigator).pop(entry.value);
                  },
                  isDefaultAction: entry.isDefaultAction,
                  isDestructiveAction: entry.isDestructiveAction,
                  child: entry.child ?? Text(entry.childText ?? entry.value.toString()),
                ))
            .toList(growable: false),
        cancelButton: cancel?.let((it) => CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: useRootNavigator).pop();
                  },
                  child: it,
                )) ??
            cancelText?.let((it) => CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: useRootNavigator).pop();
                  },
                  child: Text(it),
                )),
      ),
    ),
    useRootNavigator: useRootNavigator,
    barrierDismissible: isDismissible,
  );
}

class ActionSheetEntry<T> {
  final T value;
  final Widget? child;
  final String? childText;
  final bool isDefaultAction;
  final bool isDestructiveAction;

  const ActionSheetEntry({
    required this.value,
    this.child,
    this.childText,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
  });
}

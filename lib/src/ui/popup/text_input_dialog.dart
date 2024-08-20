import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scaffold/scaffold_lang.dart';

Future<List<String>?> showTextInputDialog({
  required BuildContext context,
  required List<TextInputDialogField> fields,
  Widget? title,
  String? titleText,
  Widget? message,
  String? messageText,
  Widget? actionNo,
  String? actionNoText,
  Widget? actionOk,
  String? actionOkText,
  bool useRootNavigator = true,
  bool isDismissible = false,
}) {
  return showCupertinoDialog<List<String>>(
    context: context,
    builder: (context) => PopScope(
      canPop: isDismissible,
      child: _IosTextInputDialog(
        title: title ?? titleText?.let((it) => Text(it)),
        message: message ?? messageText?.let((it) => Text(it)),
        fields: fields,
        actionNo: actionNo ?? actionNoText?.let((it) => Text(it)),
        actionOk: actionOk ?? actionOkText?.let((it) => Text(it)),
        onActionNoPressed: () {
          Navigator.of(context, rootNavigator: useRootNavigator).pop();
        },
        onActionOkPressed: (fieldTextList) {
          Navigator.of(context, rootNavigator: useRootNavigator).pop(fieldTextList);
        },
      ),
    ),
    useRootNavigator: useRootNavigator,
    barrierDismissible: isDismissible,
  );
}

class TextInputDialogField {
  final String? initialText;
  final String? hintText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;

  TextInputDialogField({
    this.initialText,
    this.hintText,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
  });
}

class _IosTextInputDialog extends StatefulWidget {
  final Widget? title;
  final Widget? message;
  final List<TextInputDialogField> fields;
  final Widget? actionNo;
  final Widget? actionOk;
  final VoidCallback? onActionNoPressed;
  final ValueChanged<List<String>>? onActionOkPressed;

  const _IosTextInputDialog({
    this.title,
    this.message,
    required this.fields,
    this.actionNo,
    this.actionOk,
    this.onActionNoPressed,
    this.onActionOkPressed,
  });

  @override
  State<StatefulWidget> createState() => _IosTextInputDialogState();
}

class _IosTextInputDialogState extends State<_IosTextInputDialog> {
  late final List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = widget.fields.map((field) => TextEditingController(text: field.initialText)).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final contentChildren = <Widget>[];
    widget.message?.let((it) {
      contentChildren.add(it);
    });
    for (int i = 0; i < widget.fields.length; i++) {
      final field = widget.fields[i];
      contentChildren.add(Padding(
        padding: const EdgeInsets.only(top: 8),
        child: CupertinoTextField(
          controller: controllers[i],
          placeholder: field.hintText,
          keyboardType: field.keyboardType,
          textInputAction: i < widget.fields.length - 1 ? TextInputAction.next : null,
          autofocus: i == 0,
          maxLines: field.maxLines,
          minLines: field.minLines,
          maxLength: field.maxLength,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ));
    }
    return CupertinoAlertDialog(
      title: widget.title,
      content: contentChildren.isNotEmpty
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: contentChildren,
            )
          : null,
      actions: [
        if (widget.actionNo != null)
          CupertinoDialogAction(
            onPressed: widget.onActionNoPressed,
            child: widget.actionNo!,
          ),
        if (widget.actionOk != null)
          CupertinoDialogAction(
            onPressed: () {
              final fieldTextList = controllers.map((controller) => controller.text).toList(growable: false);
              widget.onActionOkPressed?.call(fieldTextList);
            },
            child: widget.actionOk!,
          ),
      ],
    );
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

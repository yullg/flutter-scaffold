import 'package:flutter/widgets.dart';

class GlobalDismissKeyboardWidget extends StatelessWidget {
  final Widget child;

  const GlobalDismissKeyboardWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: <Type, Action<Intent>>{
        EditableTextTapOutsideIntent: CallbackAction<EditableTextTapOutsideIntent>(
          onInvoke: (intent) {
            intent.focusNode.unfocus();
            return null;
          },
        ),
      },
      child: child,
    );
  }
}

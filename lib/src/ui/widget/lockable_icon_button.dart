import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LockableIconButton extends StatefulWidget {
  final double? iconSize;
  final VisualDensity? visualDensity;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final Color? color;
  final Color? disabledColor;
  final String? tooltip;
  final BoxConstraints? constraints;
  final ButtonStyle? style;
  final AsyncCallback? onPressed;
  final Widget icon;
  final Widget? lockedIcon;

  const LockableIconButton(
      {super.key,
      this.iconSize,
      this.visualDensity,
      this.padding,
      this.alignment,
      this.color,
      this.disabledColor,
      this.tooltip,
      this.constraints,
      this.style,
      required this.onPressed,
      required this.icon,
      this.lockedIcon});

  @override
  State<StatefulWidget> createState() => _LockableIconButtonState();
}

class _LockableIconButtonState extends State<LockableIconButton> {
  bool locked = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: widget.iconSize,
      visualDensity: widget.visualDensity,
      padding: widget.padding,
      alignment: widget.alignment,
      color: widget.color,
      disabledColor: widget.disabledColor,
      tooltip: widget.tooltip,
      constraints: widget.constraints,
      style: widget.style,
      onPressed: locked || widget.onPressed == null
          ? null
          : () {
              setState(() => locked = true);
              widget.onPressed!().whenComplete(() {
                if (mounted) {
                  setState(() => locked = false);
                }
              });
            },
      icon: locked ? widget.lockedIcon ?? widget.icon : widget.icon,
    );
  }
}

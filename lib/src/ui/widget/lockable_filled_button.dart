import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LockableFilledButton extends StatefulWidget {
  final AsyncCallback? onPressed;
  final AsyncCallback? onLongPress;
  final ButtonStyle? style;
  final Widget? child;
  final Widget? lockedChild;
  final Widget? icon;
  final Widget? lockedIcon;
  final Widget? label;
  final Widget? lockedLabel;
  final bool tonal;

  const LockableFilledButton({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.style,
    required Widget this.child,
    this.lockedChild,
  })  : icon = null,
        lockedIcon = null,
        label = null,
        lockedLabel = null,
        tonal = false;

  const LockableFilledButton.icon({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.style,
    required Widget this.icon,
    this.lockedIcon,
    required Widget this.label,
    this.lockedLabel,
  })  : child = null,
        lockedChild = null,
        tonal = false;

  const LockableFilledButton.tonal({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.style,
    required Widget this.child,
    this.lockedChild,
  })  : icon = null,
        lockedIcon = null,
        label = null,
        lockedLabel = null,
        tonal = true;

  const LockableFilledButton.tonalIcon({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.style,
    required Widget this.icon,
    this.lockedIcon,
    required Widget this.label,
    this.lockedLabel,
  })  : child = null,
        lockedChild = null,
        tonal = true;

  @override
  State<StatefulWidget> createState() => _LockableFilledButtonState();
}

class _LockableFilledButtonState extends State<LockableFilledButton> {
  bool locked = false;

  @override
  Widget build(BuildContext context) {
    if (widget.child != null) {
      if (widget.tonal) {
        return FilledButton.tonal(
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
          onLongPress: locked || widget.onLongPress == null
              ? null
              : () {
                  setState(() => locked = true);
                  widget.onLongPress!().whenComplete(() {
                    if (mounted) {
                      setState(() => locked = false);
                    }
                  });
                },
          child: locked ? widget.lockedChild ?? widget.child : widget.child,
        );
      } else {
        return FilledButton(
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
          onLongPress: locked || widget.onLongPress == null
              ? null
              : () {
                  setState(() => locked = true);
                  widget.onLongPress!().whenComplete(() {
                    if (mounted) {
                      setState(() => locked = false);
                    }
                  });
                },
          child: locked ? widget.lockedChild ?? widget.child : widget.child,
        );
      }
    } else if (widget.icon != null && widget.label != null) {
      if (widget.tonal) {
        return FilledButton.tonalIcon(
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
          onLongPress: locked || widget.onLongPress == null
              ? null
              : () {
                  setState(() => locked = true);
                  widget.onLongPress!().whenComplete(() {
                    if (mounted) {
                      setState(() => locked = false);
                    }
                  });
                },
          icon: locked ? widget.lockedIcon ?? widget.icon! : widget.icon!,
          label: locked ? widget.lockedLabel ?? widget.label! : widget.label!,
        );
      } else {
        return FilledButton.icon(
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
          onLongPress: locked || widget.onLongPress == null
              ? null
              : () {
                  setState(() => locked = true);
                  widget.onLongPress!().whenComplete(() {
                    if (mounted) {
                      setState(() => locked = false);
                    }
                  });
                },
          icon: locked ? widget.lockedIcon ?? widget.icon! : widget.icon!,
          label: locked ? widget.lockedLabel ?? widget.label! : widget.label!,
        );
      }
    } else {
      throw UnimplementedError("Invalid 'LockableFilledButton' instance");
    }
  }
}

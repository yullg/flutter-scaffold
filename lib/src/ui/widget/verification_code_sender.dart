import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../support/preference/default_preference.dart';
import '../../scaffold_constants.dart';
import 'lockable_elevated_button.dart';
import 'lockable_filled_button.dart';
import 'lockable_outlined_button.dart';
import 'lockable_text_button.dart';

enum _Mode { elevated, filled, outlined, text }

class VerificationCodeSender extends StatefulWidget {
  final _Mode _mode;
  final String name;
  final int interval;
  final AsyncCallback onPressed;
  final Widget Function(BuildContext context, int? lockedSeconds) childBuilder;
  final Widget? lockedChild;
  final ButtonStyle? style;
  final Future<DateTime?> Function(String)? loadLastSendTime;
  final Future<void> Function(String, DateTime)? saveLastSendTime;

  const VerificationCodeSender.elevated({
    super.key,
    this.name = ScaffoldConstants.kVerificationCodeSenderNameDefault,
    this.interval = ScaffoldConstants.kVerificationCodeSenderIntervalDefault,
    required this.onPressed,
    required this.childBuilder,
    this.lockedChild,
    this.style,
    this.loadLastSendTime,
    this.saveLastSendTime,
  }) : _mode = _Mode.elevated;

  const VerificationCodeSender.filled({
    super.key,
    this.name = ScaffoldConstants.kVerificationCodeSenderNameDefault,
    this.interval = ScaffoldConstants.kVerificationCodeSenderIntervalDefault,
    required this.onPressed,
    required this.childBuilder,
    this.lockedChild,
    this.style,
    this.loadLastSendTime,
    this.saveLastSendTime,
  }) : _mode = _Mode.filled;

  const VerificationCodeSender.outlined({
    super.key,
    this.name = ScaffoldConstants.kVerificationCodeSenderNameDefault,
    this.interval = ScaffoldConstants.kVerificationCodeSenderIntervalDefault,
    required this.onPressed,
    required this.childBuilder,
    this.lockedChild,
    this.style,
    this.loadLastSendTime,
    this.saveLastSendTime,
  }) : _mode = _Mode.outlined;

  const VerificationCodeSender.text({
    super.key,
    this.name = ScaffoldConstants.kVerificationCodeSenderNameDefault,
    this.interval = ScaffoldConstants.kVerificationCodeSenderIntervalDefault,
    required this.onPressed,
    required this.childBuilder,
    this.lockedChild,
    this.style,
    this.loadLastSendTime,
    this.saveLastSendTime,
  }) : _mode = _Mode.text;

  @override
  State<StatefulWidget> createState() => _VerificationCodeSenderState();
}

class _VerificationCodeSenderState extends State<VerificationCodeSender> {
  late Timer timer;

  DateTime? lastSendTime;
  int? lockedSeconds;

  @override
  void initState() {
    super.initState();
    (widget.loadLastSendTime ?? defaultLoadLastSendTime).call(widget.name).then((value) {
      lastSendTime = value;
      refreshLockedSecondsThenRebuild();
    });
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      refreshLockedSecondsThenRebuild();
    });
  }

  void refreshLockedSecondsThenRebuild() {
    final localLastSendTime = lastSendTime;
    final localLockedSeconds = lockedSeconds;
    if (localLastSendTime != null) {
      final nowTime = DateTime.now();
      final expiredTime = localLastSendTime.add(Duration(seconds: widget.interval));
      if (nowTime.isBefore(expiredTime)) {
        final newLockedSeconds = expiredTime.difference(nowTime).inSeconds;
        lockedSeconds = newLockedSeconds > 0 ? newLockedSeconds : null;
      } else {
        lockedSeconds = null;
      }
    }
    if (mounted && lockedSeconds != localLockedSeconds) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) => switch (widget._mode) {
        _Mode.elevated => LockableElevatedButton(
            style: widget.style,
            onPressed: newButtonOnPressed(context),
            lockedChild: widget.lockedChild,
            child: widget.childBuilder(context, lockedSeconds),
          ),
        _Mode.filled => LockableFilledButton(
            style: widget.style,
            onPressed: newButtonOnPressed(context),
            lockedChild: widget.lockedChild,
            child: widget.childBuilder(context, lockedSeconds),
          ),
        _Mode.outlined => LockableOutlinedButton(
            style: widget.style,
            onPressed: newButtonOnPressed(context),
            lockedChild: widget.lockedChild,
            child: widget.childBuilder(context, lockedSeconds),
          ),
        _Mode.text => LockableTextButton(
            style: widget.style,
            onPressed: newButtonOnPressed(context),
            lockedChild: widget.lockedChild,
            child: widget.childBuilder(context, lockedSeconds),
          ),
      };

  AsyncCallback? newButtonOnPressed(BuildContext context) => lockedSeconds != null
      ? null
      : () async {
          final nowTime = DateTime.now();
          await widget.onPressed().then((value) async {
            await (widget.saveLastSendTime ?? defaultSaveLastSendTime).call(widget.name, nowTime);
          }).catchError((e) {
            // nothing
          }).whenComplete(() {
            lastSendTime = nowTime;
            refreshLockedSecondsThenRebuild();
          });
        };

  Future<DateTime?> defaultLoadLastSendTime(String name) async {
    final lastSendTime = DefaultPreference.getInt(name);
    if (lastSendTime != null) {
      return DateTime.fromMillisecondsSinceEpoch(lastSendTime);
    }
    return null;
  }

  Future<void> defaultSaveLastSendTime(String name, DateTime dateTime) async {
    await DefaultPreference.setInt(name, dateTime.millisecondsSinceEpoch);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

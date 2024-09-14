import 'dart:async';

import 'package:flutter/material.dart';

import '../../config/scaffold_config.dart';
import '../../internal/scaffold_preference.dart';

class SendCodeWidget extends StatelessWidget {
  final SendCodeController controller;
  final Widget Function(BuildContext context, bool isSending,
      Duration? remainingResendInterval) builder;

  const SendCodeWidget({
    super.key,
    required this.controller,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          if (controller.isInitialized) {
            return builder(context, controller.isSending,
                controller.remainingResendInterval);
          } else {
            return const SizedBox.shrink();
          }
        },
      );
}

class SendCodeController extends ChangeNotifier {
  final String name;
  final Duration resendInterval;
  final Duration callbackInterval;

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  bool _isSending = false;

  bool get isSending => _isSending;

  DateTime? _lastSendTime;

  Duration? get remainingResendInterval {
    final lastSendTime = _lastSendTime;
    if (lastSendTime == null) return null;
    final nowTime = DateTime.now();
    final duration = nowTime.difference(lastSendTime);
    if (duration > resendInterval || duration < Duration.zero) return null;
    return resendInterval - duration;
  }

  Timer? _resendIntervalTimer;

  SendCodeController({
    this.name = ScaffoldConfig.kSendCodeNameDefault,
    this.resendInterval = const Duration(seconds: 60),
    this.callbackInterval = const Duration(seconds: 1),
  }) {
    ScaffoldPreference().getInt(name).then((value) {
      _lastSendTime =
          value != null ? DateTime.fromMillisecondsSinceEpoch(value) : null;
      _isInitialized = true;
      notifyListeners();
      _startResendIntervalTimer();
    }, onError: (e, s) {
      _isInitialized = false;
      notifyListeners();
    });
  }

  Future<T> sendCode<T>(Future<T> future) async {
    try {
      _isSending = true;
      notifyListeners();
      final result = await future;
      final nowTime = DateTime.now();
      _lastSendTime = nowTime;
      ScaffoldPreference()
          .setInt(name, nowTime.millisecondsSinceEpoch)
          .ignore();
      _startResendIntervalTimer();
      return result;
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  void _startResendIntervalTimer() {
    _resendIntervalTimer?.cancel();
    if (_lastSendTime != null) {
      _resendIntervalTimer = Timer.periodic(callbackInterval, (timer) {
        final lastSendTime = _lastSendTime;
        if (lastSendTime != null) {
          final nowTime = DateTime.now();
          final duration = nowTime.difference(lastSendTime);
          if (duration > resendInterval || duration < Duration.zero) {
            timer.cancel();
          }
        } else {
          timer.cancel();
        }
        notifyListeners();
      });
    }
  }

  @override
  void dispose() {
    _resendIntervalTimer?.cancel();
    _resendIntervalTimer = null;
    super.dispose();
  }
}

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../plugin/android/android_toast_plugin.dart';

class Toast {
  static void showShort(BuildContext context, String text) {
    show(context, text, false);
  }

  static void showLong(BuildContext context, String text) {
    show(context, text, true);
  }

  static OverlayEntry? _overlayEntry;
  static Timer? _timer;

  static void show(BuildContext context, String text, bool longDuration) {
    if (Platform.isAndroid) {
      AndroidToastPlugin.show(text: text, longDuration: longDuration).ignore();
    } else {
      _dismissOverlayEntry();
      final overlayEntry = OverlayEntry(builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      });
      Overlay.of(context).insert(overlayEntry);
      _overlayEntry = overlayEntry;
      _timer = Timer(Duration(seconds: longDuration ? 4 : 2), () {
        _dismissOverlayEntry();
      });
    }
  }

  static void _dismissOverlayEntry() {
    _timer?.cancel();
    _timer = null;
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  Toast._();
}

import 'dart:async';

import 'package:flutter/material.dart';

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
    cancel();
    final overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Material(
          type: MaterialType.transparency,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
                child: Text(
                  text,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        );
      },
    );
    Overlay.of(context).insert(overlayEntry);
    _overlayEntry = overlayEntry;
    _timer = Timer(Duration(seconds: longDuration ? 4 : 2), () {
      cancel();
    });
  }

  static void cancel() {
    _timer?.cancel();
    _timer = null;
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  Toast._();
}

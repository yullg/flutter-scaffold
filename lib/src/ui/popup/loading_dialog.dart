import 'dart:math';

import 'package:flutter/material.dart';

enum LoadingDialogMode { circular, linear }

class LoadingDialog {
  final LoadingDialogMode _initialMode;
  final bool _initialBarrierDismissible;
  final double? _initialProgress;
  final String? _initialMessage;

  LoadingDialogMode _mode;
  bool _barrierDismissible;
  final _progressValueNotifier = ValueNotifier<double?>(null);
  final _messageValueNotifier = ValueNotifier<String?>(null);

  LoadingDialog({
    LoadingDialogMode mode = LoadingDialogMode.circular,
    bool barrierDismissible = false,
    double? progress,
    String? message,
  })  : _initialMode = mode,
        _initialBarrierDismissible = barrierDismissible,
        _initialProgress = progress,
        _initialMessage = message,
        _mode = mode,
        _barrierDismissible = barrierDismissible {
    _progressValueNotifier.value = progress;
    _messageValueNotifier.value = message;
  }

  void resetMetadata() {
    _mode = _initialMode;
    _barrierDismissible = _initialBarrierDismissible;
    _progressValueNotifier.value = _initialProgress;
    _messageValueNotifier.value = _initialMessage;
  }

  set mode(LoadingDialogMode value) {
    _mode = value;
  }

  set barrierDismissible(bool value) {
    _barrierDismissible = value;
  }

  set progress(double? value) {
    _progressValueNotifier.value = value;
  }

  set message(String? value) {
    _messageValueNotifier.value = value;
  }

  OverlayEntry? _overlayEntry;

  get isShowing => _overlayEntry != null;

  void show(BuildContext context, {bool rootOverlay = false}) {
    if (isShowing) return;
    final overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            ModalBarrier(
              color: Colors.black54,
              dismissible: _barrierDismissible,
              onDismiss: () => dismiss(),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) => switch (_mode) {
                    LoadingDialogMode.circular => ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 100,
                          minHeight: 100,
                          maxWidth: min(300, constraints.maxWidth),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ValueListenableBuilder<double?>(
                              valueListenable: _progressValueNotifier,
                              builder: (BuildContext context, double? value, Widget? child) {
                                return CircularProgressIndicator(
                                  value: value,
                                  strokeCap: StrokeCap.round,
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                );
                              },
                            ),
                            ValueListenableBuilder<String?>(
                              valueListenable: _messageValueNotifier,
                              builder: (BuildContext context, String? value, Widget? child) {
                                if (value != null) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    LoadingDialogMode.linear => ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 100,
                          minHeight: 100,
                          maxWidth: min(300, constraints.maxWidth),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ValueListenableBuilder<double?>(
                              valueListenable: _progressValueNotifier,
                              builder: (BuildContext context, double? value, Widget? child) {
                                return LinearProgressIndicator(
                                  value: value,
                                  minHeight: 8,
                                  borderRadius: BorderRadius.circular(4),
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                );
                              },
                            ),
                            ValueListenableBuilder<String?>(
                              valueListenable: _messageValueNotifier,
                              builder: (BuildContext context, String? value, Widget? child) {
                                if (value != null) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
    Overlay.of(context, rootOverlay: rootOverlay).insert(overlayEntry);
    _overlayEntry = overlayEntry;
  }

  void dismiss() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  void dispose() {
    dismiss();
    _progressValueNotifier.dispose();
    _messageValueNotifier.dispose();
  }
}

import 'dart:math';

import 'package:flutter/material.dart';

enum LoadingDialogMode { circular, linear }

class LoadingDialog {
  final LoadingDialogMode _initialMode;
  final bool _initialCancelable;
  final double? _initialProgress;
  final String? _initialMessage;

  LoadingDialogMode mode;
  bool cancelable;
  final _progressValueNotifier = ValueNotifier<double?>(null);
  final _messageValueNotifier = ValueNotifier<String?>(null);

  LoadingDialog({this.mode = LoadingDialogMode.circular, this.cancelable = false, double? progress, String? message})
    : _initialMode = mode,
      _initialCancelable = cancelable,
      _initialProgress = progress,
      _initialMessage = message {
    _progressValueNotifier.value = progress;
    _messageValueNotifier.value = message;
  }

  void resetMetadata() {
    mode = _initialMode;
    cancelable = _initialCancelable;
    _progressValueNotifier.value = _initialProgress;
    _messageValueNotifier.value = _initialMessage;
  }

  double? get progress => _progressValueNotifier.value;

  set progress(double? value) {
    _progressValueNotifier.value = value;
  }

  String? get message => _messageValueNotifier.value;

  set message(String? value) {
    _messageValueNotifier.value = value;
  }

  Future<void>? _dialogFuture;
  bool _hasClose = false;

  bool get isShowing => _dialogFuture != null && !_hasClose;

  Future<void> show(BuildContext context) {
    final previousDialogFuture = _dialogFuture;
    if (previousDialogFuture != null) {
      return previousDialogFuture;
    }
    _hasClose = false;
    final dialogFuture = showDialog<void>(
      context: context,
      barrierDismissible: cancelable,
      useRootNavigator: true,
      builder: (context) {
        final theme = Theme.of(context);
        return PopScope(
          canPop: cancelable,
          child: Center(
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: LayoutBuilder(
                  builder:
                      (context, constraints) => switch (mode) {
                        LoadingDialogMode.circular => ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 100,
                            minHeight: 100,
                            maxWidth: min(240, constraints.maxWidth),
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
                                    color: theme.colorScheme.onPrimaryContainer,
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
                                        maxLines: 6,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.onPrimaryContainer,
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
                            maxWidth: min(240, constraints.maxWidth),
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
                                    color: theme.colorScheme.onPrimaryContainer,
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
                                        maxLines: 6,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.onPrimaryContainer,
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
          ),
        );
      },
    ).whenComplete(() {
      _dialogFuture = null;
      _hasClose = false;
    });
    _dialogFuture = dialogFuture;
    return dialogFuture;
  }

  void close(BuildContext context) {
    if (_dialogFuture != null && !_hasClose) {
      Navigator.of(context, rootNavigator: true).pop();
      _hasClose = true;
    }
  }

  void dispose() {
    _progressValueNotifier.dispose();
    _messageValueNotifier.dispose();
  }
}

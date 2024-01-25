import 'package:flutter/material.dart';

enum LoadingDialogMode { circular, linear }

class LoadingDialog {
  LoadingDialogMode _mode;
  bool _cancelable;

  final _progressValueNotifier = ValueNotifier<double?>(null);
  final _messageValueNotifier = ValueNotifier<String?>(null);

  LoadingDialog({
    LoadingDialogMode mode = LoadingDialogMode.circular,
    bool cancelable = false,
    double? progress,
    String? message,
  })  : _mode = mode,
        _cancelable = cancelable {
    _progressValueNotifier.value = progress;
    _messageValueNotifier.value = message;
  }

  void resetMetadata() {
    _mode = LoadingDialogMode.circular;
    _cancelable = false;
    _progressValueNotifier.value = null;
    _messageValueNotifier.value = null;
  }

  set mode(LoadingDialogMode value) {
    _mode = value;
  }

  /// 点击barrier是否会取消对话框。默认为false。
  /// PS: 在[OverlayEntry]中无法使用[PopScope]，因此没有办法响应系统返回手势，此逻辑需要在外部另行处理。
  set cancelable(bool value) {
    _cancelable = value;
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
              dismissible: _cancelable,
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
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 150,
                    minHeight: 150,
                  ),
                  child: switch (_mode) {
                    LoadingDialogMode.circular => Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ValueListenableBuilder<double?>(
                            valueListenable: _progressValueNotifier,
                            builder: (BuildContext context, double? value, Widget? child) {
                              return CircularProgressIndicator(
                                value: value,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              );
                            },
                          ),
                          ValueListenableBuilder<String?>(
                            valueListenable: _messageValueNotifier,
                            builder: (BuildContext context, String? value, Widget? child) {
                              if (value != null) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 32),
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
                    LoadingDialogMode.linear => Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ValueListenableBuilder<double?>(
                            valueListenable: _progressValueNotifier,
                            builder: (BuildContext context, double? value, Widget? child) {
                              return LinearProgressIndicator(
                                value: value,
                                minHeight: 8,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              );
                            },
                          ),
                          ValueListenableBuilder<String?>(
                            valueListenable: _messageValueNotifier,
                            builder: (BuildContext context, String? value, Widget? child) {
                              if (value != null) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 32),
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

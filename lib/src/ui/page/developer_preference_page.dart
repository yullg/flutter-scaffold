import 'package:flutter/material.dart';

import '../../architecture/generic_state.dart';
import '../../config/scaffold_config.dart';
import '../../config/scaffold_developer_option.dart';
import '../../helper/format_helper.dart';
import '../../helper/string_helper.dart';
import '../../internal/scaffold_logger.dart';
import '../../support/preference/developer_preference.dart';
import '../popup/scaffold_messengers.dart';
import '../widget/easy_switch_list_tile.dart';

class DeveloperPreferencePage extends StatefulWidget {
  const DeveloperPreferencePage({super.key});

  @override
  State<StatefulWidget> createState() => _DeveloperPreferenceState();
}

class _DeveloperPreferenceState extends GenericState<DeveloperPreferencePage> {
  @override
  Widget build(BuildContext context) {
    final preferenceFiledList = [
      ...?ScaffoldConfig.developerOption?.preferenceFileds
    ];
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text("Preference"),
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop || defaultLoadingDialog.isShowing) return;
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
        child: preferenceFiledList.isNotEmpty
            ? ListView.builder(
                itemCount: preferenceFiledList.length,
                itemBuilder: (context, index) {
                  final preferenceFiled = preferenceFiledList[index];
                  return _DeveloperPreferenceFieldWidget(preferenceFiled);
                },
              )
            : Center(
                child: Text(
                  "No preference",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
      ),
    );
  }
}

class _DeveloperPreferenceFieldWidget extends StatefulWidget {
  final ScaffoldDOPreferenceFiled preferenceFiled;

  const _DeveloperPreferenceFieldWidget(this.preferenceFiled);

  @override
  State<StatefulWidget> createState() => _DeveloperPreferenceFieldState();
}

class _DeveloperPreferenceFieldState
    extends GenericState<_DeveloperPreferenceFieldWidget> {
  TextEditingController? textEditingController;
  bool? boolFieldValue;

  @override
  void initState() {
    super.initState();
    switch (widget.preferenceFiled.type) {
      case ScaffoldDOPreferenceFiledType.boolField:
        DeveloperPreference().getBool(widget.preferenceFiled.key).then((value) {
          boolFieldValue = value;
          setStateIfMounted();
        }, onError: (e, s) {
          ScaffoldLogger.error(null, e, s);
        });
      case ScaffoldDOPreferenceFiledType.intField:
        textEditingController = TextEditingController();
        DeveloperPreference().getInt(widget.preferenceFiled.key).then((value) {
          if (value != null) {
            textEditingController?.text = value.toString();
          }
        }, onError: (e, s) {
          ScaffoldLogger.error(null, e, s);
        });
      case ScaffoldDOPreferenceFiledType.doubleField:
        textEditingController = TextEditingController();
        DeveloperPreference().getDouble(widget.preferenceFiled.key).then(
            (value) {
          if (value != null) {
            textEditingController?.text = value.toString();
          }
        }, onError: (e, s) {
          ScaffoldLogger.error(null, e, s);
        });
      case ScaffoldDOPreferenceFiledType.stringField:
        textEditingController = TextEditingController();
        DeveloperPreference().getString(widget.preferenceFiled.key).then(
            (value) {
          if (value != null) {
            textEditingController?.text = value;
          }
        }, onError: (e, s) {
          ScaffoldLogger.error(null, e, s);
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.preferenceFiled.type) {
      ScaffoldDOPreferenceFiledType.boolField => EasySwitchListTile(
          titleText: widget.preferenceFiled.name,
          subtitleText: widget.preferenceFiled.description,
          value: boolFieldValue,
          onChanged: (value) {
            DeveloperPreference()
                .setBool(widget.preferenceFiled.key, value)
                .then((_) {
              boolFieldValue = value;
              setStateIfMounted();
              _showSuccessSnackBar();
            }, onError: (e, s) {
              ScaffoldLogger.error(null, e, s);
              _showFailedSnackBar();
            });
          },
        ),
      ScaffoldDOPreferenceFiledType.intField => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: textEditingController,
            textInputAction: TextInputAction.done,
            keyboardType:
                widget.preferenceFiled.keyboardType ?? TextInputType.number,
            decoration: InputDecoration(
              labelText: widget.preferenceFiled.name,
              helperText: widget.preferenceFiled.description,
              helperMaxLines: 999,
            ),
            onSubmitted: (value) {
              final newValue = FormatHelper.tryParseInt(value);
              if (newValue != null) {
                DeveloperPreference()
                    .setInt(widget.preferenceFiled.key, newValue)
                    .then((_) {
                  textEditingController?.text = newValue.toString();
                  _showSuccessSnackBar();
                }, onError: (e, s) {
                  ScaffoldLogger.error(null, e, s);
                  _showFailedSnackBar();
                });
              } else {
                DeveloperPreference().remove(widget.preferenceFiled.key).then(
                    (_) {
                  textEditingController?.clear();
                  _showSuccessSnackBar();
                }, onError: (e, s) {
                  ScaffoldLogger.error(null, e, s);
                  _showFailedSnackBar();
                });
              }
            },
          ),
        ),
      ScaffoldDOPreferenceFiledType.doubleField => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: textEditingController,
            textInputAction: TextInputAction.done,
            keyboardType:
                widget.preferenceFiled.keyboardType ?? TextInputType.number,
            decoration: InputDecoration(
              labelText: widget.preferenceFiled.name,
              helperText: widget.preferenceFiled.description,
              helperMaxLines: 999,
            ),
            onSubmitted: (value) {
              final newValue = FormatHelper.tryParseDouble(value);
              if (newValue != null) {
                DeveloperPreference()
                    .setDouble(widget.preferenceFiled.key, newValue)
                    .then((_) {
                  textEditingController?.text = newValue.toString();
                  _showSuccessSnackBar();
                }, onError: (e, s) {
                  ScaffoldLogger.error(null, e, s);
                  _showFailedSnackBar();
                });
              } else {
                DeveloperPreference().remove(widget.preferenceFiled.key).then(
                    (_) {
                  textEditingController?.clear();
                  _showSuccessSnackBar();
                }, onError: (e, s) {
                  ScaffoldLogger.error(null, e, s);
                  _showFailedSnackBar();
                });
              }
            },
          ),
        ),
      ScaffoldDOPreferenceFiledType.stringField => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: textEditingController,
            textInputAction: TextInputAction.done,
            keyboardType: widget.preferenceFiled.keyboardType,
            decoration: InputDecoration(
              labelText: widget.preferenceFiled.name,
              helperText: widget.preferenceFiled.description,
              helperMaxLines: 999,
            ),
            onSubmitted: (value) {
              final newValue = StringHelper.trimToNull(value);
              if (newValue != null) {
                DeveloperPreference()
                    .setString(widget.preferenceFiled.key, newValue)
                    .then((_) {
                  textEditingController?.text = newValue;
                  _showSuccessSnackBar();
                }, onError: (e, s) {
                  ScaffoldLogger.error(null, e, s);
                  _showFailedSnackBar();
                });
              } else {
                DeveloperPreference().remove(widget.preferenceFiled.key).then(
                    (_) {
                  textEditingController?.clear();
                  _showSuccessSnackBar();
                }, onError: (e, s) {
                  ScaffoldLogger.error(null, e, s);
                  _showFailedSnackBar();
                });
              }
            },
          ),
        ),
    };
  }

  void _showSuccessSnackBar() {
    if (mounted) {
      ScaffoldMessengers.showSnackBar(context,
          contentText: "Operation successful!");
    }
  }

  void _showFailedSnackBar() {
    if (mounted) {
      ScaffoldMessengers.showErrorSnackBar(context,
          message: "Operation failed, please try again!");
    }
  }

  @override
  void dispose() {
    textEditingController?.dispose();
    super.dispose();
  }
}

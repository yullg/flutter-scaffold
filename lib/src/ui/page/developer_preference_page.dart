import 'package:flutter/material.dart';
import 'package:scaffold/src/support/message/message.dart';

import '../../config/scaffold_config.dart';
import '../../config/scaffold_developer_option.dart';
import '../../helper/format_helper.dart';
import '../../helper/string_helper.dart';
import '../../internal/scaffold_logger.dart';
import '../../support/message/messenger.dart';
import '../../support/preference/developer_preference.dart';
import '../popup/alert_dialog.dart';
import '../widget/easy_switch_list_tile.dart';

class DeveloperPreferencePage extends StatefulWidget {
  const DeveloperPreferencePage({super.key});

  @override
  State<StatefulWidget> createState() => _DeveloperPreferenceState();
}

class _DeveloperPreferenceState extends State<DeveloperPreferencePage> {
  @override
  Widget build(BuildContext context) {
    final preferenceFieldList = [...?ScaffoldConfig.developerOption?.preferenceFields];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preference"),
        actions: [
          TextButton.icon(
            onPressed: () {
              showAlertDialog<bool>(
                context: context,
                titleText: "Confirmation",
                contentText: "Are you sure you want to reset all preferences?",
                actions: [
                  AlertDialogAction(value: false, childText: "Cancel"),
                  AlertDialogAction(value: true, childText: "OK", isDestructiveAction: true),
                ],
              ).then((value) {
                if (value != true) return;
                DeveloperPreference().clear().then(
                  (_) {
                    setStateIfMounted();
                    _showSuccessSnackBar();
                  },
                  onError: (e, s) {
                    ScaffoldLogger().error(null, e, s);
                    _showFailedSnackBar();
                  },
                );
              });
            },
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(
                Theme.of(context).appBarTheme.foregroundColor ?? Theme.of(context).colorScheme.onSurface,
              ),
            ),
            icon: const Icon(Icons.cleaning_services),
            label: const Text("Reset"),
          ),
        ],
      ),
      body:
          preferenceFieldList.isNotEmpty
              ? ListView.builder(
                key: UniqueKey(),
                itemCount: preferenceFieldList.length,
                itemBuilder: (context, index) {
                  final preferenceFiled = preferenceFieldList[index];
                  return _DeveloperPreferenceFieldWidget(preferenceFiled);
                },
              )
              : Center(
                child: Text("No preference", style: TextStyle(fontSize: 16, color: Theme.of(context).hintColor)),
              ),
    );
  }

  void setStateIfMounted() {
    if (mounted) {
      setState(() {});
    }
  }
}

class _DeveloperPreferenceFieldWidget extends StatefulWidget {
  final ScaffoldDOPreferenceField preferenceFiled;

  const _DeveloperPreferenceFieldWidget(this.preferenceFiled);

  @override
  State<StatefulWidget> createState() => _DeveloperPreferenceFieldState();
}

class _DeveloperPreferenceFieldState extends State<_DeveloperPreferenceFieldWidget> {
  TextEditingController? textEditingController;
  bool? boolFieldValue;

  @override
  void initState() {
    super.initState();
    switch (widget.preferenceFiled.type) {
      case ScaffoldDOPreferenceFieldType.boolField:
        DeveloperPreference()
            .getBool(widget.preferenceFiled.key)
            .then(
              (value) {
                boolFieldValue = value;
                setStateIfMounted();
              },
              onError: (e, s) {
                ScaffoldLogger().error(null, e, s);
              },
            );
      case ScaffoldDOPreferenceFieldType.intField:
        textEditingController = TextEditingController();
        DeveloperPreference()
            .getInt(widget.preferenceFiled.key)
            .then(
              (value) {
                if (value != null) {
                  textEditingController?.text = value.toString();
                }
              },
              onError: (e, s) {
                ScaffoldLogger().error(null, e, s);
              },
            );
      case ScaffoldDOPreferenceFieldType.doubleField:
        textEditingController = TextEditingController();
        DeveloperPreference()
            .getDouble(widget.preferenceFiled.key)
            .then(
              (value) {
                if (value != null) {
                  textEditingController?.text = value.toString();
                }
              },
              onError: (e, s) {
                ScaffoldLogger().error(null, e, s);
              },
            );
      case ScaffoldDOPreferenceFieldType.stringField:
        textEditingController = TextEditingController();
        DeveloperPreference()
            .getString(widget.preferenceFiled.key)
            .then(
              (value) {
                if (value != null) {
                  textEditingController?.text = value;
                }
              },
              onError: (e, s) {
                ScaffoldLogger().error(null, e, s);
              },
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.preferenceFiled.type) {
      ScaffoldDOPreferenceFieldType.boolField => EasySwitchListTile(
        titleText: widget.preferenceFiled.name,
        subtitleText: widget.preferenceFiled.description,
        value: boolFieldValue,
        onChanged: (value) {
          DeveloperPreference()
              .setBool(widget.preferenceFiled.key, value)
              .then(
                (_) {
                  boolFieldValue = value;
                  setStateIfMounted();
                  _showSuccessSnackBar();
                },
                onError: (e, s) {
                  ScaffoldLogger().error(null, e, s);
                  _showFailedSnackBar();
                },
              );
        },
      ),
      ScaffoldDOPreferenceFieldType.intField => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: textEditingController,
          textInputAction: TextInputAction.done,
          keyboardType: widget.preferenceFiled.keyboardType ?? TextInputType.number,
          decoration: InputDecoration(
            labelText: widget.preferenceFiled.name,
            hintText: widget.preferenceFiled.hintText,
            helperText: widget.preferenceFiled.description,
            helperMaxLines: 999,
          ),
          onSubmitted: (value) {
            final newValue = FormatHelper.tryParseInt(value.trim());
            if (newValue != null) {
              DeveloperPreference()
                  .setInt(widget.preferenceFiled.key, newValue)
                  .then(
                    (_) {
                      textEditingController?.text = newValue.toString();
                      _showSuccessSnackBar();
                    },
                    onError: (e, s) {
                      ScaffoldLogger().error(null, e, s);
                      _showFailedSnackBar();
                    },
                  );
            } else {
              DeveloperPreference()
                  .remove(widget.preferenceFiled.key)
                  .then(
                    (_) {
                      textEditingController?.clear();
                      _showSuccessSnackBar();
                    },
                    onError: (e, s) {
                      ScaffoldLogger().error(null, e, s);
                      _showFailedSnackBar();
                    },
                  );
            }
          },
        ),
      ),
      ScaffoldDOPreferenceFieldType.doubleField => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: textEditingController,
          textInputAction: TextInputAction.done,
          keyboardType: widget.preferenceFiled.keyboardType ?? TextInputType.number,
          decoration: InputDecoration(
            labelText: widget.preferenceFiled.name,
            hintText: widget.preferenceFiled.hintText,
            helperText: widget.preferenceFiled.description,
            helperMaxLines: 999,
          ),
          onSubmitted: (value) {
            final newValue = FormatHelper.tryParseDouble(value.trim());
            if (newValue != null) {
              DeveloperPreference()
                  .setDouble(widget.preferenceFiled.key, newValue)
                  .then(
                    (_) {
                      textEditingController?.text = newValue.toString();
                      _showSuccessSnackBar();
                    },
                    onError: (e, s) {
                      ScaffoldLogger().error(null, e, s);
                      _showFailedSnackBar();
                    },
                  );
            } else {
              DeveloperPreference()
                  .remove(widget.preferenceFiled.key)
                  .then(
                    (_) {
                      textEditingController?.clear();
                      _showSuccessSnackBar();
                    },
                    onError: (e, s) {
                      ScaffoldLogger().error(null, e, s);
                      _showFailedSnackBar();
                    },
                  );
            }
          },
        ),
      ),
      ScaffoldDOPreferenceFieldType.stringField => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: textEditingController,
          textInputAction: TextInputAction.done,
          keyboardType: widget.preferenceFiled.keyboardType,
          decoration: InputDecoration(
            labelText: widget.preferenceFiled.name,
            hintText: widget.preferenceFiled.hintText,
            helperText: widget.preferenceFiled.description,
            helperMaxLines: 999,
          ),
          onSubmitted: (value) {
            final newValue = StringHelper.trimToNull(value);
            if (newValue != null) {
              DeveloperPreference()
                  .setString(widget.preferenceFiled.key, newValue)
                  .then(
                    (_) {
                      textEditingController?.text = newValue;
                      _showSuccessSnackBar();
                    },
                    onError: (e, s) {
                      ScaffoldLogger().error(null, e, s);
                      _showFailedSnackBar();
                    },
                  );
            } else {
              DeveloperPreference()
                  .remove(widget.preferenceFiled.key)
                  .then(
                    (_) {
                      textEditingController?.clear();
                      _showSuccessSnackBar();
                    },
                    onError: (e, s) {
                      ScaffoldLogger().error(null, e, s);
                      _showFailedSnackBar();
                    },
                  );
            }
          },
        ),
      ),
    };
  }

  @override
  void dispose() {
    textEditingController?.dispose();
    super.dispose();
  }

  void setStateIfMounted() {
    if (mounted) {
      setState(() {});
    }
  }
}

extension _ShowSnackBar on State {
  void _showSuccessSnackBar() {
    if (mounted) {
      Messenger.showPlain(context, "Operation successful!");
    }
  }

  void _showFailedSnackBar() {
    if (mounted) {
      Messenger.show(context, PlainMessage.error("Operation failed, please try again!"));
    }
  }
}

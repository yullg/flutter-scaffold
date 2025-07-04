import 'package:flutter/material.dart';
import 'package:scaffold/scaffold_lang.dart';

import '../../config/scaffold_config.dart';
import '../popup/text_input_dialog.dart';
import '../popup/toast.dart';
import '../widget/easy_list_tile.dart';
import 'developer_files_page.dart';
import 'developer_preference_page.dart';

class DeveloperOptionsPage extends StatelessWidget {
  const DeveloperOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Developer options")),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  ListTile.divideTiles(
                    context: context,
                    tiles: [
                      EasyListTile(
                        nameText: "Files",
                        trailingIcon: Icons.arrow_forward_ios,
                        onTap: () {
                          Navigator.push(context, DeveloperFilesPage().route());
                        },
                      ),
                      EasyListTile(
                        nameText: "Preference",
                        trailingIcon: Icons.arrow_forward_ios,
                        onTap: () {
                          Navigator.push(context, DeveloperPreferencePage().route());
                        },
                      ),
                    ],
                  ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  static const int _kMaxPushCount = 7;
  static DateTime? _lastPushTime;
  static int _pushCount = 0;

  static void push(BuildContext context) {
    final lastPushTime = _lastPushTime;
    final nowTime = DateTime.now();
    _lastPushTime = nowTime;
    if (lastPushTime == null || nowTime.difference(lastPushTime).abs() > const Duration(seconds: 1)) {
      _pushCount = 1;
    } else {
      _pushCount++;
    }
    if (_pushCount < 3) return;
    if (_pushCount < _kMaxPushCount) {
      final remainingPushCount = _kMaxPushCount - _pushCount;
      Toast.showShort(
        context,
        remainingPushCount > 1
            ? "You are now $remainingPushCount steps away from entering developer mode."
            : "You are now 1 step away from entering developer mode.",
      );
    } else {
      _pushCount = 0;
      final password = ScaffoldConfig.developerOption?.password;
      if (password != null) {
        showTextInputDialog(
          context: context,
          titleText: "Access Protection",
          messageText: "Accessing this feature requires developer password authentication.",
          fields: [
            TextInputDialogField(
              keyboardType: TextInputType.visiblePassword,
              hintText: "Please enter password",
              maxLength: 256,
            ),
          ],
          actionNoText: "Cancel",
          actionOkText: "Ok",
        ).then((values) {
          if (!context.mounted) return;
          final inputPassword = values?.firstOrNull;
          if (inputPassword == null) return;
          if (password == inputPassword) {
            Navigator.push(context, DeveloperOptionsPage().route());
          } else {
            Toast.showShort(context, "Incorrect password!");
          }
        });
      } else {
        Navigator.push(context, DeveloperOptionsPage().route());
      }
    }
  }
}

import 'package:base/base.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/scaffold_logger.dart';

const _saps_key = "_saps_key";

Future<bool> checkSAPS({required String serviceAgreementUrl, required String privacyStatementUrl}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(_saps_key) ?? false) {
    return true;
  }
  return (await Get.dialog<bool>(
        WillPopScope(
          child: AlertDialog(
            backgroundColor: Colors.white,
            title: Text("服务协议和隐私声明", textAlign: TextAlign.center, style: TextStyle(color: Colors.black)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "请您务必审慎阅读、充分理解“服务协议”和“隐私声明”各条款，包括但不限于为了给您提供服务和保障账号安全，我们会申请相关权限。您可以在“设置”中查看、变更、删除个人信息并管理您的授权。",
                  style: TextStyle(color: Colors.black),
                ),
                Text.rich(
                  TextSpan(
                    text: "您可阅读",
                    children: [
                      TextSpan(
                        text: "《服务协议》",
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(WebViewPage(title: "服务协议", initialUrl: serviceAgreementUrl), preventDuplicates: false);
                          },
                      ),
                      TextSpan(text: "和"),
                      TextSpan(
                        text: "《隐私声明》",
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(WebViewPage(title: "隐私声明", initialUrl: privacyStatementUrl), preventDuplicates: false);
                          },
                      ),
                      TextSpan(text: "了解详细信息。如您同意，请点击“同意并继续”开始接受我们的服务。"),
                    ],
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text("暂不使用"),
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(Colors.grey),
                      ),
                      onPressed: () {
                        Get.back(result: false);
                      },
                    )
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        child: Text("同意并继续"),
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(Colors.black),
                          backgroundColor: MaterialStateProperty.all(Colors.orange),
                        ),
                        onPressed: () async {
                          await prefs.setBool(_saps_key, true).catchError((e, s) {
                            ScaffoldLogger.error(null, e, s);
                          });
                          Get.back(result: true);
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          ),
          onWillPop: () async => false,
        ),
        barrierDismissible: false,
      )) ??
      false;
}

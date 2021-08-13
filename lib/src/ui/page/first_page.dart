import 'package:base/base.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scaffold/src/core/scaffold_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstPage extends StatefulWidget {
  final WidgetBuilder childBuilder;
  final String serviceAgreementUrl;
  final String privacyStatementUrl;
  final Future<void> Function(BuildContext context) killFunction;
  final Future<void> Function(BuildContext context) initializeFunction;
  final String clientName;
  final String clientPlatform;
  final Future<void> Function(BuildContext context) nextFunction;

  FirstPage({
    Key? key,
    required this.childBuilder,
    required this.serviceAgreementUrl,
    required this.privacyStatementUrl,
    required this.killFunction,
    required this.initializeFunction,
    required this.clientName,
    required this.clientPlatform,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      bool agreed = await _checkServiceAgreementAndPrivacyStatement(
          serviceAgreementUrl: widget.serviceAgreementUrl, privacyStatementUrl: widget.privacyStatementUrl);
      if (!agreed) {
        ToastLayer.show("客户端授权失败");
        await widget.killFunction(context);
        return;
      }
      try {
        await widget.initializeFunction(context);
      } catch (e) {
        ToastLayer.show("客户端初始化失败");
        await widget.killFunction(context);
        return;
      }
    }).catchError((e, s) {
      ScaffoldLogger.fatal("Application launch failed", e, s);
      ToastLayer.show("客户端启动失败");
      widget.killFunction(context);
    });
  }

  @override
  Widget build(BuildContext context) => widget.childBuilder(context);

  @override
  void dispose() {
    super.dispose();
  }
}

const _service_agreement_and_privacy_statement_key = "_service_agreement_and_privacy_statement_key";

Future<bool> _checkServiceAgreementAndPrivacyStatement({required String serviceAgreementUrl, required String privacyStatementUrl}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(_service_agreement_and_privacy_statement_key) ?? false) {
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
                            Get.to(WebViewPage(title: "服务协议", initialUrl: serviceAgreementUrl));
                          },
                      ),
                      TextSpan(text: "和"),
                      TextSpan(
                        text: "《隐私声明》",
                        style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(WebViewPage(title: "隐私声明", initialUrl: privacyStatementUrl));
                          },
                      ),
                      TextSpan(text: "了解详细信息。如您同意，请点击“同意并继续”开始接受我们的服务。"),
                    ],
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 20),
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
                        onPressed: () {
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

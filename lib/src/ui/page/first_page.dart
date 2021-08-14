import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../bll/client_configuration_service.dart';
import '../../core/scaffold_logger.dart';
import '../check_saps.dart';
import '../check_update.dart';

class FirstPage extends StatefulWidget {
  final WidgetBuilder childBuilder;
  final String serviceAgreementUrl;
  final String privacyStatementUrl;
  final Future<void> Function(BuildContext context) killFunction;
  final Future<void> Function(BuildContext context) initializeFunction;
  final String clientName;
  final Future<void> Function(BuildContext context) nextFunction;

  FirstPage({
    Key? key,
    required this.childBuilder,
    required this.serviceAgreementUrl,
    required this.privacyStatementUrl,
    required this.killFunction,
    required this.initializeFunction,
    required this.clientName,
    required this.nextFunction,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (!await checkSAPS(serviceAgreementUrl: widget.serviceAgreementUrl, privacyStatementUrl: widget.privacyStatementUrl)) {
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
      try {
        await checkUpdate(clientName: widget.clientName, showLoadingDialog: false);
      } catch (e) {
        ToastLayer.show("客户端版本检查失败");
        await widget.killFunction(context);
        return;
      }
      try {
        await ClientConfigurationService.loadClientConfiguration(name: widget.clientName);
      } catch (e) {
        ToastLayer.show("客户端配置信息加载失败");
        await widget.killFunction(context);
        return;
      }
      await widget.nextFunction(context);
    }).catchError((e, s) {
      ScaffoldLogger.fatal("Application launch failed", e, s);
      ToastLayer.show("客户端启动失败");
      widget.killFunction(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LimitExitWidget(
          onExitCallback: () async => false,
          child: Stack(
            children: [
              widget.childBuilder(context),
              Positioned(
                top: 0,
                right: 0,
                child: SafeArea(
                  child: Container(
                    margin: EdgeInsets.only(top: 15, right: 15),
                    padding: EdgeInsets.fromLTRB(12, 3, 12, 5),
                    decoration: ShapeDecoration(color: Colors.grey, shape: StadiumBorder()),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(strokeWidth: 1),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "正在加载，请稍候...",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

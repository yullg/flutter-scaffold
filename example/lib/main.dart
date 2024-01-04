import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scaffold/scaffold.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends BaseState<MyApp, _MyAppViewModel> {
  final _documents = <String>[];

  @override
  _MyAppViewModel newViewModel() => _MyAppViewModel(this);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: FutureWidget<void>(
          future: viewModel.asyncInitializeFuture,
          waitingWidgetBuilder: (context) => const Center(child: CircularProgressIndicator()),
          builder: (context, _) => ListView(
            children: <Widget>[
              _buildHeader("DocumentManagerPlugin"),
              EasyListTile(
                nameText: "import()",
                onTap: () {
                  DocumentManagerPlugin.import().then((paths) {
                    _documents.clear();
                    _documents.addAll(paths);
                    setStateIfMounted();
                  }, onError: (e, s) {
                    DefaultLogger.error("import() > failed", e, s);
                    ToastHelper.showLong("import() > $e");
                  });
                },
              ),
              if (_documents.isNotEmpty) _buildDivider(),
              if (_documents.isNotEmpty)
                EasyListTile(
                  nameText: "export()",
                  onTap: () {
                    DocumentManagerPlugin.export(
                      documentType: DocumentType.all,
                      path: _documents.first,
                      name: "document-export",
                    ).then((value) {
                      _documents.clear();
                      ToastHelper.showLong("export() > $value");
                      setStateIfMounted();
                    }, onError: (e, s) {
                      DefaultLogger.error("export() > failed", e, s);
                      ToastHelper.showLong("export() > $e");
                    });
                  },
                ),
              if (_documents.isNotEmpty) _buildDivider(),
              for (var i = 0; i < _documents.length; i++)
                EasyListTile(
                  leading: Text(
                    "${i + 1}",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  nameText: _documents[i],
                ),
              _buildHeader("SystemClockPlugin"),
              EasyListTile(
                nameText: "elapsedRealtime()",
                descriptionText: "Returns duration since boot, including time spent in sleep.",
                onTap: () {
                  SystemClockPlugin.elapsedRealtime().then((value) {
                    DefaultLogger.info(
                        "elapsedRealtime() > ${value.inHours}h${value.inMinutes % 60}m${value.inSeconds % 60}s");
                    ToastHelper.showLong(
                        "elapsedRealtime() > ${value.inHours}h${value.inMinutes % 60}m${value.inSeconds % 60}s");
                  }, onError: (e, s) {
                    DefaultLogger.error("elapsedRealtime() > failed", e, s);
                    ToastHelper.showLong("elapsedRealtime() > $e");
                  });
                },
              ),
              _buildDivider(),
              EasyListTile(
                nameText: "uptime()",
                descriptionText: "Returns duration since boot, not counting time spent in deep sleep.",
                onTap: () {
                  SystemClockPlugin.uptime().then((value) {
                    DefaultLogger.info("uptime() > ${value.inHours}h${value.inMinutes % 60}m${value.inSeconds % 60}s");
                    ToastHelper.showLong(
                        "uptime() > ${value.inHours}h${value.inMinutes % 60}m${value.inSeconds % 60}s");
                  }, onError: (e, s) {
                    DefaultLogger.error("uptime() > failed", e, s);
                    ToastHelper.showLong("uptime() > $e");
                  });
                },
              ),
              if (Platform.isAndroid)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader("AndroidDomainVerificationPlugin"),
                    EasyListTile(
                      nameText: "isLinkHandlingAllowed()",
                      onTap: () {
                        AndroidDomainVerificationPlugin.isLinkHandlingAllowed().then((value) {
                          DefaultLogger.info("isLinkHandlingAllowed() > $value");
                          ToastHelper.showLong("isLinkHandlingAllowed() > $value");
                        }, onError: (e, s) {
                          DefaultLogger.error("isLinkHandlingAllowed() > failed", e, s);
                          ToastHelper.showLong("isLinkHandlingAllowed() > $e");
                        });
                      },
                    ),
                    _buildDivider(),
                    EasyListTile(
                      nameText: "getHostToStateMap()",
                      onTap: () {
                        AndroidDomainVerificationPlugin.getHostToStateMap().then((value) {
                          DefaultLogger.info("getHostToStateMap() > $value");
                          ToastHelper.showLong("getHostToStateMap() > $value");
                        }, onError: (e, s) {
                          DefaultLogger.error("getHostToStateMap() > failed", e, s);
                          ToastHelper.showLong("getHostToStateMap() > $e");
                        });
                      },
                    ),
                    _buildDivider(),
                    EasyListTile(
                      nameText: "toSettings()",
                      onTap: () {
                        AndroidDomainVerificationPlugin.toSettings().then((_) {
                          ToastHelper.showLong("toSettings() > success");
                        }, onError: (e, s) {
                          DefaultLogger.error("toSettings() > failed", e, s);
                          ToastHelper.showLong("toSettings() > $e");
                        });
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String name) => Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.surfaceVariant,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );

  Widget _buildDivider() => const Divider(height: 1);
}

class _MyAppViewModel extends BaseViewModel<MyApp> {
  _MyAppViewModel(super.state);

  @override
  Future<void> asyncInitialize() async {
    await super.asyncInitialize();
    if (!mounted) throw ContextUnmountedError();
    await ScaffoldModule.initialize(
      context,
      config: ScaffoldConfig(
        loggerConsoleAppenderEnabled: true,
      ),
    );
  }
}

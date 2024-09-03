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
  Uri? _treeUri;
  Uri? _subTreeUri;
  final _documents = <File>[];

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
          future: asyncInitializeFuture,
          waitingBuilder: (context) =>
              const Center(child: CircularProgressIndicator()),
          builder: (context, _) => ListView(
            children: <Widget>[
              _buildHeader("DocumentManagerPlugin"),
              EasyListTile(
                nameText: "openDocumentTree()",
                descriptionText: _treeUri?.toString(),
                onTap: () {
                  DocumentManagerPlugin.openDocumentTree(
                          initialLocation: _treeUri)
                      .then((value) {
                    setState(() {
                      _treeUri = value;
                    });
                  });
                },
              ),
              EasyListTile(
                nameText: "createSubTreeUri()",
                descriptionText: _subTreeUri?.toString(),
                onTap: () {
                  final treeUri = _treeUri;
                  if (treeUri == null) {
                    showToast("First open a document tree");
                    return;
                  }
                  DocumentManagerPlugin.createSubTreeUri(
                          treeUri: treeUri, displayName: "TEST")
                      .then((value) {
                    setState(() {
                      _subTreeUri = value;
                    });
                  });
                },
              ),
              EasyListTile(
                nameText: "import()",
                onTap: () {
                  DocumentManagerPlugin.import(
                    allowsMultipleSelection: true,
                  ).then((files) {
                    _documents.clear();
                    _documents.addAll(files);
                    setStateIfMounted();
                  }, onError: (e, s) {
                    DefaultLogger.error("import() > failed", e, s);
                    showToast("import() > $e");
                  });
                },
              ),
              if (_documents.isNotEmpty) _buildDivider(),
              if (_documents.isNotEmpty)
                EasyListTile(
                  nameText: "export()",
                  onTap: () {
                    DocumentManagerPlugin.export(
                      files: _documents,
                    ).then((value) {
                      _documents.clear();
                      showToast("export() > $value");
                      setStateIfMounted();
                    }, onError: (e, s) {
                      DefaultLogger.error("export() > failed", e, s);
                      showToast("export() > $e");
                    });
                  },
                ),
              if (_documents.isNotEmpty) _buildDivider(),
              for (var i = 0; i < _documents.length; i++)
                EasyListTile(
                  leading: Text(
                    "${i + 1}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  nameText: _documents[i].path,
                ),
              _buildHeader("GallerySavePlugin"),
              EasyListTile(
                nameText: "saveImage()",
                onTap: () {
                  GallerySavePlugin.requestSavePermission().then((value) {
                    if (value) {
                      GallerySavePlugin.saveImage(_documents.first).then((_) {
                        showToast("saveImage() > success");
                        setStateIfMounted();
                      }, onError: (e, s) {
                        DefaultLogger.error("saveImage() > failed", e, s);
                        showToast("saveImage() > $e");
                      });
                    } else {
                      showToast("no permission");
                    }
                  }, onError: (e, s) {
                    DefaultLogger.error("saveImage() > failed", e, s);
                    showToast("saveImage() > $e");
                  });
                },
              ),
              EasyListTile(
                nameText: "saveVideo()",
                onTap: () {
                  GallerySavePlugin.requestSavePermission().then((value) {
                    if (value) {
                      GallerySavePlugin.saveVideo(_documents.first).then((_) {
                        showToast("saveVideo() > success");
                        setStateIfMounted();
                      }, onError: (e, s) {
                        DefaultLogger.error("saveVideo() > failed", e, s);
                        showToast("saveVideo() > $e");
                      });
                    } else {
                      showToast("no permission");
                    }
                  }, onError: (e, s) {
                    DefaultLogger.error("saveVideo() > failed", e, s);
                    showToast("saveVideo() > $e");
                  });
                },
              ),
              _buildHeader("SystemClockPlugin"),
              EasyListTile(
                nameText: "elapsedRealtime()",
                descriptionText:
                    "Returns duration since boot, including time spent in sleep.",
                onTap: () {
                  SystemClockPlugin.elapsedRealtime().then((value) {
                    DefaultLogger.info(
                        "elapsedRealtime() > ${value.inHours}h${value.inMinutes % 60}m${value.inSeconds % 60}s");
                    showToast(
                        "elapsedRealtime() > ${value.inHours}h${value.inMinutes % 60}m${value.inSeconds % 60}s");
                  }, onError: (e, s) {
                    DefaultLogger.error("elapsedRealtime() > failed", e, s);
                    showToast("elapsedRealtime() > $e");
                  });
                },
              ),
              _buildDivider(),
              EasyListTile(
                nameText: "uptime()",
                descriptionText:
                    "Returns duration since boot, not counting time spent in deep sleep.",
                onTap: () {
                  SystemClockPlugin.uptime().then((value) {
                    DefaultLogger.info(
                        "uptime() > ${value.inHours}h${value.inMinutes % 60}m${value.inSeconds % 60}s");
                    showToast(
                        "uptime() > ${value.inHours}h${value.inMinutes % 60}m${value.inSeconds % 60}s");
                  }, onError: (e, s) {
                    DefaultLogger.error("uptime() > failed", e, s);
                    showToast("uptime() > $e");
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
                        AndroidDomainVerificationPlugin.isLinkHandlingAllowed()
                            .then((value) {
                          DefaultLogger.info(
                              "isLinkHandlingAllowed() > $value");
                          showToast("isLinkHandlingAllowed() > $value");
                        }, onError: (e, s) {
                          DefaultLogger.error(
                              "isLinkHandlingAllowed() > failed", e, s);
                          showToast("isLinkHandlingAllowed() > $e");
                        });
                      },
                    ),
                    _buildDivider(),
                    EasyListTile(
                      nameText: "getHostToStateMap()",
                      onTap: () {
                        AndroidDomainVerificationPlugin.getHostToStateMap()
                            .then((value) {
                          DefaultLogger.info("getHostToStateMap() > $value");
                          showToast("getHostToStateMap() > $value");
                        }, onError: (e, s) {
                          DefaultLogger.error(
                              "getHostToStateMap() > failed", e, s);
                          showToast("getHostToStateMap() > $e");
                        });
                      },
                    ),
                    _buildDivider(),
                    EasyListTile(
                      nameText: "toSettings()",
                      onTap: () {
                        AndroidDomainVerificationPlugin.toSettings().then((_) {
                          showToast("toSettings() > success");
                        }, onError: (e, s) {
                          DefaultLogger.error("toSettings() > failed", e, s);
                          showToast("toSettings() > $e");
                        });
                      },
                    ),
                  ],
                ),
              _buildHeader("AndroidDownloadPlugin"),
              EasyListTile(
                nameText: "download()",
                onTap: () {
                  defaultLoadingDialog.resetMetadata();
                  defaultLoadingDialog.show(context);
                  AndroidDownloadPlugin.enqueue(
                    uri: Uri.parse(
                        "https://www.pexels.com/download/video/27935830/"),
                    destination:
                        AndroidDownloadPlugin.kDestinationExternalPublicDir,
                    filename: "example.mp4",
                    description: "Test file download",
                  ).then((downloadId) {
                    int i = 0;
                    AndroidDownloadPlugin.waitDownload(downloadId,
                        interval: const Duration(milliseconds: 256),
                        onProgress: (downloadInfo) {
                      final totalSize = downloadInfo.totalSize;
                      final bytesSoFar = downloadInfo.bytesSoFar;
                      if (totalSize != null &&
                          totalSize > 0 &&
                          bytesSoFar != null &&
                          bytesSoFar > 0) {
                        defaultLoadingDialog.progress = bytesSoFar / totalSize;
                      }
                      defaultLoadingDialog.message = "${++i} -> $downloadInfo";
                    }).then((value) {
                      defaultLoadingDialog.dismiss();
                      DefaultLogger.info("download() > $value");
                      showToast("download() > $value");
                    }, onError: (e) {
                      defaultLoadingDialog.dismiss();
                    });
                  }, onError: (e) {
                    defaultLoadingDialog.dismiss();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String name) => Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
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

  void showToast(String message) {
    Toast.showLong(context, message);
  }
}

class _MyAppViewModel extends BaseViewModel<MyApp> {
  _MyAppViewModel(super.state);
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../architecture/generic_state.dart';
import '../../helper/format_helper.dart';
import '../../plugin/document_manager_plugin.dart';
import '../popup/scaffold_messengers.dart';
import '../widget/easy_list_tile.dart';
import '../widget/future_widget.dart';

class DeveloperFilesPage extends StatefulWidget {
  const DeveloperFilesPage({super.key});

  @override
  State<StatefulWidget> createState() => _DeveloperFilesState();
}

class _DeveloperFilesState extends GenericState<DeveloperFilesPage> {
  final _directoryStack = <Directory>[];

  void _pushDirectory(Directory directory) {
    _directoryStack.add(directory);
    setStateIfMounted();
  }

  void _asyncPushDirectory(
      BuildContext context, Future<Directory?> directoryFuture) {
    defaultLoadingDialog.resetMetadata();
    defaultLoadingDialog.show(context);
    directoryFuture.then((value) {
      defaultLoadingDialog.dismiss();
      if (value != null) {
        _pushDirectory(value);
      } else {
        if (context.mounted) {
          ScaffoldMessengers.showErrorSnackBar(context,
              message: "Directory does not exist!");
        }
      }
    }, onError: (e) {
      defaultLoadingDialog.dismiss();
      if (context.mounted) {
        ScaffoldMessengers.showErrorSnackBar(context,
            message: "Operation failed, please try again!");
      }
    });
  }

  void _back() {
    if (_directoryStack.isNotEmpty) {
      _directoryStack.removeLast();
      setStateIfMounted();
    } else if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final directory = _directoryStack.lastOrNull;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: _back),
        title: Text(directory != null ? p.basename(directory.path) : "Files"),
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop || defaultLoadingDialog.isShowing) return;
          _back();
        },
        child: directory == null
            ? _buildRootBody(context)
            : _buildBody(context, directory),
      ),
    );
  }

  Widget _buildRootBody(BuildContext context) {
    final rootDirectoryWidgets = <Widget>[];
    if (Platform.isAndroid) {
      rootDirectoryWidgets.add(EasyListTile(
        nameText: "Internal Storage",
        trailingIcon: Icons.arrow_forward_ios,
        onTap: () {
          _asyncPushDirectory(context,
              getApplicationSupportDirectory().then((value) => value.parent));
        },
      ));
      rootDirectoryWidgets.add(EasyListTile(
        nameText: "External Storage",
        trailingIcon: Icons.arrow_forward_ios,
        onTap: () {
          _asyncPushDirectory(context,
              getExternalStorageDirectory().then((value) => value?.parent));
        },
      ));
    } else if (Platform.isIOS || Platform.isMacOS) {
      rootDirectoryWidgets.add(EasyListTile(
        nameText: "Documents",
        trailingIcon: Icons.arrow_forward_ios,
        onTap: () {
          _asyncPushDirectory(context, getApplicationDocumentsDirectory());
        },
      ));
      rootDirectoryWidgets.add(EasyListTile(
        nameText: "Application Support",
        trailingIcon: Icons.arrow_forward_ios,
        onTap: () {
          _asyncPushDirectory(context, getApplicationSupportDirectory());
        },
      ));
      rootDirectoryWidgets.add(EasyListTile(
        nameText: "Application Caches",
        trailingIcon: Icons.arrow_forward_ios,
        onTap: () {
          _asyncPushDirectory(context, getApplicationCacheDirectory());
        },
      ));
    }
    return ListView(
      children: ListTile.divideTiles(
        context: context,
        tiles: rootDirectoryWidgets,
      ).toList(),
    );
  }

  Widget _buildBody(BuildContext context, Directory directory) {
    return FutureWidget<List<FileSystemEntity>>(
      future: () async {
        final entities = <FileSystemEntity>[];
        await for (final entity
            in directory.list(recursive: false, followLinks: false)) {
          entities.add(entity);
        }
        return entities;
      }(),
      waitingBuilder: (context) =>
          const Center(child: CircularProgressIndicator()),
      builder: (context, entities) {
        if (entities.isNotEmpty) {
          return ListView.separated(
            itemCount: entities.length,
            itemBuilder: (context, index) {
              final entity = entities[index];
              if (entity is Directory) {
                return EasyListTile(
                  leadingIcon: Icons.folder_outlined,
                  nameText: p.basename(entity.path),
                  onTap: () {
                    _pushDirectory(entity);
                  },
                );
              } else if (entity is File) {
                return EasyListTile(
                  leadingIcon: Icons.description_outlined,
                  nameText: p.basename(entity.path),
                  description:
                      FutureWidget<({int length, DateTime lastModified})>(
                    future: () async {
                      final length = await entity.length();
                      final lastModified = await entity.lastModified();
                      return (length: length, lastModified: lastModified);
                    }(),
                    builder: (context, data) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDateTime(data.lastModified)),
                        Text(_formatBytes(data.length)),
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      DocumentManagerPlugin.export(
                        files: <File>[entity],
                      ).then((_) {
                        if (context.mounted) {
                          ScaffoldMessengers.showSnackBar(context,
                              contentText: "File downloaded successfully!");
                        }
                      }, onError: (e) {
                        if (context.mounted) {
                          ScaffoldMessengers.showErrorSnackBar(context,
                              message: "Operation failed, please try again!");
                        }
                      });
                    },
                    icon: const Icon(Icons.download_outlined),
                  ),
                );
              } else {
                return EasyListTile(
                  leadingIcon: Icons.help_center_outlined,
                  nameText: p.basename(entity.path),
                );
              }
            },
            separatorBuilder: (context, index) => const Divider(),
          );
        } else {
          return Center(
            child: Text(
              "No files",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).hintColor,
              ),
            ),
          );
        }
      },
    );
  }
}

String _formatDateTime(DateTime time) =>
    "${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";

String _formatBytes(int bytes) {
  const int kB = 1024;
  const int mB = 1024 * kB;
  const int gB = 1024 * mB;
  if (bytes < kB) {
    return '$bytes B';
  } else if (bytes < mB) {
    return '${FormatHelper.printNum(bytes / kB, maxFractionDigits: 2)} KB';
  } else if (bytes < gB) {
    return '${FormatHelper.printNum(bytes / mB, maxFractionDigits: 2)} MB';
  } else {
    return '${FormatHelper.printNum(bytes / gB, maxFractionDigits: 2)} GB';
  }
}

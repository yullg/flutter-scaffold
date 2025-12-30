import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:scaffold/scaffold_sugar.dart';
import 'package:scaffold/src/support/message/message.dart';

import '../../helper/format_helper.dart';
import '../../internal/scaffold_logger.dart';
import '../../plugin/document_manager_plugin.dart';
import '../../support/message/messenger.dart';
import '../widget/easy_list_tile.dart';

class DeveloperFilesPage extends StatefulWidget {
  const DeveloperFilesPage({super.key});

  @override
  State<StatefulWidget> createState() => _DeveloperFilesState();
}

class _DeveloperFilesState extends State<DeveloperFilesPage> {
  final _directoryStack = <_DirectoryWrapper>[];
  final _entities = <_FileSystemEntityWrapper>[];
  final _selectedFiles = <_FileWrapper>[];

  @override
  void initState() {
    super.initState();
    _refreshEntities().ignore();
  }

  Future<void> _back() async {
    if (_directoryStack.isNotEmpty) {
      _directoryStack.removeLast();
      await _refreshEntities();
    } else if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  void _enterDirectory(_DirectoryWrapper directoryWrapper) {
    _directoryStack.add(directoryWrapper);
    _refreshEntities().ignore();
  }

  Future<void> _refreshEntities() async {
    try {
      _entities.clear();
      final directory = _directoryStack.lastOrNull?.entity;
      final entities = <_FileSystemEntityWrapper>[];
      if (directory != null) {
        await for (final entity in directory.list(recursive: false, followLinks: false)) {
          if (entity is Directory) {
            entities.add(_DirectoryWrapper(entity: entity, name: p.basename(entity.path)));
          } else if (entity is File) {
            entities.add(
              _FileWrapper(
                entity: entity,
                name: p.basename(entity.path),
                length: await entity.length().catchErrorToNull(),
                lastModified: await entity.lastModified().catchErrorToNull(),
              ),
            );
          } else {
            entities.add(_FileSystemEntityWrapper(entity: entity, name: p.basename(entity.path)));
          }
        }
      } else {
        if (Platform.isAndroid) {
          entities.add(
            _DirectoryWrapper(
              entity: await getApplicationSupportDirectory().then((value) => value.parent),
              name: "Internal Storage",
            ),
          );
          final externalStorageDirectory = await getExternalStorageDirectory().then((value) => value?.parent);
          if (externalStorageDirectory != null) {
            entities.add(_DirectoryWrapper(entity: externalStorageDirectory, name: "External Storage"));
          }
        } else if (Platform.isIOS || Platform.isMacOS) {
          entities.add(
            _DirectoryWrapper(entity: await getApplicationDocumentsDirectory(), name: "Application Documents"),
          );
          entities.add(_DirectoryWrapper(entity: await getApplicationSupportDirectory(), name: "Application Support"));
          entities.add(_DirectoryWrapper(entity: await getApplicationCacheDirectory(), name: "Application Caches"));
        }
      }
      _entities.addAll(entities);
    } catch (e, s) {
      ScaffoldLogger().error(null, e, s);
      rethrow;
    } finally {
      setStateIfMounted();
    }
  }

  void _toggleSelectedFile(_FileWrapper fileWrapper) {
    if (_selectedFiles.contains(fileWrapper)) {
      _selectedFiles.remove(fileWrapper);
    } else {
      _selectedFiles.add(fileWrapper);
    }
    setStateIfMounted();
  }

  void _clearSelectedFiles() {
    _selectedFiles.clear();
    setStateIfMounted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => _back().ignore),
        title: Text(_directoryStack.lastOrNull?.name ?? "Files"),
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          _back().ignore();
        },
        child:
            _entities.isNotEmpty
                ? ListView.separated(
                  itemCount: _entities.length,
                  itemBuilder: (context, index) {
                    final entity = _entities[index];
                    if (entity is _DirectoryWrapper) {
                      return EasyListTile(
                        leadingIcon: Icons.folder_outlined,
                        nameText: entity.name,
                        onTap: () => _enterDirectory(entity),
                      );
                    } else if (entity is _FileWrapper) {
                      return EasyListTile(
                        leadingIcon: Icons.description_outlined,
                        nameText: entity.name,
                        description: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text(_formatDateTime(entity.lastModified)), Text(_formatBytes(entity.length))],
                        ),
                        trailing:
                            _selectedFiles.isEmpty
                                ? IconButton(
                                  onPressed: () {
                                    _export([entity]).then(
                                      (value) {
                                        if (value) {
                                          _showSuccessSnackBar();
                                        }
                                      },
                                      onError: (_) {
                                        _showFailedSnackBar();
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.download_outlined),
                                )
                                : Icon(
                                  _selectedFiles.contains(entity)
                                      ? Icons.check_box_outlined
                                      : Icons.check_box_outline_blank,
                                ),
                        onTap: _selectedFiles.isNotEmpty ? () => _toggleSelectedFile(entity) : null,
                        onLongPress: () => _toggleSelectedFile(entity),
                      );
                    } else {
                      return EasyListTile(leadingIcon: Icons.help_center_outlined, nameText: entity.name);
                    }
                  },
                  separatorBuilder: (context, index) => const Divider(height: 0),
                )
                : Center(child: Text("No files", style: TextStyle(fontSize: 16, color: Theme.of(context).hintColor))),
      ),
      bottomNavigationBar: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child:
            _selectedFiles.isNotEmpty
                ? Container(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 6, 16, 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${_selectedFiles.length} selected",
                          style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _export(_selectedFiles).then(
                            (value) {
                              if (value) {
                                _clearSelectedFiles();
                                _showSuccessSnackBar();
                              }
                            },
                            onError: (_) {
                              _showFailedSnackBar();
                            },
                          );
                        },
                        icon: const Icon(Icons.download_outlined),
                        tooltip: "Download",
                      ),
                      IconButton(
                        onPressed: () => _clearSelectedFiles(),
                        icon: const Icon(Icons.clear),
                        tooltip: "Cancel",
                      ),
                    ],
                  ),
                )
                : const SizedBox.shrink(),
      ),
    );
  }

  Future<bool> _export(List<_FileWrapper> fileWrappers) async {
    try {
      final files = fileWrappers.map((e) => e.entity).toList();
      final uris = await DocumentManagerPlugin.export(files: files);
      return uris.isNotEmpty;
    } catch (e, s) {
      ScaffoldLogger().error(null, e, s);
      rethrow;
    }
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

String _formatDateTime(DateTime? time) {
  if (time == null) return "unknown";
  return "${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
}

String _formatBytes(int? bytes) {
  if (bytes == null) return "unknown";
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

class _FileSystemEntityWrapper<T extends FileSystemEntity> {
  final T entity;
  final String name;

  _FileSystemEntityWrapper({required this.entity, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _FileSystemEntityWrapper &&
          runtimeType == other.runtimeType &&
          entity.absolute.path == other.entity.absolute.path;

  @override
  int get hashCode => entity.absolute.path.hashCode;
}

class _DirectoryWrapper extends _FileSystemEntityWrapper<Directory> {
  _DirectoryWrapper({required super.entity, required super.name});
}

class _FileWrapper extends _FileSystemEntityWrapper<File> {
  final int? length;
  final DateTime? lastModified;

  _FileWrapper({required super.entity, required super.name, this.length, this.lastModified});
}

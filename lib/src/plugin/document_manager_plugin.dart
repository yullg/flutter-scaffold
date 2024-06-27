import 'dart:io';

import 'package:path/path.dart' as p;

import '../helper/string_helper.dart';
import '../helper/uuid_helper.dart';
import '../lang/extensions.dart';
import '../scaffold_constants.dart';
import '../support/storage/storage_type.dart';
import 'android/android_activity_result_contracts_plugin.dart';
import 'android/android_content_resolver_plugin.dart';
import 'ios/ios_document_picker_plugin.dart';
import 'ios/ios_file_manager_plugin.dart';
import 'ios/ios_url_plugin.dart';

class DocumentManagerPlugin {
  static Future<Uri?> openDocumentTree({
    Uri? initialLocation,
  }) {
    if (Platform.isAndroid) {
      return AndroidActivityResultContractsPlugin.openDocumentTree(
        initialLocation: initialLocation,
      );
    } else {
      return IosDocumentPickerPlugin.import(
        forOpeningContentTypes: <String>["public.folder"],
        asCopy: false,
        directoryURL: initialLocation,
        allowsMultipleSelection: false,
        shouldShowFileExtensions: true,
      ).then((value) => value.firstOrNull);
    }
  }

  static Future<List<File>> import({
    List<DocumentType> documentTypes = const [DocumentType.all],
    bool allowsMultipleSelection = false,
  }) async {
    if (Platform.isAndroid) {
      final uris = allowsMultipleSelection
          ? await AndroidActivityResultContractsPlugin.openMultipleDocuments(
              mimeTypes: documentTypes.map((e) => e.mimeType).toList(),
            )
          : await AndroidActivityResultContractsPlugin.openDocument(
              mimeTypes: documentTypes.map((e) => e.mimeType).toList(),
            ).then((value) => [if (value != null) value]);
      final files = <File>[];
      final cacheDirectoryPath = (await StorageType.cache.directory).path;
      for (final uri in uris) {
        final contentUriMetadata = await AndroidContentResolverPlugin.getMetadata(uri);
        final path = p.join(
          cacheDirectoryPath,
          ScaffoldConstants.kDocumentManagerDirectory,
          UuidHelper.v4(),
          StringHelper.trimToNull(contentUriMetadata.displayName) ?? UuidHelper.v4(),
        );
        final file = File(path);
        await AndroidContentResolverPlugin.copyContentUriToFile(
          contentUri: uri,
          file: file,
        );
        files.add(file);
      }
      return files;
    } else {
      final uris = await IosDocumentPickerPlugin.import(
        forOpeningContentTypes: documentTypes.map((e) => e.utType).toList(growable: false),
        asCopy: false,
        allowsMultipleSelection: allowsMultipleSelection,
        shouldShowFileExtensions: true,
      );
      final files = <File>[];
      final cacheDirectoryPath = (await StorageType.cache.directory).path;
      for (final uri in uris) {
        final path = p.join(
          cacheDirectoryPath,
          ScaffoldConstants.kDocumentManagerDirectory,
          UuidHelper.v4(),
          StringHelper.trimToNull(uri.pathSegments.lastOrNull) ?? UuidHelper.v4(),
        );
        try {
          await IosUrlPlugin.startAccessingSecurityScopedResource(uri).asyncIgnore();
          await IosFileManagerPlugin.copyItem(
            at: uri,
            to: Uri.file(path),
          );
        } finally {
          await IosUrlPlugin.stopAccessingSecurityScopedResource(uri).asyncIgnore();
        }
        files.add(File(path));
      }
      return files;
    }
  }

  static Future<List<Uri>> export({
    required List<File> files,
    Uri? initialLocation,
  }) async {
    if (Platform.isAndroid) {
      final uris = <Uri>[];
      if (files.isNotEmpty) {
        final uri = await AndroidActivityResultContractsPlugin.openDocumentTree(
          initialLocation: initialLocation,
        );
        if (uri != null) {
          for (final file in files) {
            await AndroidContentResolverPlugin.copyFileToTreeUri(
              file: file,
              treeUri: uri,
            ).then((value) {
              uris.add(value);
            });
          }
        }
      }
      return uris;
    } else {
      final uris = await IosDocumentPickerPlugin.export(
        forExporting: files.map((file) => Uri.file(file.absolute.path)).toList(),
        asCopy: true,
        shouldShowFileExtensions: true,
      );
      return uris;
    }
  }

  DocumentManagerPlugin._();
}

class DocumentType {
  static const all = DocumentType(mimeType: "*/*", utType: "public.item");

  final String mimeType;
  final String utType;

  const DocumentType({
    required this.mimeType,
    required this.utType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentType && runtimeType == other.runtimeType && mimeType == other.mimeType && utType == other.utType;

  @override
  int get hashCode => mimeType.hashCode ^ utType.hashCode;

  @override
  String toString() {
    return 'DocumentType{mimeType: $mimeType, utType: $utType}';
  }
}

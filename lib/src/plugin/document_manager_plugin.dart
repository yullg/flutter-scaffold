import 'dart:io';

import 'package:path/path.dart' as p;

import '../helper/uuid_helper.dart';
import '../scaffold_constants.dart';
import '../support/storage/storage_type.dart';
import 'android/android_activity_result_contracts_plugin.dart';
import 'android/android_content_resolver_plugin.dart';
import 'ios/ios_document_picker_plugin.dart';
import 'ios/ios_file_manager_plugin.dart';

class DocumentManagerPlugin {
  // static Future<List<String>> import({
  //   List<DocumentType> documentTypes = const [DocumentType.all],
  //   bool allowsMultipleSelection = false,
  // }) async {
  //   if (Platform.isAndroid) {
  //     final uris = await AndroidActivityResultContractsPlugin.openDocument(
  //       mimeTypes: documentTypes.map((e) => e.mimeType).toList(growable: false),
  //       allowsMultipleSelection: allowsMultipleSelection,
  //     );
  //     final paths = <String>[];
  //     for (final uri in uris) {
  //       final extension = await AndroidContentResolverPlugin.getExtensionFromContentUri(contentUri: uri);
  //       final path = p.join(
  //         (await StorageType.cache.directory).path,
  //         ScaffoldConstants.kDocumentManagerDirectory,
  //         "${UuidHelper.v4()}${extension != null ? ".$extension" : ""}",
  //       );
  //       await File(path).create(recursive: true);
  //       await AndroidContentResolverPlugin.contentUriToFile(
  //         atContentUri: uri,
  //         toFilePath: path,
  //       );
  //       paths.add(path);
  //     }
  //     return paths;
  //   } else if (Platform.isIOS) {
  //     final uris = await IosDocumentPickerPlugin.importDocument(
  //       allowedUTIs: documentTypes.map((e) => e.utType).toList(growable: false),
  //       allowsMultipleSelection: allowsMultipleSelection,
  //     );
  //     final paths = <String>[];
  //     for (final uri in uris) {
  //       final path = p.join(
  //         (await StorageType.cache.directory).path,
  //         ScaffoldConstants.kDocumentManagerDirectory,
  //         "${UuidHelper.v4()}${p.extension(uri)}",
  //       );
  //       await File(path).parent.create(recursive: true);
  //       await IosFileManagerPlugin.copy(
  //         atUrl: uri,
  //         toUrl: Uri.file(path).toString(),
  //         isSecurityScoped: true,
  //       );
  //       paths.add(path);
  //     }
  //     return paths;
  //   } else {
  //     throw UnsupportedError("Platform not supported: ${Platform.operatingSystem}");
  //   }
  // }

  static Future<bool> export({
    required DocumentType documentType,
    required String path,
    required String name,
  }) async {
    if (Platform.isAndroid) {
      final uri = await AndroidActivityResultContractsPlugin.createDocument(
        mimeType: documentType.mimeType,
        name: name,
      );
      if (uri == null) return false;
      await AndroidContentResolverPlugin.copyFileToContentUri(
        file: File(path),
        contentUri: uri,
      );
      return true;
    } else if (Platform.isIOS) {
      final uris = await IosDocumentPickerPlugin.exportDocument(
        urls: [Uri.file(path).toString()],
      );
      return uris.isNotEmpty;
    } else {
      throw UnsupportedError("Platform not supported: ${Platform.operatingSystem}");
    }
  }

  DocumentManagerPlugin._();
}

class DocumentType {
  final String mimeType;
  final String utType;

  const DocumentType({
    required this.mimeType,
    required this.utType,
  });

  static const all = DocumentType(mimeType: "*/*", utType: "public.item");
}

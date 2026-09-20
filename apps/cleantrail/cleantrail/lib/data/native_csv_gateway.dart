import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:file_selector/file_selector.dart' as selector;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'csv_gateway.dart';

class NativeCsvGateway implements CsvGateway {
  NativeCsvGateway({
    Future<Directory> Function()? temporaryDirectoryProvider,
    Future<void> Function(ShareParams)? share,
  }) : _temporaryDirectoryProvider =
           temporaryDirectoryProvider ?? getTemporaryDirectory,
       _share = share ?? ((params) async => SharePlus.instance.share(params));

  static const maxFileBytes = 5 * 1024 * 1024;
  static const _exportDirectoryName = 'cleantrail-exports';

  final Future<Directory> Function() _temporaryDirectoryProvider;
  final Future<void> Function(ShareParams) _share;

  Future<Directory> _exportDirectory() async {
    final temporary = await _temporaryDirectoryProvider();
    return Directory('${temporary.path}/$_exportDirectoryName');
  }

  @override
  Future<void> cleanupTemporaryFiles() async {
    final directory = await _exportDirectory();
    if (await directory.exists()) await directory.delete(recursive: true);
  }

  @override
  Future<ImportedCsv?> pickCsv() async {
    const csvType = selector.XTypeGroup(
      label: 'CSV',
      extensions: ['csv'],
      mimeTypes: ['text/csv', 'text/plain'],
    );
    final file = await selector.openFile(acceptedTypeGroups: [csvType]);
    if (file == null) return null;
    if (await file.length() > maxFileBytes) {
      throw const FormatException('fileTooLarge');
    }
    final bytes = await file.readAsBytes();
    try {
      return ImportedCsv(
        fileName: file.name,
        content: const Utf8Decoder(allowMalformed: false).convert(bytes),
      );
    } on FormatException {
      throw const FormatException('invalidEncoding');
    }
  }

  @override
  Future<void> export({
    required String baseName,
    required String csv,
    required String report,
    required String shareText,
    required bool complete,
    Rect? shareOrigin,
  }) async {
    await cleanupTemporaryFiles();
    final directory = await _exportDirectory();
    await directory.create(recursive: true);
    final safeName = baseName.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    final stateLabel = complete ? 'clean' : 'draft';
    final csvFile = File('${directory.path}/${safeName}_$stateLabel.csv');
    final reportFile = File('${directory.path}/${safeName}_quality_report.md');
    try {
      await csvFile.writeAsString(csv, flush: true);
      await reportFile.writeAsString(report, flush: true);
      await _share(
        ShareParams(
          title: 'CleanTrail export',
          text: shareText,
          sharePositionOrigin: shareOrigin,
          files: [XFile(csvFile.path), XFile(reportFile.path)],
          fileNameOverrides: [
            '${safeName}_$stateLabel.csv',
            '${safeName}_quality_report.md',
          ],
        ),
      );
    } finally {
      try {
        if (await csvFile.exists()) await csvFile.delete();
      } on Object {
        // The next launch/export retries cleanup of the dedicated directory.
      }
      try {
        if (await reportFile.exists()) await reportFile.delete();
      } on Object {
        // Keep cleanup attempts independent so one failure cannot skip another.
      }
    }
  }
}

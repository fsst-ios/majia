import 'dart:ui';

class ImportedCsv {
  const ImportedCsv({required this.fileName, required this.content});
  final String fileName;
  final String content;
}

abstract interface class CsvGateway {
  Future<void> cleanupTemporaryFiles();
  Future<ImportedCsv?> pickCsv();
  Future<void> export({
    required String baseName,
    required String csv,
    required String report,
    required String shareText,
    required bool complete,
    Rect? shareOrigin,
  });
}

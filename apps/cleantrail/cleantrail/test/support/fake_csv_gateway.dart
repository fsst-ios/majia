import 'dart:ui';

import 'package:cleantrail/data/csv_gateway.dart';

class FakeCsvGateway implements CsvGateway {
  FakeCsvGateway({this.nextImport});

  ImportedCsv? nextImport;
  String? exportedCsv;
  String? exportedReport;
  bool? exportedComplete;

  @override
  Future<void> cleanupTemporaryFiles() async {}

  @override
  Future<ImportedCsv?> pickCsv() async => nextImport;

  @override
  Future<void> export({
    required String baseName,
    required String csv,
    required String report,
    required String shareText,
    required bool complete,
    Rect? shareOrigin,
  }) async {
    exportedCsv = csv;
    exportedReport = report;
    exportedComplete = complete;
  }
}

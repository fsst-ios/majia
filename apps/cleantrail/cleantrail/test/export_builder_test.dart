import 'package:cleantrail/domain/export_builder.dart';
import 'package:cleantrail/domain/quality_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('export contains cleaned CSV and summary-only audit report', () {
    const engine = QualityEngine();
    final project = engine.importCsv(
      fileName: 'private.csv',
      source: 'name,value\nSecret Person, 12 \n',
    );
    final issue = project.issues.single;
    final repaired = engine.resolve(project, issue.id);

    final bundle = const ExportBuilder().build(repaired, chinese: false);

    expect(bundle.csv, contains('Secret Person,12'));
    expect(bundle.report, contains('Fixed: 1'));
    expect(bundle.report, isNot(contains('Secret Person')));
    expect(bundle.report, contains('The original CSV was not overwritten'));
  });

  test('export does not silently normalize source headers', () {
    final project = const QualityEngine().importCsv(
      fileName: 'headers.csv',
      source: ' name ,,name\nAlice,1,2\n',
    );

    final bundle = const ExportBuilder().build(project, chinese: false);

    expect(bundle.csv.split(RegExp(r'\r?\n')).first, ' name ,,name');
  });
}

import 'dart:io';

import 'package:cleantrail/data/file_project_store.dart';
import 'package:cleantrail/domain/quality_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory directory;
  late FileProjectStore store;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('cleantrail-store-');
    store = FileProjectStore(directoryProvider: () async => directory);
  });

  tearDown(() async {
    if (await directory.exists()) await directory.delete(recursive: true);
  });

  test('save and load preserve a valid project', () async {
    final project = const QualityEngine().importCsv(
      fileName: 'data.csv',
      source: 'name,value\nA,1\n',
    );

    await store.save(project);
    final restored = await store.load();

    expect(restored!.fileName, 'data.csv');
    expect(restored.records.single.values, ['A', '1']);
  });

  test('a corrupt latest file recovers the previous valid snapshot', () async {
    final engine = const QualityEngine();
    final first = engine.importCsv(
      fileName: 'first.csv',
      source: 'name,value\nA,1\n',
    );
    final second = engine.importCsv(
      fileName: 'second.csv',
      source: 'name,value\nB,2\n',
    );
    await store.save(first);
    await store.save(second);
    final latest = File('${directory.path}/cleantrail-project.json');
    await latest.writeAsString('{broken');

    final restored = await store.load();

    expect(restored!.fileName, 'first.csv');
  });

  test('clear removes current, temporary, and backup snapshots', () async {
    final project = const QualityEngine().importCsv(
      fileName: 'data.csv',
      source: 'name,value\nA,1\n',
    );
    await store.save(project);
    await store.save(project);
    final temporary = File('${directory.path}/cleantrail-project.json.tmp');
    await temporary.writeAsString('partial');

    await store.clear();

    expect(await directory.list().toList(), isEmpty);
  });

  test('load recovers backup when the primary snapshot is absent', () async {
    final project = const QualityEngine().importCsv(
      fileName: 'backup.csv',
      source: 'name,value\nA,1\n',
    );
    await store.save(project);
    await store.save(project);
    await File('${directory.path}/cleantrail-project.json').delete();

    final restored = await store.load();

    expect(restored!.fileName, 'backup.csv');
  });
}

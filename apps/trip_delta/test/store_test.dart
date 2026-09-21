import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:trip_delta/domain.dart';
import 'package:trip_delta/store.dart';

void main() {
  test('file store persists atomically and refuses corrupt input', () async {
    final directory = await Directory.systemTemp.createTemp('trip_delta_test_');
    addTearDown(() => directory.delete(recursive: true));
    final store = FileTripStore(directory: directory);
    expect((await store.load()).trips, isEmpty);
    await store.save(const AppData(language: 'zh'));
    expect((await store.load()).language, 'zh');
    final file = File('${directory.path}/trip_delta_v1.json');
    await file.writeAsString('{broken');
    await expectLater(store.load(), throwsFormatException);
    expect(await file.readAsString(), '{broken');
  });

  test('controller commits state only after store succeeds', () async {
    final store = FailingStore();
    final controller = AppController(store);
    addTearDown(controller.dispose);
    await controller.load();
    store.fail = true;
    await expectLater(controller.setLanguage('zh'), throwsStateError);
    expect(controller.data.language, 'auto');
    store.fail = false;
    await controller.setLanguage('en');
    expect(controller.data.language, 'en');
  });
}

class FailingStore implements TripStore {
  AppData value = const AppData();
  bool fail = false;

  @override
  Future<AppData> load() async => value;

  @override
  Future<void> save(AppData data) async {
    if (fail) throw StateError('disk failed');
    value = data;
  }
}

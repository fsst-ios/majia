import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:plotproof_lab/data/lesson_catalog.dart';
import 'package:plotproof_lab/data/progress_repository.dart';
import 'package:plotproof_lab/domain/models.dart';
import 'package:plotproof_lab/state/app_controller.dart';

void main() {
  test('failed save does not commit a completed attempt in memory', () async {
    final repository = MemoryProgressRepository()..failWrites = true;
    final controller = AppController(repository);
    await controller.initialize(systemLocale: const Locale('zh'));

    final didSave = await controller.completeLesson(
      lessons.first,
      Verdict.misleading,
    );

    expect(didSave, isFalse);
    expect(controller.attempts, isEmpty);
    expect(controller.errorMessage, isNotNull);
  });

  test(
    'latest result owns review membership and a correct retry closes it',
    () async {
      final controller = AppController(MemoryProgressRepository());
      await controller.initialize(systemLocale: const Locale('en'));
      final lesson = lessons.first;

      await controller.completeLesson(lesson, Verdict.fair);
      expect(controller.reviewLessonIds, contains(lesson.id));

      await controller.completeLesson(lesson, lesson.correctVerdict);
      expect(controller.reviewLessonIds, isNot(contains(lesson.id)));
      expect(controller.completedLessonIds, contains(lesson.id));
    },
  );
}

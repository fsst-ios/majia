import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../data/progress_repository.dart';
import '../domain/models.dart';

enum AppErrorKind { load, save, clear }

class AppController extends ChangeNotifier {
  AppController(this._repository);

  final ProgressRepository _repository;
  List<Attempt> _attempts = <Attempt>[];
  Locale _locale = const Locale('zh');
  String? _errorMessage;
  AppErrorKind? _errorKind;

  List<Attempt> get attempts => List<Attempt>.unmodifiable(_attempts);
  Locale get locale => _locale;
  String? get errorMessage => _errorMessage;
  AppErrorKind? get errorKind => _errorKind;
  bool get hasRecoverableLoadError =>
      _errorKind == AppErrorKind.load || _errorKind == AppErrorKind.clear;

  Future<void> initialize({Locale? systemLocale}) async {
    try {
      final storedLanguage = await _repository.loadLanguageCode();
      _locale = Locale(
        storedLanguage == 'en'
            ? 'en'
            : storedLanguage == 'zh'
            ? 'zh'
            : systemLocale?.languageCode == 'en'
            ? 'en'
            : 'zh',
      );
      _attempts = await _repository.loadAttempts();
      _errorMessage = null;
      _errorKind = null;
    } catch (error) {
      _attempts = <Attempt>[];
      _errorMessage = error.toString();
      _errorKind = AppErrorKind.load;
    }
    notifyListeners();
  }

  Future<bool> completeLesson(Lesson lesson, Verdict verdict) async {
    final attempt = Attempt(
      lessonId: lesson.id,
      verdict: verdict,
      isCorrect: verdict == lesson.correctVerdict,
      completedAt: DateTime.now(),
      misconception: lesson.id,
    );
    final next = <Attempt>[..._attempts, attempt];
    try {
      await _repository.saveAttempts(next);
      _attempts = next;
      _errorMessage = null;
      _errorKind = null;
      notifyListeners();
      return true;
    } catch (error) {
      _errorMessage = error.toString();
      _errorKind = AppErrorKind.save;
      notifyListeners();
      return false;
    }
  }

  Future<bool> setLocale(Locale locale) async {
    try {
      await _repository.saveLanguageCode(locale.languageCode);
      _locale = Locale(locale.languageCode == 'en' ? 'en' : 'zh');
      _errorMessage = null;
      _errorKind = null;
      notifyListeners();
      return true;
    } catch (error) {
      _errorMessage = error.toString();
      _errorKind = AppErrorKind.save;
      notifyListeners();
      return false;
    }
  }

  Future<bool> clearProgress() async {
    try {
      await _repository.clearAttempts();
      _attempts = <Attempt>[];
      _errorMessage = null;
      _errorKind = null;
      notifyListeners();
      return true;
    } catch (error) {
      _errorMessage = error.toString();
      _errorKind = AppErrorKind.clear;
      notifyListeners();
      return false;
    }
  }

  Map<String, Attempt> get latestAttemptByLesson {
    final latest = <String, Attempt>{};
    for (final attempt in _attempts) {
      latest[attempt.lessonId] = attempt;
    }
    return latest;
  }

  Set<String> get completedLessonIds =>
      _attempts.map((attempt) => attempt.lessonId).toSet();

  Set<String> get reviewLessonIds => latestAttemptByLesson.entries
      .where((entry) => !entry.value.isCorrect)
      .map((entry) => entry.key)
      .toSet();

  double get accuracy => _attempts.isEmpty
      ? 0
      : _attempts.where((attempt) => attempt.isCorrect).length /
            _attempts.length;
}

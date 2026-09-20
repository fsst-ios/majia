import 'dart:ui';

class LocalizedText {
  const LocalizedText({required this.zh, required this.en});

  final String zh;
  final String en;

  String resolve(Locale locale) => locale.languageCode == 'zh' ? zh : en;
}

enum LessonKind { axis, correlation, sample, risk }

enum Verdict { misleading, fair, needsContext }

class Lesson {
  const Lesson({
    required this.id,
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.claim,
    required this.prompt,
    required this.correctVerdict,
    required this.explanation,
    required this.checklist,
    required this.misconception,
    required this.values,
    required this.initialParameter,
    required this.fairParameter,
    required this.minParameter,
    required this.maxParameter,
  });

  final String id;
  final LessonKind kind;
  final LocalizedText title;
  final LocalizedText subtitle;
  final LocalizedText claim;
  final LocalizedText prompt;
  final Verdict correctVerdict;
  final LocalizedText explanation;
  final List<LocalizedText> checklist;
  final LocalizedText misconception;
  final List<double> values;
  final double initialParameter;
  final double fairParameter;
  final double minParameter;
  final double maxParameter;
}

class Attempt {
  const Attempt({
    required this.lessonId,
    required this.verdict,
    required this.isCorrect,
    required this.completedAt,
    required this.misconception,
  });

  final String lessonId;
  final Verdict verdict;
  final bool isCorrect;
  final DateTime completedAt;
  final String misconception;

  Map<String, Object?> toJson() => <String, Object?>{
    'lessonId': lessonId,
    'verdict': verdict.name,
    'isCorrect': isCorrect,
    'completedAt': completedAt.toUtc().toIso8601String(),
    'misconception': misconception,
  };

  factory Attempt.fromJson(Map<String, Object?> json) {
    final verdictName = json['verdict'];
    final completedAt = json['completedAt'];
    if (json['lessonId'] is! String ||
        verdictName is! String ||
        json['isCorrect'] is! bool ||
        completedAt is! String ||
        json['misconception'] is! String) {
      throw const FormatException('Invalid attempt payload');
    }
    return Attempt(
      lessonId: json['lessonId']! as String,
      verdict: Verdict.values.byName(verdictName),
      isCorrect: json['isCorrect']! as bool,
      completedAt: DateTime.parse(completedAt),
      misconception: json['misconception']! as String,
    );
  }
}

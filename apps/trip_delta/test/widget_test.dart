import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trip_delta/domain.dart';
import 'package:trip_delta/main.dart';
import 'package:trip_delta/screens.dart';
import 'package:trip_delta/store.dart';
import 'package:trip_delta/strings.dart';

Future<void> tapVisible(WidgetTester tester, Key key) async {
  final finder = find.byKey(key);
  await tester.scrollUntilVisible(
    finder,
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('first quick expense locks plan and home records the next one', (
    tester,
  ) async {
    final store = MemoryStore();
    await tester.pumpWidget(TripDeltaApp(store: store));
    await tester.pumpAndSettle();
    await tapVisible(tester, const Key('new_trip'));
    await tester.enterText(find.byKey(const Key('trip_name')), 'Kyoto');
    await tester.enterText(
      find.byKey(const Key('trip_destination')),
      'Kyoto, Japan',
    );
    await tester.enterText(find.byKey(const Key('budget_stay')), '300.00');
    await tapVisible(tester, const Key('save_plan'));
    expect(find.byType(TripDetailPage), findsOneWidget);
    expect(store.value.trips.single.stage, TripStage.draft);
    await tapVisible(tester, const Key('add_expense'));
    await tester.enterText(find.byKey(const Key('expense_amount')), '350.00');
    await tapVisible(tester, const Key('category_stay'));
    await tapVisible(tester, const Key('save_expense'));
    final trip = store.value.trips.single;
    expect(trip.stage, TripStage.active);
    expect(trip.plannedMinor, 30000);
    expect(trip.spentMinor, 35000);
    expect(trip.expenses.single.title, isEmpty);
    expect(trip.expenses.single.settledMinor, 35000);
    expect(find.text('Edit plan'), findsNothing);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tapVisible(tester, const Key('home_quick_expense'));
    expect(
      tester
          .widget<ChoiceChip>(find.byKey(const Key('category_stay')))
          .selected,
      isTrue,
    );
    await tester.enterText(find.byKey(const Key('expense_amount')), '10');
    await tapVisible(tester, const Key('save_expense'));
    expect(store.value.trips.single.expenses.length, 2);
    expect(store.value.trips.single.spentMinor, 36000);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'local currency and manual rate are reused, then posted amount replaces estimate',
    (tester) async {
      final store = MemoryStore()
        ..value = AppData(
          language: 'en',
          trips: [sampleTrip(localCurrency: 'JPY', stage: TripStage.draft)],
        );
      await tester.pumpWidget(TripDeltaApp(store: store));
      await tester.pumpAndSettle();
      await tapVisible(tester, const Key('home_quick_expense'));
      expect(
        tester
            .widget<DropdownButtonFormField<String>>(
              find.byKey(const Key('expense_currency')),
            )
            .initialValue,
        'JPY',
      );
      await tester.enterText(find.byKey(const Key('expense_amount')), '1000');
      await tester.enterText(find.byKey(const Key('expense_rate')), '0.05');
      await tapVisible(tester, const Key('save_expense'));
      expect(store.value.trips.single.estimatedCount, 1);
      expect(store.value.trips.single.spentMinor, 5000);
      await tapVisible(tester, const Key('home_quick_expense'));
      expect(
        tester
            .widget<TextFormField>(find.byKey(const Key('expense_rate')))
            .controller!
            .text,
        '0.05',
      );
      await tester.enterText(find.byKey(const Key('expense_amount')), '1200');
      await tapVisible(tester, const Key('save_expense'));
      expect(store.value.trips.single.estimatedCount, 2);
      expect(store.value.trips.single.spentMinor, 11000);
      final secondId = store.value.trips.single.expenses.last.id;
      await tapVisible(tester, const Key('focus_trip'));
      await tapVisible(tester, Key('expense_$secondId'));
      await tapVisible(tester, const Key('expense_details_toggle'));
      await tester.enterText(find.byKey(const Key('expense_settled')), '55.00');
      await tapVisible(tester, const Key('save_expense'));
      expect(store.value.trips.single.expenses.last.bookedMinor, 6000);
      expect(store.value.trips.single.expenses.last.settledMinor, 5500);
      expect(store.value.trips.single.spentMinor, 10500);
      expect(store.value.trips.single.estimatedCount, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('deleting first expense unlocks mistaken budget', (tester) async {
    final store = MemoryStore()
      ..value = AppData(
        language: 'en',
        trips: [sampleTrip(stage: TripStage.draft)],
      );
    await tester.pumpWidget(TripDeltaApp(store: store));
    await tester.pumpAndSettle();
    await tapVisible(tester, const Key('focus_trip'));
    await tapVisible(tester, const Key('add_expense'));
    await tester.enterText(find.byKey(const Key('expense_amount')), '20');
    await tapVisible(tester, const Key('save_expense'));
    final id = store.value.trips.single.expenses.single.id;
    await tapVisible(tester, Key('expense_$id'));
    await tester.scrollUntilVisible(
      find.byKey(const Key('expense_title')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(find.byKey(const Key('expense_title')), 'Train');
    await tapVisible(tester, const Key('save_expense'));
    await tapVisible(tester, Key('expense_$id'));
    await tapVisible(tester, const Key('delete_expense'));
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();
    expect(store.value.trips.single.stage, TripStage.draft);
    expect(store.value.trips.single.startedAt, isNull);
    expect(store.value.trips.single.expenses, isEmpty);
    await tester.scrollUntilVisible(
      find.text('Edit plan'),
      -200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Edit plan'), findsOneWidget);
  });

  testWidgets('review shows drivers and can reuse the plan', (tester) async {
    final expense = Expense(
      id: 'e1',
      title: 'Hotel',
      category: BudgetCategory.stay,
      amountMinor: 12000,
      currency: 'CNY',
      rate: 1,
      bookedMinor: 12000,
      settledMinor: 12000,
      recordedAt: DateTime.utc(2026, 9, 1),
    );
    final trip = sampleTrip(
      stage: TripStage.active,
    ).copyWith(expenses: [expense]);
    final store = MemoryStore()..value = AppData(language: 'en', trips: [trip]);
    await tester.pumpWidget(TripDeltaApp(store: store));
    await tester.pumpAndSettle();
    await tapVisible(tester, const Key('focus_trip'));
    await tapVisible(tester, const Key('finish_trip'));
    expect(find.text('Hotel · CNY 120.00 · Posted amount'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('reflection')), 'Book earlier');
    await tapVisible(tester, const Key('save_review'));
    expect(store.value.trips.single.stage, TripStage.completed);
    expect(
      summaryText(store.value.trips.single, const L(false)),
      contains('Hotel'),
    );
    await tapVisible(tester, const Key('repeat_plan'));
    expect(store.value.trips.length, 2);
    expect(store.value.trips.first.stage, TripStage.draft);
    expect(store.value.trips.first.plannedMinor, trip.plannedMinor);
    expect(store.value.trips.first.expenses, isEmpty);
  });

  testWidgets('cancelled plan discards input', (tester) async {
    final store = MemoryStore();
    await tester.pumpWidget(TripDeltaApp(store: store));
    await tester.pumpAndSettle();
    await tapVisible(tester, const Key('new_trip'));
    await tester.enterText(find.byKey(const Key('trip_name')), 'Discard me');
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(store.value.trips, isEmpty);
    await tapVisible(tester, const Key('new_trip'));
    expect(find.text('Discard me'), findsNothing);
  });

  testWidgets('failed save retains plan for retry', (tester) async {
    final store = DelayedFailStore();
    await tester.pumpWidget(TripDeltaApp(store: store));
    await tester.pumpAndSettle();
    await tapVisible(tester, const Key('new_trip'));
    await tester.enterText(
      find.byKey(const Key('trip_name')),
      'Keep this input',
    );
    await tester.enterText(find.byKey(const Key('budget_stay')), '100');
    final save = find.byKey(const Key('save_plan'));
    await tester.scrollUntilVisible(
      save,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(save);
    await tester.pumpAndSettle();
    await tester.tap(save);
    await tester.pump();
    expect(tester.widget<PopScope>(find.byType(PopScope)).canPop, isFalse);
    store.pending.completeError(StateError('disk failed'));
    await tester.pumpAndSettle();
    expect(store.value.trips, isEmpty);
    await tester.scrollUntilVisible(
      find.byKey(const Key('trip_name')),
      -200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('trip_name')))
          .controller!
          .text,
      'Keep this input',
    );
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tapVisible(tester, const Key('save_plan'));
    expect(store.value.trips.single.title, 'Keep this input');
  });
}

Trip sampleTrip({String? localCurrency, TripStage stage = TripStage.active}) =>
    Trip(
      id: 'trip1',
      title: 'Kyoto',
      destination: 'Kyoto, Japan',
      baseCurrency: 'CNY',
      localCurrency: localCurrency,
      startDate: DateTime(2026, 9, 1),
      endDate: DateTime(2026, 9, 5),
      budgets: {
        BudgetCategory.stay: 10000,
        BudgetCategory.transport: 0,
        BudgetCategory.food: 0,
        BudgetCategory.experiences: 0,
        BudgetCategory.other: 0,
      },
      stage: stage,
      createdAt: DateTime.utc(2026, 9, 1),
      expenses: const [],
    );

class MemoryStore implements TripStore {
  AppData value = const AppData(language: 'en');
  @override
  Future<AppData> load() async => value;
  @override
  Future<void> save(AppData data) async {
    value = data;
  }
}

class DelayedFailStore extends MemoryStore {
  final Completer<void> pending = Completer<void>();
  bool first = true;
  @override
  Future<void> save(AppData data) async {
    if (first) {
      first = false;
      await pending.future;
    }
    await super.save(data);
  }
}

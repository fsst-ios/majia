import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'domain.dart';
import 'store.dart';
import 'strings.dart';

L loc(BuildContext context) =>
    L(Localizations.localeOf(context).languageCode == 'zh');

String amountInput(int minor, String currency) {
  if (currencyDigits(currency) == 0) return minor.toString();
  return (minor / 100).toStringAsFixed(2);
}

Widget pageWidth(Widget child) => Align(
  alignment: Alignment.topCenter,
  child: ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 720),
    child: child,
  ),
);

void showSaveError(BuildContext context, L l) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(l('saveError'))));
}

Future<bool> confirmDelete(BuildContext context, String question, L l) async {
  return await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(question),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l('cancel')),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l('delete')),
            ),
          ],
        ),
      ) ??
      false;
}

class TripPaceCard extends StatelessWidget {
  const TripPaceCard({super.key, required this.trip, required this.l});
  final Trip trip;
  final L l;

  @override
  Widget build(BuildContext context) {
    final daily = trip.dailyAvailableMinor(DateTime.now());
    final theme = Theme.of(context);
    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(trip.title, style: theme.textTheme.titleLarge),
            if (trip.destination.isNotEmpty) Text(trip.destination),
            const SizedBox(height: 12),
            Text(
              '${l('planned')} ${moneyText(trip.plannedMinor, trip.baseCurrency)}  ·  ${l('recorded')} ${moneyText(trip.spentMinor, trip.baseCurrency)}',
            ),
            const SizedBox(height: 6),
            Text(
              '${trip.remainingMinor < 0 ? l('over') : l('remaining')} ${moneyText(trip.remainingMinor.abs(), trip.baseCurrency)}',
            ),
            if (daily != null) ...[
              const SizedBox(height: 6),
              Text(
                '${l('dailyAvailable')} ${moneyText(daily, trip.baseCurrency)}  ·  ${trip.daysRemaining(DateTime.now())} ${l('daysRemaining')}',
              ),
            ],
            if (trip.estimatedCount > 0) ...[
              const SizedBox(height: 6),
              Text(
                '${l('includesEstimates')} ${trip.estimatedCount}',
                style: theme.textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final category in BudgetCategory.values)
                  if (trip.plannedFor(category) > 0 ||
                      trip.spentFor(category) > 0)
                    Chip(
                      label: Text(
                        '${l.category(category)} ${moneyText((trip.plannedFor(category) - trip.spentFor(category)).abs(), trip.baseCurrency)} ${trip.deltaFor(category) > 0 ? l('over') : l('remaining')}',
                      ),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.controller});
  final AppController controller;

  Future<void> _language(BuildContext context, String value) async {
    try {
      await controller.setLanguage(value);
    } catch (_) {
      if (context.mounted) showSaveError(context, loc(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final l = loc(context);
        Trip? focus;
        for (final trip in controller.trips) {
          if (trip.stage == TripStage.active) {
            focus = trip;
            break;
          }
        }
        focus ??= controller.trips
            .where((trip) => trip.stage == TripStage.draft)
            .firstOrNull;
        return Scaffold(
          appBar: AppBar(
            title: Text(l('app')),
            actions: [
              PopupMenuButton<String>(
                tooltip: l('language'),
                icon: const Icon(Icons.translate),
                onSelected: (value) => _language(context, value),
                itemBuilder: (_) => [
                  for (final code in ['auto', 'zh', 'en'])
                    PopupMenuItem(value: code, child: Text(l(code))),
                ],
              ),
              IconButton(
                tooltip: l('privacy'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const PrivacyScreen(),
                  ),
                ),
                icon: const Icon(Icons.privacy_tip_outlined),
              ),
            ],
          ),
          body: controller.loading
              ? const Center(child: CircularProgressIndicator())
              : controller.loadError != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(l('loadError'), textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: controller.load,
                          child: Text(l('retry')),
                        ),
                      ],
                    ),
                  ),
                )
              : pageWidth(
                  ListView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                    children: [
                      Text(
                        l('tagline'),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 24),
                      if (controller.trips.isEmpty) ...[
                        Text(
                          l('noTrips'),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(l('noTripsHelp')),
                        const SizedBox(height: 24),
                      ],
                      if (focus != null) ...[
                        InkWell(
                          key: const Key('focus_trip'),
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => TripDetailPage(
                                controller: controller,
                                tripId: focus!.id,
                              ),
                            ),
                          ),
                          child: TripPaceCard(trip: focus, l: l),
                        ),
                        const SizedBox(height: 8),
                        FilledButton.icon(
                          key: const Key('home_quick_expense'),
                          onPressed: controller.busy
                              ? null
                              : () => Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (_) => ExpensePage(
                                      controller: controller,
                                      tripId: focus!.id,
                                    ),
                                  ),
                                ),
                          icon: const Icon(Icons.add),
                          label: Text(l('addExpense')),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (focus != null &&
                          controller.trips.any(
                            (trip) => trip.id != focus!.id,
                          )) ...[
                        Text(
                          l('otherTrips'),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                      ],
                      for (final trip in controller.trips.where(
                        (trip) => trip.id != focus?.id,
                      )) ...[
                        InkWell(
                          key: Key('trip_${trip.id}'),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => TripDetailPage(
                                controller: controller,
                                tripId: trip.id,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trip.title,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 6),
                                Text(l.stage(trip.stage)),
                                const SizedBox(height: 6),
                                Text(
                                  '${l('planned')}  ${moneyText(trip.plannedMinor, trip.baseCurrency)}   ·   ${l('recorded')}  ${moneyText(trip.spentMinor, trip.baseCurrency)}',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: 1),
                      ],
                      const SizedBox(height: 24),
                      OutlinedButton.icon(
                        key: const Key('new_trip'),
                        onPressed: controller.busy
                            ? null
                            : () => Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) =>
                                      PlanPage(controller: controller),
                                ),
                              ),
                        icon: const Icon(Icons.add),
                        label: Text(l('newTrip')),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        l('localOnly'),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = loc(context);
    return Scaffold(
      appBar: AppBar(title: Text(l('privacy'))),
      body: pageWidth(
        ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              l('privacyBody'),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class PlanPage extends StatefulWidget {
  const PlanPage({super.key, required this.controller, this.existing});
  final AppController controller;
  final Trip? existing;

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _destination;
  late final Map<BudgetCategory, TextEditingController> _budgets;
  late String _currency;
  late String _localCurrency;
  late DateTimeRange _dates;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _currency = widget.existing?.baseCurrency ?? 'CNY';
    _localCurrency = widget.existing?.entryCurrency ?? _currency;
    final today = DateUtils.dateOnly(DateTime.now());
    _dates = DateTimeRange(
      start: widget.existing?.startDate ?? today,
      end: widget.existing?.endDate ?? today.add(const Duration(days: 4)),
    );
    _name = TextEditingController(text: widget.existing?.title ?? '');
    _destination = TextEditingController(
      text: widget.existing?.destination ?? '',
    );
    _budgets = {
      for (final category in BudgetCategory.values)
        category: TextEditingController(
          text: widget.existing == null
              ? ''
              : amountInput(widget.existing!.plannedFor(category), _currency),
        ),
    };
  }

  @override
  void dispose() {
    _name.dispose();
    _destination.dispose();
    for (final controller in _budgets.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final l = loc(context);
    final budgets = {
      for (final item in BudgetCategory.values)
        item: parseMinor(
          _budgets[item]!.text.trim().isEmpty ? '0' : _budgets[item]!.text,
          _currency,
        )!,
    };
    if (budgets.values.every((value) => value == 0)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l('positiveBudget'))));
      return;
    }
    final now = DateTime.now().toUtc();
    final trip = widget.existing == null
        ? Trip(
            id: newId(),
            title: _name.text.trim(),
            destination: _destination.text.trim(),
            baseCurrency: _currency,
            localCurrency: _localCurrency,
            startDate: _dates.start,
            endDate: _dates.end,
            budgets: budgets,
            stage: TripStage.draft,
            createdAt: now,
            expenses: const [],
          )
        : widget.existing!.copyWith(
            title: _name.text.trim(),
            destination: _destination.text.trim(),
            localCurrency: _localCurrency,
            startDate: _dates.start,
            endDate: _dates.end,
            budgets: budgets,
          );
    setState(() => _saving = true);
    try {
      await widget.controller.upsertTrip(trip);
      if (mounted) {
        setState(() => _saving = false);
        if (widget.existing == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (_) => TripDetailPage(
                controller: widget.controller,
                tripId: trip.id,
              ),
            ),
          );
        } else {
          Navigator.pop(context);
        }
      }
    } catch (_) {
      if (mounted) showSaveError(context, l);
    } finally {
      if (mounted && _saving) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = loc(context);
    return PopScope(
      canPop: !_saving,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.existing == null ? l('planTitle') : l('editPlan')),
          leading: IconButton(
            key: const Key('form_back'),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: _saving ? null : () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: pageWidth(
          Form(
            key: _form,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
              children: [
                TextFormField(
                  key: const Key('trip_name'),
                  controller: _name,
                  maxLength: 80,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l('tripName'),
                    hintText: l('tripHint'),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? l('requiredName')
                      : null,
                ),
                TextFormField(
                  key: const Key('trip_destination'),
                  controller: _destination,
                  maxLength: 80,
                  decoration: InputDecoration(labelText: l('destination')),
                ),
                OutlinedButton.icon(
                  key: const Key('trip_dates'),
                  onPressed: () async {
                    final selected = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      initialDateRange: _dates,
                    );
                    if (selected != null && mounted) {
                      setState(() => _dates = selected);
                    }
                  },
                  icon: const Icon(Icons.date_range_outlined),
                  label: Text(
                    '${l('travelDates')}: ${_dates.start.year}-${_dates.start.month}-${_dates.start.day} — ${_dates.end.year}-${_dates.end.month}-${_dates.end.day}',
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  key: const Key('base_currency'),
                  initialValue: _currency,
                  decoration: InputDecoration(labelText: l('baseCurrency')),
                  items: [
                    for (final currency in supportedCurrencies)
                      DropdownMenuItem(value: currency, child: Text(currency)),
                  ],
                  onChanged: widget.existing == null
                      ? (value) {
                          if (value == null) return;
                          setState(() {
                            _currency = value;
                            _localCurrency = value;
                            for (final field in _budgets.values) {
                              field.clear();
                            }
                          });
                        }
                      : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  key: ValueKey('local_currency_$_currency'),
                  initialValue: _localCurrency,
                  decoration: InputDecoration(labelText: l('localCurrency')),
                  items: [
                    for (final currency in supportedCurrencies)
                      DropdownMenuItem(value: currency, child: Text(currency)),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _localCurrency = value);
                  },
                ),
                const SizedBox(height: 24),
                Text(
                  l('budgetByCat'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(l('budgetHelp')),
                const SizedBox(height: 12),
                for (final category in BudgetCategory.values) ...[
                  TextFormField(
                    key: Key('budget_${category.name}'),
                    controller: _budgets[category],
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: l.category(category),
                      prefixText: '$_currency ',
                    ),
                    validator: (value) =>
                        parseMinor(
                              value == null || value.trim().isEmpty
                                  ? '0'
                                  : value,
                              _currency,
                            ) ==
                            null
                        ? l('invalidMoney')
                        : null,
                  ),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 16),
                FilledButton(
                  key: const Key('save_plan'),
                  onPressed: _saving ? null : _save,
                  child: Text(l('savePlan')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TripDetailPage extends StatelessWidget {
  const TripDetailPage({
    super.key,
    required this.controller,
    required this.tripId,
  });
  final AppController controller;
  final String tripId;

  Future<void> _deleteTrip(BuildContext context, Trip trip, L l) async {
    if (!await confirmDelete(context, l('deleteTripQuestion'), l)) return;
    try {
      await controller.deleteTrip(trip.id);
      if (context.mounted) Navigator.pop(context);
    } catch (_) {
      if (context.mounted) showSaveError(context, l);
    }
  }

  Future<void> _setStage(
    BuildContext context,
    Trip trip,
    TripStage stage,
    L l,
  ) async {
    try {
      await controller.upsertTrip(
        trip.copyWith(
          stage: stage,
          startedAt: stage == TripStage.active && trip.startedAt == null
              ? DateTime.now().toUtc()
              : trip.startedAt,
        ),
      );
    } catch (_) {
      if (context.mounted) showSaveError(context, l);
    }
  }

  Future<void> _copy(BuildContext context, Trip trip, L l) async {
    await Clipboard.setData(ClipboardData(text: summaryText(trip, l)));
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l('copied'))));
    }
  }

  Future<void> _repeatPlan(BuildContext context, Trip trip, L l) async {
    final now = DateTime.now();
    final start = DateUtils.dateOnly(now);
    final duration = trip.startDate == null || trip.endDate == null
        ? 4
        : DateTime.utc(
                trip.endDate!.year,
                trip.endDate!.month,
                trip.endDate!.day,
              )
              .difference(
                DateTime.utc(
                  trip.startDate!.year,
                  trip.startDate!.month,
                  trip.startDate!.day,
                ),
              )
              .inDays;
    final draft = Trip(
      id: newId(),
      title: trip.title,
      destination: trip.destination,
      baseCurrency: trip.baseCurrency,
      localCurrency: trip.entryCurrency,
      startDate: start,
      endDate: start.add(Duration(days: duration)),
      budgets: Map.of(trip.budgets),
      stage: TripStage.draft,
      createdAt: now.toUtc(),
      expenses: const [],
    );
    try {
      await controller.upsertTrip(draft);
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) =>
                TripDetailPage(controller: controller, tripId: draft.id),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) showSaveError(context, l);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final trip = controller.tripById(tripId);
        final l = loc(context);
        if (trip == null) return const SizedBox.shrink();
        return Scaffold(
          appBar: AppBar(title: Text(trip.title)),
          body: pageWidth(
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
              children: [
                Text(
                  l.stage(trip.stage),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 14),
                TripPaceCard(trip: trip, l: l),
                const SizedBox(height: 24),
                if (trip.stage == TripStage.draft ||
                    trip.expenses.isEmpty &&
                        trip.stage == TripStage.active) ...[
                  OutlinedButton(
                    onPressed: controller.busy
                        ? null
                        : () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => PlanPage(
                                controller: controller,
                                existing: trip,
                              ),
                            ),
                          ),
                    child: Text(l('editPlan')),
                  ),
                  const SizedBox(height: 10),
                ],
                if (trip.stage != TripStage.completed) ...[
                  if (trip.expenses.isNotEmpty)
                    Text(
                      l('lockedHelp'),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  FilledButton.icon(
                    key: const Key('add_expense'),
                    onPressed: controller.busy
                        ? null
                        : () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => ExpensePage(
                                controller: controller,
                                tripId: trip.id,
                              ),
                            ),
                          ),
                    icon: const Icon(Icons.add),
                    label: Text(l('addExpense')),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    key: const Key('finish_trip'),
                    onPressed: controller.busy || trip.expenses.isEmpty
                        ? null
                        : () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => ReviewPage(
                                controller: controller,
                                tripId: trip.id,
                              ),
                            ),
                          ),
                    child: Text(l('finish')),
                  ),
                  if (trip.expenses.isEmpty) ...[
                    const SizedBox(height: 8),
                    Text(l('noExpenses')),
                  ],
                ],
                if (trip.stage == TripStage.completed) ...[
                  if (trip.reflection.trim().isNotEmpty) ...[
                    Text(
                      l('reflection'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(trip.reflection),
                    const SizedBox(height: 16),
                  ],
                  OutlinedButton.icon(
                    onPressed: () => _copy(context, trip, l),
                    icon: const Icon(Icons.copy_outlined),
                    label: Text(l('copySummary')),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    key: const Key('repeat_plan'),
                    onPressed: controller.busy
                        ? null
                        : () => _repeatPlan(context, trip, l),
                    icon: const Icon(Icons.copy_all_outlined),
                    label: Text(l('repeatPlan')),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: controller.busy
                        ? null
                        : () => _setStage(context, trip, TripStage.active, l),
                    child: Text(l('reopen')),
                  ),
                ],
                const SizedBox(height: 24),
                ComparisonSection(trip: trip, l: l),
                const SizedBox(height: 30),
                Text(
                  l('expenseList'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Divider(),
                if (trip.expenses.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(l('noExpenses')),
                  ),
                for (final expense in trip.expenses.reversed) ...[
                  InkWell(
                    key: Key('expense_${expense.id}'),
                    onTap: trip.stage != TripStage.completed
                        ? () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => ExpensePage(
                                controller: controller,
                                tripId: trip.id,
                                existing: expense,
                              ),
                            ),
                          )
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expense.title.isEmpty
                                ? l.category(expense.category)
                                : expense.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${moneyText(expense.effectiveMinor, trip.baseCurrency)} · ${expense.isEstimate ? l('estimate') : l('confirmed')}',
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${l.category(expense.category)} · ${moneyText(expense.amountMinor, expense.currency)}${expense.currency == trip.baseCurrency ? '' : ' · 1 ${expense.currency} = ${expense.rate} ${trip.baseCurrency}'}',
                          ),
                          Text(
                            '${expense.recordedAt.year}-${expense.recordedAt.month.toString().padLeft(2, '0')}-${expense.recordedAt.day.toString().padLeft(2, '0')}',
                          ),
                          if (expense.note.trim().isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(expense.note),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                ],
                const SizedBox(height: 28),
                TextButton(
                  onPressed: controller.busy
                      ? null
                      : () => _deleteTrip(context, trip, l),
                  child: Text(l('deleteTrip')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

BudgetCategory? largestOverCategory(Trip trip) {
  BudgetCategory? largest;
  for (final item in BudgetCategory.values) {
    if (trip.deltaFor(item) > 0 &&
        (largest == null || trip.deltaFor(item) > trip.deltaFor(largest))) {
      largest = item;
    }
  }
  return largest;
}

List<Expense> mainExpenses(Trip trip) {
  final largest = largestOverCategory(trip);
  final items = trip.expenses
      .where((item) => largest == null || item.category == largest)
      .toList();
  items.sort((a, b) => b.effectiveMinor.compareTo(a.effectiveMinor));
  return items.take(3).toList();
}

class ComparisonSection extends StatelessWidget {
  const ComparisonSection({super.key, required this.trip, required this.l});
  final Trip trip;
  final L l;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final largest = largestOverCategory(trip);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          trip.expenses.isEmpty ? l('budgetByCat') : l('difference'),
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        if (trip.expenses.isEmpty)
          Text('${l('incompleteSummary')} · ${l('noExpenses')}')
        else
          Text(
            trip.deltaMinor > 0
                ? '${l('over')}  ${moneyText(trip.deltaMinor, trip.baseCurrency)}'
                : '${l('remaining')}  ${moneyText(-trip.deltaMinor, trip.baseCurrency)}',
            style: theme.textTheme.titleMedium,
          ),
        const SizedBox(height: 8),
        Text('${l('entryCount')}: ${trip.expenses.length}'),
        if (trip.estimatedCount > 0)
          Text('${l('includesEstimates')} ${trip.estimatedCount}'),
        if (trip.expenses.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            largest == null
                ? l('noOverage')
                : '${l('largestDriver')}: ${l.category(largest)}',
          ),
        ],
        if (trip.expenses.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(l('mainExpenses'), style: theme.textTheme.titleMedium),
          for (final expense in mainExpenses(trip))
            Text(
              '${expense.title.isEmpty ? l.category(expense.category) : expense.title} · ${moneyText(expense.effectiveMinor, trip.baseCurrency)} · ${expense.isEstimate ? l('estimate') : l('confirmed')}',
            ),
        ],
        const SizedBox(height: 14),
        for (final item in BudgetCategory.values) ...[
          const Divider(height: 20),
          Text(l.category(item), style: theme.textTheme.titleMedium),
          const SizedBox(height: 5),
          Wrap(
            spacing: 16,
            runSpacing: 4,
            children: [
              Text(
                '${l('planned')}  ${moneyText(trip.plannedFor(item), trip.baseCurrency)}',
              ),
              Text(
                '${l('spent')}  ${moneyText(trip.spentFor(item), trip.baseCurrency)}',
              ),
              if (trip.expenses.isNotEmpty)
                Text(
                  '${trip.deltaFor(item) > 0 ? l('over') : l('remaining')}  ${moneyText(trip.deltaFor(item).abs(), trip.baseCurrency)}',
                  style: TextStyle(
                    color: trip.deltaFor(item) > 0
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

String summaryText(Trip trip, L l) {
  final lines = <String>[
    trip.title,
    if (trip.destination.isNotEmpty) trip.destination,
    '${l('planned')}: ${moneyText(trip.plannedMinor, trip.baseCurrency)}',
    '${l('spent')}: ${moneyText(trip.spentMinor, trip.baseCurrency)}',
    '${l('entryCount')}: ${trip.expenses.length}',
    if (trip.estimatedCount > 0)
      '${l('includesEstimates')} ${trip.estimatedCount}',
  ];
  if (trip.expenses.isEmpty) {
    lines.add(l('incompleteSummary'));
  } else {
    lines.add(
      '${l('difference')}: ${moneyText(trip.deltaMinor, trip.baseCurrency)}',
    );
  }
  for (final item in BudgetCategory.values) {
    lines.add(
      '${l.category(item)}  ${l('planned')} ${moneyText(trip.plannedFor(item), trip.baseCurrency)} / ${l('spent')} ${moneyText(trip.spentFor(item), trip.baseCurrency)}${trip.expenses.isEmpty ? '' : ' / ${l('difference')} ${moneyText(trip.deltaFor(item), trip.baseCurrency)}'}',
    );
  }
  if (trip.expenses.isNotEmpty) {
    final largest = largestOverCategory(trip);
    lines.add(
      largest == null
          ? l('noOverage')
          : '${l('largestDriver')}: ${l.category(largest)}',
    );
    lines.add(l('mainExpenses'));
    for (final expense in mainExpenses(trip)) {
      lines.add(
        '${expense.title.isEmpty ? l.category(expense.category) : expense.title}: ${moneyText(expense.effectiveMinor, trip.baseCurrency)} (${expense.isEstimate ? l('estimate') : l('confirmed')})',
      );
    }
  }
  if (trip.reflection.trim().isNotEmpty) lines.add(trip.reflection.trim());
  return lines.join('\n');
}

class ExpensePage extends StatefulWidget {
  const ExpensePage({
    super.key,
    required this.controller,
    required this.tripId,
    this.existing,
  });
  final AppController controller;
  final String tripId;
  final Expense? existing;

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _amount;
  late final TextEditingController _rate;
  late final TextEditingController _note;
  late final TextEditingController _settled;
  late String _currency;
  late BudgetCategory _category;
  late DateTime _expenseDate;
  DateTime? _rateObservedAt;
  bool _detailsExpanded = false;
  bool _saving = false;

  Expense? _lastRate(Trip trip, String currency) {
    for (final expense in trip.expenses.reversed) {
      if (expense.id != widget.existing?.id &&
          expense.currency == currency &&
          expense.currency != trip.baseCurrency) {
        return expense;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    final trip = widget.controller.tripById(widget.tripId)!;
    final old = widget.existing;
    _currency = old?.currency ?? trip.entryCurrency;
    _category =
        old?.category ??
        (trip.expenses.isEmpty
            ? BudgetCategory.food
            : trip.expenses.last.category);
    _expenseDate = old?.recordedAt.toLocal() ?? DateTime.now();
    _rateObservedAt = old?.rateObservedAt ?? old?.recordedAt;
    _title = TextEditingController(text: old?.title ?? '');
    _amount = TextEditingController(
      text: old == null ? '' : amountInput(old.amountMinor, old.currency),
    );
    final previousRate = _lastRate(trip, _currency);
    _rate = TextEditingController(
      text:
          old?.rate.toString() ??
          previousRate?.rate.toString() ??
          (_currency == trip.baseCurrency ? '1' : ''),
    );
    _rateObservedAt ??=
        previousRate?.rateObservedAt ?? previousRate?.recordedAt;
    _note = TextEditingController(text: old?.note ?? '');
    _settled = TextEditingController(
      text: old?.settledMinor == null || old?.currency == trip.baseCurrency
          ? ''
          : amountInput(old!.settledMinor!, trip.baseCurrency),
    );
    _detailsExpanded =
        old != null &&
        (old.title.isNotEmpty ||
            old.note.isNotEmpty ||
            old.settledMinor != null);
    _amount.addListener(_refresh);
    _rate.addListener(_refresh);
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _amount.removeListener(_refresh);
    _rate.removeListener(_refresh);
    _title.dispose();
    _amount.dispose();
    _rate.dispose();
    _note.dispose();
    _settled.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final trip = widget.controller.tripById(widget.tripId)!;
    final l = loc(context);
    final amount = parseMinor(_amount.text, _currency)!;
    final rate = _currency == trip.baseCurrency ? 1.0 : parseRate(_rate.text)!;
    final booked = convertMinor(
      sourceMinor: amount,
      sourceCurrency: _currency,
      baseCurrency: trip.baseCurrency,
      rate: rate,
    );
    if (amount <= 0 || booked <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l('invalidMoney'))));
      return;
    }
    final posted = _settled.text.trim().isEmpty
        ? null
        : parseMinor(_settled.text, trip.baseCurrency);
    if (_settled.text.trim().isNotEmpty && (posted == null || posted <= 0)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l('invalidMoney'))));
      return;
    }
    final expense = Expense(
      id: widget.existing?.id ?? newId(),
      title: _title.text.trim(),
      category: _category,
      amountMinor: amount,
      currency: _currency,
      rate: rate,
      bookedMinor: booked,
      recordedAt: DateTime.utc(
        _expenseDate.year,
        _expenseDate.month,
        _expenseDate.day,
      ),
      note: _note.text.trim(),
      settledMinor: _currency == trip.baseCurrency ? amount : posted,
      rateObservedAt: _currency == trip.baseCurrency
          ? null
          : (_rateObservedAt ?? DateTime.now().toUtc()),
    );
    final items = [...trip.expenses];
    final index = items.indexWhere((item) => item.id == expense.id);
    if (index < 0) {
      items.add(expense);
    } else {
      items[index] = expense;
    }
    setState(() => _saving = true);
    try {
      await widget.controller.upsertTrip(
        trip.copyWith(
          expenses: items,
          stage: trip.stage == TripStage.draft ? TripStage.active : trip.stage,
          startedAt: trip.stage == TripStage.draft
              ? DateTime.now().toUtc()
              : trip.startedAt,
        ),
      );
      if (mounted) {
        setState(() => _saving = false);
        Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) showSaveError(context, l);
    } finally {
      if (mounted && _saving) setState(() => _saving = false);
    }
  }

  Future<void> _delete(Trip trip, L l) async {
    if (!await confirmDelete(context, l('deleteExpenseQuestion'), l)) return;
    if (!mounted) return;
    setState(() => _saving = true);
    try {
      final remaining = trip.expenses
          .where((item) => item.id != widget.existing!.id)
          .toList();
      await widget.controller.upsertTrip(
        trip.copyWith(
          expenses: remaining,
          stage: remaining.isEmpty ? TripStage.draft : trip.stage,
          clearStartedAt: remaining.isEmpty,
        ),
      );
      if (mounted) {
        setState(() => _saving = false);
        Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) showSaveError(context, l);
    } finally {
      if (mounted && _saving) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.controller.tripById(widget.tripId)!;
    final l = loc(context);
    final amount = parseMinor(_amount.text, _currency);
    final rate = _currency == trip.baseCurrency ? 1.0 : parseRate(_rate.text);
    final booked = amount == null || rate == null
        ? null
        : convertMinor(
            sourceMinor: amount,
            sourceCurrency: _currency,
            baseCurrency: trip.baseCurrency,
            rate: rate,
          );
    return PopScope(
      canPop: !_saving,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.existing == null ? l('addExpense') : l('editExpense'),
          ),
          leading: IconButton(
            key: const Key('form_back'),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: _saving ? null : () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: pageWidth(
          Form(
            key: _form,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
              children: [
                Text(
                  trip.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (trip.destination.isNotEmpty) Text(trip.destination),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('expense_amount'),
                  controller: _amount,
                  autofocus: widget.existing == null,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l('amount'),
                    prefixText: '$_currency ',
                  ),
                  validator: (value) {
                    final parsed = parseMinor(value ?? '', _currency);
                    return parsed == null || parsed <= 0
                        ? l('invalidMoney')
                        : null;
                  },
                ),
                const SizedBox(height: 18),
                Text(
                  l('category'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    for (final item in BudgetCategory.values)
                      ChoiceChip(
                        key: Key('category_${item.name}'),
                        label: Text(l.category(item)),
                        selected: _category == item,
                        onSelected: (_) => setState(() => _category = item),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  key: const Key('expense_currency'),
                  initialValue: _currency,
                  decoration: InputDecoration(labelText: l('currency')),
                  items: [
                    for (final currency in supportedCurrencies)
                      DropdownMenuItem(value: currency, child: Text(currency)),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    final previous = _lastRate(trip, value);
                    setState(() {
                      _currency = value;
                      _rate.text = value == trip.baseCurrency
                          ? '1'
                          : (previous?.rate.toString() ?? '');
                      _rateObservedAt =
                          previous?.rateObservedAt ?? previous?.recordedAt;
                      _settled.clear();
                    });
                  },
                ),
                if (_currency != trip.baseCurrency) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const Key('expense_rate'),
                    controller: _rate,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: l('rate'),
                      helperText: l('rateHint'),
                      helperMaxLines: 2,
                    ),
                    validator: (value) => parseRate(value ?? '') == null
                        ? l('invalidRate')
                        : null,
                    onChanged: (_) => _rateObservedAt = null,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _rateObservedAt == null
                        ? l('rateExplain')
                        : '${l('reusedRate')} ${_rateObservedAt!.year}-${_rateObservedAt!.month.toString().padLeft(2, '0')}-${_rateObservedAt!.day.toString().padLeft(2, '0')} · ${l('rateExplain')}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 12),
                if (booked != null)
                  Text(
                    '${_currency == trip.baseCurrency ? l('confirmed') : l('estimate')}: ${moneyText(booked, trip.baseCurrency)}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                const SizedBox(height: 12),
                TextButton.icon(
                  key: const Key('expense_details_toggle'),
                  onPressed: () =>
                      setState(() => _detailsExpanded = !_detailsExpanded),
                  icon: Icon(
                    _detailsExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  label: Text(l('moreDetails')),
                ),
                if (_detailsExpanded) ...[
                  TextFormField(
                    key: const Key('expense_title'),
                    controller: _title,
                    maxLength: 80,
                    decoration: InputDecoration(
                      labelText: l('expenseTitle'),
                      hintText: l('expenseHint'),
                    ),
                  ),
                  OutlinedButton.icon(
                    key: const Key('expense_date'),
                    onPressed: () async {
                      final selected = await showDatePicker(
                        context: context,
                        initialDate: _expenseDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (selected != null && mounted) {
                        setState(() => _expenseDate = selected);
                      }
                    },
                    icon: const Icon(Icons.today_outlined),
                    label: Text(
                      '${l('expenseDate')}: ${_expenseDate.year}-${_expenseDate.month}-${_expenseDate.day}',
                    ),
                  ),
                  if (_currency != trip.baseCurrency)
                    TextFormField(
                      key: const Key('expense_settled'),
                      controller: _settled,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: l('postedAmount'),
                        prefixText: '${trip.baseCurrency} ',
                        helperText: l('postedHelp'),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return null;
                        final parsed = parseMinor(value, trip.baseCurrency);
                        return parsed == null || parsed <= 0
                            ? l('invalidMoney')
                            : null;
                      },
                    ),
                  TextFormField(
                    key: const Key('expense_note'),
                    controller: _note,
                    maxLength: 240,
                    maxLines: 3,
                    decoration: InputDecoration(labelText: l('note')),
                  ),
                ],
                const SizedBox(height: 16),
                FilledButton(
                  key: const Key('save_expense'),
                  onPressed: _saving ? null : _save,
                  child: Text(l('saveExpense')),
                ),
                if (widget.existing != null) ...[
                  const SizedBox(height: 16),
                  TextButton(
                    key: const Key('delete_expense'),
                    onPressed: _saving ? null : () => _delete(trip, l),
                    child: Text(l('deleteExpense')),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key, required this.controller, required this.tripId});
  final AppController controller;
  final String tripId;

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late final TextEditingController _reflection;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _reflection = TextEditingController(
      text: widget.controller.tripById(widget.tripId)?.reflection ?? '',
    );
  }

  @override
  void dispose() {
    _reflection.dispose();
    super.dispose();
  }

  Future<void> _complete(Trip trip, L l) async {
    setState(() => _saving = true);
    try {
      await widget.controller.upsertTrip(
        trip.copyWith(
          stage: TripStage.completed,
          completedAt: DateTime.now().toUtc(),
          reflection: _reflection.text.trim(),
        ),
      );
      if (mounted) {
        setState(() => _saving = false);
        Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) showSaveError(context, l);
    } finally {
      if (mounted && _saving) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.controller.tripById(widget.tripId)!;
    final l = loc(context);
    return PopScope(
      canPop: !_saving,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l('reviewTitle')),
          leading: IconButton(
            key: const Key('form_back'),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: _saving ? null : () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: pageWidth(
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
            children: [
              Text(
                trip.expenses.isEmpty
                    ? l('incompleteSummary')
                    : '${l('difference')}: ${moneyText(trip.deltaMinor, trip.baseCurrency)}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('reflection'),
                controller: _reflection,
                maxLength: 500,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: l('reflection'),
                  hintText: l('reflectionHint'),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                key: const Key('save_review'),
                onPressed: _saving ? null : () => _complete(trip, l),
                child: Text(l('complete')),
              ),
              const SizedBox(height: 24),
              ComparisonSection(trip: trip, l: l),
            ],
          ),
        ),
      ),
    );
  }
}

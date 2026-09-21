import 'domain.dart';

class L {
  const L(this.zh);
  final bool zh;

  String call(String key) {
    final value = _copy[key];
    if (value == null) throw StateError('Missing translation: $key');
    return zh ? value.$1 : value.$2;
  }

  String category(BudgetCategory item) => call('cat_${item.name}');
  String stage(TripStage item) => call('stage_${item.name}');

  static const Map<String, (String, String)> _copy = {
    'app': ('旅程差额', 'Trip Delta'),
    'tagline': ('先计划，后对照', 'Plan first. Understand later.'),
    'newTrip': ('新建旅程', 'New trip'),
    'otherTrips': ('其他旅程', 'Other trips'),
    'noTrips': ('从一份出发前预算开始', 'Start with a before-trip budget'),
    'noTripsHelp': (
      '按类别写下计划。路上记录实际花费，结束时看清差额。',
      'Set category budgets, record spending, then see where the difference came from.',
    ),
    'privacy': ('隐私与数据', 'Privacy & data'),
    'language': ('语言 / Language', 'Language / 语言'),
    'auto': ('跟随系统', 'System'),
    'zh': ('简体中文', 'Simplified Chinese'),
    'en': ('English', 'English'),
    'save': ('保存', 'Save'),
    'cancel': ('取消', 'Cancel'),
    'retry': ('重试', 'Retry'),
    'loadError': (
      '无法读取本机数据；原文件不会被覆盖。',
      'Local data could not be read; the original file will not be overwritten.',
    ),
    'saveError': (
      '保存失败，未更改现有记录。请重试。',
      'Save failed; existing records are unchanged. Please retry.',
    ),
    'planTitle': ('出发前的计划', 'Before-trip plan'),
    'editPlan': ('编辑预算', 'Edit plan'),
    'tripName': ('旅程名称', 'Trip name'),
    'tripHint': ('例如：秋日京都', 'For example: Autumn in Kyoto'),
    'destination': ('目的地（可选）', 'Destination (optional)'),
    'travelDates': ('旅行日期', 'Travel dates'),
    'localCurrency': ('当地常用币种', 'Local currency'),
    'baseCurrency': ('记账本位币', 'Base currency'),
    'budgetByCat': ('类别预算', 'Category budgets'),
    'budgetHelp': (
      '输入本位币金额；开始记录后将锁定这份计划。',
      'Enter amounts in the base currency. This plan locks when spending starts.',
    ),
    'savePlan': ('保存计划', 'Save plan'),
    'requiredName': (
      '请输入旅程名称（最多 80 字）。',
      'Enter a trip name (up to 80 characters).',
    ),
    'requiredExpense': (
      '请输入支出用途（最多 80 字）。',
      'Enter what this expense was for (up to 80 characters).',
    ),
    'invalidMoney': (
      '请输入有效金额，最多 1,000,000。',
      'Enter a valid amount up to 1,000,000.',
    ),
    'positiveBudget': (
      '至少一个类别需要大于 0 的预算。',
      'At least one category needs a budget above zero.',
    ),
    'stage_draft': ('未出发', 'Planning'),
    'stage_active': ('记录中', 'Recording'),
    'stage_completed': ('已复盘', 'Reviewed'),
    'planned': ('计划', 'Planned'),
    'spent': ('已记录', 'Recorded'),
    'recorded': ('已记录', 'Recorded'),
    'dailyAvailable': ('余下日均可用', 'Available per remaining day'),
    'daysRemaining': ('天', 'days left'),
    'includesEstimates': ('其中估算笔数：', 'Estimated entries:'),
    'estimate': ('估算折算', 'Estimated conversion'),
    'confirmed': ('最终入账', 'Posted amount'),
    'difference': ('差额', 'Difference'),
    'remaining': ('尚余', 'Remaining'),
    'over': ('超出', 'Over plan'),
    'start': ('锁定预算，开始记录', 'Lock plan and start recording'),
    'lockedHelp': (
      '首笔支出已锁定预算。外币按手填汇率估算；可在入账后补录最终金额。',
      'The first expense locked the budget. Foreign amounts are estimates until you enter the posted amount.',
    ),
    'expenseList': ('逐笔支出', 'Expenses'),
    'noExpenses': (
      '还没有支出记录。差额暂不代表真实结余。',
      'No expenses recorded yet. The difference is not a verified saving.',
    ),
    'addExpense': ('记录一笔支出', 'Add expense'),
    'editExpense': ('编辑支出', 'Edit expense'),
    'expenseTitle': ('用途', 'What was it for?'),
    'expenseHint': ('例如：晚餐', 'For example: Dinner'),
    'moreDetails': ('用途、日期与入账金额', 'Purpose, date & posted amount'),
    'expenseDate': ('消费日期', 'Expense date'),
    'postedAmount': ('最终入账金额（可选）', 'Posted amount (optional)'),
    'postedHelp': (
      '以本位币填写银行卡或账单的最终金额。',
      'Enter the final card or statement amount in the base currency.',
    ),
    'reusedRate': ('沿用上次手填汇率', 'Reusing manual rate from'),
    'category': ('类别', 'Category'),
    'amount': ('金额', 'Amount'),
    'currency': ('支出币种', 'Expense currency'),
    'rate': ('手填汇率', 'Entered exchange rate'),
    'rateHint': (
      '1 支出币种 = 多少本位币',
      '1 expense currency unit = base currency units',
    ),
    'rateExplain': (
      '仅用于本次预算对照；不是实时汇率或支付建议。',
      'For this comparison only; not a live rate or payment advice.',
    ),
    'note': ('备注（可选）', 'Note (optional)'),
    'invalidRate': (
      '请输入大于 0 且不超过 1000 的汇率。',
      'Enter a rate above 0 and up to 1000.',
    ),
    'saveExpense': ('保存支出', 'Save expense'),
    'deleteExpense': ('删除这笔支出', 'Delete expense'),
    'finish': ('完成并复盘', 'Finish and review'),
    'reviewTitle': ('旅程复盘', 'Trip review'),
    'reflection': (
      '下次会怎样计划？（可选）',
      'What would you plan differently? (optional)',
    ),
    'reflectionHint': ('记录造成差额的原因', 'Note what caused the difference'),
    'complete': ('保存复盘', 'Save review'),
    'reopen': ('重新打开并纠错', 'Reopen to correct'),
    'copySummary': ('复制文字总结', 'Copy summary'),
    'copied': ('已复制总结', 'Summary copied'),
    'deleteTrip': ('删除旅程', 'Delete trip'),
    'deleteTripQuestion': (
      '永久删除这段旅程及全部支出？',
      'Permanently delete this trip and all expenses?',
    ),
    'deleteExpenseQuestion': ('永久删除这笔支出？', 'Permanently delete this expense?'),
    'delete': ('删除', 'Delete'),
    'largestDriver': ('最大超支类别', 'Largest over-plan category'),
    'mainExpenses': ('主要支出', 'Main expenses'),
    'repeatPlan': ('沿用这份计划', 'Reuse this plan'),
    'noOverage': ('没有类别超出预算', 'No category is over plan'),
    'incompleteSummary': ('记录尚不完整', 'Records may be incomplete'),
    'entryCount': ('支出笔数', 'Expenses recorded'),
    'localOnly': ('保存在本机应用空间', 'Saved in app storage'),
    'privacyBody': (
      '旅程、预算、支出与复盘保存在本机应用私有文件中。应用没有账号、后台、广告或分析服务，也不会主动上传记录。如果您开启系统设备备份，记录可能包含在备份中。删除旅程会从应用中移除记录，但既有系统备份可能保留旧副本；卸载应用可能丢失本机数据。目前不提供备份导入。复制总结会将文字放入系统剪贴板，由系统和您选择的其他应用管理。汇率由您输入，仅用于算术对照。',
      'Trips, budgets, expenses, and reviews are saved in app-private files on this device. The app has no account, backend, ads, or analytics and does not upload entries itself. If device backup is enabled, records may be included in that backup. Deleting a trip removes it from the app, but an existing system backup may retain an older copy; uninstalling may erase local data. Backup import is not available. Copying a summary puts text on the system clipboard, which the system and apps you choose may handle. Exchange rates are user entered and used only for arithmetic comparison.',
    ),
    'cat_stay': ('住宿', 'Stay'),
    'cat_transport': ('交通', 'Transport'),
    'cat_food': ('餐饮', 'Food'),
    'cat_experiences': ('体验', 'Experiences'),
    'cat_other': ('其他', 'Other'),
  };
}

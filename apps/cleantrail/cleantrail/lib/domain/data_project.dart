enum IssueKind {
  missingValue,
  duplicateRow,
  surroundingWhitespace,
  inconsistentType,
  inconsistentDate,
}

enum IssueStatus { open, fixed, ignored }

class DataRecord {
  const DataRecord({required this.id, required this.values});

  final String id;
  final List<String> values;

  DataRecord copyWith({List<String>? values}) =>
      DataRecord(id: id, values: values ?? this.values);

  Map<String, Object> toJson() => {'id': id, 'values': values};

  factory DataRecord.fromJson(Map<String, dynamic> json) => DataRecord(
    id: json['id'] as String,
    values: List<String>.from(json['values'] as List),
  );
}

class DataIssue {
  const DataIssue({
    required this.id,
    required this.kind,
    required this.rowId,
    required this.columnIndex,
    required this.originalValue,
    required this.suggestion,
    this.status = IssueStatus.open,
  });

  final String id;
  final IssueKind kind;
  final String rowId;
  final int? columnIndex;
  final String originalValue;
  final String? suggestion;
  final IssueStatus status;

  DataIssue copyWith({String? id, IssueStatus? status}) => DataIssue(
    id: id ?? this.id,
    kind: kind,
    rowId: rowId,
    columnIndex: columnIndex,
    originalValue: originalValue,
    suggestion: suggestion,
    status: status ?? this.status,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'kind': kind.name,
    'rowId': rowId,
    'columnIndex': columnIndex,
    'originalValue': originalValue,
    'suggestion': suggestion,
    'status': status.name,
  };

  factory DataIssue.fromJson(Map<String, dynamic> json) => DataIssue(
    id: json['id'] as String,
    kind: IssueKind.values.byName(json['kind'] as String),
    rowId: json['rowId'] as String,
    columnIndex: json['columnIndex'] as int?,
    originalValue: json['originalValue'] as String,
    suggestion: json['suggestion'] as String?,
    status: IssueStatus.values.byName(json['status'] as String),
  );
}

class AuditAction {
  const AuditAction({
    required this.issueId,
    required this.kind,
    required this.rowId,
    required this.columnName,
    required this.action,
    required this.fromValue,
    required this.toValue,
    required this.occurredAt,
  });

  final String issueId;
  final IssueKind kind;
  final String rowId;
  final String columnName;
  final String action;
  final String fromValue;
  final String toValue;
  final DateTime occurredAt;

  Map<String, Object> toJson() => {
    'issueId': issueId,
    'kind': kind.name,
    'rowId': rowId,
    'columnName': columnName,
    'action': action,
    'fromValue': fromValue,
    'toValue': toValue,
    'occurredAt': occurredAt.toIso8601String(),
  };

  factory AuditAction.fromJson(Map<String, dynamic> json) => AuditAction(
    issueId: json['issueId'] as String,
    kind: IssueKind.values.byName(json['kind'] as String),
    rowId: json['rowId'] as String,
    columnName: json['columnName'] as String,
    action: json['action'] as String,
    fromValue: json['fromValue'] as String,
    toValue: json['toValue'] as String,
    occurredAt: DateTime.parse(json['occurredAt'] as String),
  );
}

class DataProject {
  const DataProject({
    required this.id,
    required this.fileName,
    required this.headers,
    required this.originalRecords,
    required this.records,
    required this.issues,
    required this.audit,
    required this.importedAt,
    required this.updatedAt,
  });

  final String id;
  final String fileName;
  final List<String> headers;
  final List<DataRecord> originalRecords;
  final List<DataRecord> records;
  final List<DataIssue> issues;
  final List<AuditAction> audit;
  final DateTime importedAt;
  final DateTime updatedAt;

  List<DataIssue> get openIssues =>
      issues.where((issue) => issue.status == IssueStatus.open).toList();

  int get fixedCount =>
      issues.where((issue) => issue.status == IssueStatus.fixed).length;

  int get ignoredCount =>
      issues.where((issue) => issue.status == IssueStatus.ignored).length;

  int get remainingDefectCount =>
      issues.where((issue) => issue.status != IssueStatus.fixed).length;

  int get qualityScore {
    final cells = (records.length * headers.length).clamp(1, 1000000000);
    final penalty = (remainingDefectCount * 100 / cells).round();
    return (100 - penalty).clamp(0, 100);
  }

  DataProject copyWith({
    List<DataRecord>? records,
    List<DataIssue>? issues,
    List<AuditAction>? audit,
    DateTime? updatedAt,
  }) => DataProject(
    id: id,
    fileName: fileName,
    headers: headers,
    originalRecords: originalRecords,
    records: records ?? this.records,
    issues: issues ?? this.issues,
    audit: audit ?? this.audit,
    importedAt: importedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  Map<String, Object> toJson() => {
    'schemaVersion': 1,
    'id': id,
    'fileName': fileName,
    'headers': headers,
    'originalRecords': originalRecords.map((row) => row.toJson()).toList(),
    'records': records.map((row) => row.toJson()).toList(),
    'issues': issues.map((issue) => issue.toJson()).toList(),
    'audit': audit.map((action) => action.toJson()).toList(),
    'importedAt': importedAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory DataProject.fromJson(Map<String, dynamic> json) => DataProject(
    id: json['id'] as String,
    fileName: json['fileName'] as String,
    headers: List<String>.from(json['headers'] as List),
    originalRecords: (json['originalRecords'] as List)
        .map((row) => DataRecord.fromJson(Map<String, dynamic>.from(row)))
        .toList(),
    records: (json['records'] as List)
        .map((row) => DataRecord.fromJson(Map<String, dynamic>.from(row)))
        .toList(),
    issues: (json['issues'] as List)
        .map((issue) => DataIssue.fromJson(Map<String, dynamic>.from(issue)))
        .toList(),
    audit: (json['audit'] as List)
        .map(
          (action) => AuditAction.fromJson(Map<String, dynamic>.from(action)),
        )
        .toList(),
    importedAt: DateTime.parse(json['importedAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );
}

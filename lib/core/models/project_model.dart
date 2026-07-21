class ProjectModel {
  final String id;
  final String title;
  final String pdfPath;
  final int currentRow;
  final int currentStitch;
  final int currentPage;
  final double highlighterY;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime lastAccessedAt;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.pdfPath,
    this.currentRow = 0,
    this.currentStitch = 0,
    this.currentPage = 1,
    this.highlighterY = 100.0,
    this.isCompleted = false,
    required this.createdAt,
    required this.lastAccessedAt,
  });

  ProjectModel copyWith({
    String? id,
    String? title,
    String? pdfPath,
    int? currentRow,
    int? currentStitch,
    int? currentPage,
    double? highlighterY,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? lastAccessedAt,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      pdfPath: pdfPath ?? this.pdfPath,
      currentRow: currentRow ?? this.currentRow,
      currentStitch: currentStitch ?? this.currentStitch,
      currentPage: currentPage ?? this.currentPage,
      highlighterY: highlighterY ?? this.highlighterY,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'pdfPath': pdfPath,
      'currentRow': currentRow,
      'currentStitch': currentStitch,
      'currentPage': currentPage,
      'highlighterY': highlighterY,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'lastAccessedAt': lastAccessedAt.toIso8601String(),
    };
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      title: json['title'] as String,
      pdfPath: json['pdfPath'] as String,
      currentRow: json['currentRow'] as int? ?? 0,
      currentStitch: json['currentStitch'] as int? ?? 0,
      currentPage: json['currentPage'] as int? ?? 1,
      highlighterY: (json['highlighterY'] as num?)?.toDouble() ?? 100.0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastAccessedAt: DateTime.parse(json['lastAccessedAt'] as String),
    );
  }
}

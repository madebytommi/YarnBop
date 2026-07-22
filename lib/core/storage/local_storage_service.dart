import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/project_model.dart';
import '../../features/pattern_rows/data/models/pattern_row.dart';

/// Hive Local Storage Service for auto-saving pattern workspace states.
class LocalStorageService {
  static const String projectsBoxName = 'projects_box';
  static const String patternRowsBoxName = 'pattern_rows_box';

  Box get _box => Hive.box(projectsBoxName);
  Box get _patternRowsBox => Hive.box(patternRowsBoxName);

  /// Initializes Hive Flutter and opens the projects and pattern rows boxes.
  static Future<void> initHive() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(PatternRowAdapter());
    }
    await Hive.openBox(projectsBoxName);
    await Hive.openBox(patternRowsBoxName);
  }

  /// Retrieves saved pattern rows by project ID from Hive.
  List<PatternRow> getPatternRows(String projectId) {
    if (!Hive.isBoxOpen(patternRowsBoxName)) return [];
    final raw = _patternRowsBox.get(projectId);
    if (raw == null) return [];
    if (raw is List) {
      return raw.cast<PatternRow>();
    }
    return [];
  }

  /// Saves or updates a list of pattern rows in Hive.
  Future<void> savePatternRows(String projectId, List<PatternRow> rows) async {
    if (!Hive.isBoxOpen(patternRowsBoxName)) return;
    await _patternRowsBox.put(projectId, rows);
  }

  /// Retrieves a saved project by ID from Hive box.
  ProjectModel? getProject(String projectId) {
    if (!Hive.isBoxOpen(projectsBoxName)) return null;
    final raw = _box.get(projectId);
    if (raw == null) return null;
    if (raw is String) {
      return ProjectModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } else if (raw is Map) {
      return ProjectModel.fromJson(Map<String, dynamic>.from(raw));
    }
    return null;
  }

  /// Saves or updates a project model in Hive.
  Future<void> saveProject(ProjectModel project) async {
    if (!Hive.isBoxOpen(projectsBoxName)) return;
    final jsonStr = jsonEncode(project.toJson());
    await _box.put(project.id, jsonStr);
  }

  /// Deletes a project from Hive box by ID.
  Future<void> deleteProject(String projectId) async {
    if (!Hive.isBoxOpen(projectsBoxName)) return;
    await _box.delete(projectId);
  }

  /// Loads all saved projects sorted by last accessed date.
  List<ProjectModel> getAllProjects() {
    if (!Hive.isBoxOpen(projectsBoxName)) return [];
    final List<ProjectModel> list = [];
    for (var key in _box.keys) {
      final item = getProject(key.toString());
      if (item != null) {
        list.add(item);
      }
    }
    list.sort((a, b) => b.lastAccessedAt.compareTo(a.lastAccessedAt));
    return list;
  }

  /// Auto-saves row and stitch counts directly into Hive.
  Future<void> autoSaveCounters({
    required String projectId,
    required int rowCount,
    required int stitchCount,
  }) async {
    final existing = getProject(projectId);
    final updated = (existing ??
            ProjectModel(
              id: projectId,
              title: 'Pattern Project',
              pdfPath: '',
              createdAt: DateTime.now(),
              lastAccessedAt: DateTime.now(),
            ))
        .copyWith(
      currentRow: rowCount,
      currentStitch: stitchCount,
      lastAccessedAt: DateTime.now(),
    );
    await saveProject(updated);
  }

  /// Auto-saves highlighter Y position directly into Hive.
  Future<void> autoSaveHighlighterY({
    required String projectId,
    required double highlighterY,
  }) async {
    final existing = getProject(projectId);
    final updated = (existing ??
            ProjectModel(
              id: projectId,
              title: 'Pattern Project',
              pdfPath: '',
              createdAt: DateTime.now(),
              lastAccessedAt: DateTime.now(),
            ))
        .copyWith(
      highlighterY: highlighterY,
      lastAccessedAt: DateTime.now(),
    );
    await saveProject(updated);
  }

  /// Auto-saves active PDF page index directly into Hive.
  Future<void> autoSaveCurrentPage({
    required String projectId,
    required int currentPage,
  }) async {
    final existing = getProject(projectId);
    final updated = (existing ??
            ProjectModel(
              id: projectId,
              title: 'Pattern Project',
              pdfPath: '',
              createdAt: DateTime.now(),
              lastAccessedAt: DateTime.now(),
            ))
        .copyWith(
      currentPage: currentPage,
      lastAccessedAt: DateTime.now(),
    );
    await saveProject(updated);
  }
}

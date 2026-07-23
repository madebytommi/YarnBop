import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import '../models/project_model.dart';
import '../../features/pattern_rows/data/models/pattern_row.dart';

/// Hive Local Storage Service for auto-saving pattern workspace states.
class LocalStorageService {
  static const String projectsBoxName = 'projects_box';
  static const String patternRowsBoxName = 'pattern_rows_box';

  static late String appDocDirPath;
  
  static final Map<String, Future<void>> _saveLocks = {};

  Box get _box => Hive.box(projectsBoxName);
  Box get _patternRowsBox => Hive.box(patternRowsBoxName);

  /// Initializes Hive Flutter and opens the projects and pattern rows boxes with AES encryption.
  static Future<void> initHive() async {
    final dir = await getApplicationDocumentsDirectory();
    appDocDirPath = dir.path;

    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(PatternRowAdapter());
    }

    // Set up Secure Storage for the encryption key
    const secureStorage = FlutterSecureStorage();
    List<int> encryptionKey;
    
    try {
      final keyString = await secureStorage.read(key: 'hive_encryption_key');
      if (keyString == null) {
        final key = Hive.generateSecureKey();
        await secureStorage.write(
          key: 'hive_encryption_key',
          value: base64UrlEncode(key),
        );
        encryptionKey = key;
      } else {
        encryptionKey = base64Url.decode(keyString);
      }
    } catch (e) {
      // Fallback if Keystore fails (common Android edge case)
      encryptionKey = Hive.generateSecureKey();
    }

    final cipher = HiveAesCipher(encryptionKey);

    // Open projects box (delete and recreate if legacy unencrypted data exists)
    try {
      await Hive.openBox(projectsBoxName, encryptionCipher: cipher);
    } catch (e) {
      await Hive.deleteBoxFromDisk(projectsBoxName);
      await Hive.openBox(projectsBoxName, encryptionCipher: cipher);
    }

    // Open pattern rows box (delete and recreate if legacy unencrypted data exists)
    try {
      await Hive.openBox(patternRowsBoxName, encryptionCipher: cipher);
    } catch (e) {
      await Hive.deleteBoxFromDisk(patternRowsBoxName);
      await Hive.openBox(patternRowsBoxName, encryptionCipher: cipher);
    }
  }

  /// Reconstructs the absolute path from a stored relative path or filename.
  static String getAbsolutePdfPath(String relativePath) {
    if (relativePath.isEmpty) return '';
    // If it's already an absolute path (legacy support), return it
    if (File(relativePath).isAbsolute) return relativePath;
    return '$appDocDirPath/$relativePath';
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

  /// Atomically updates a project model to prevent race conditions during rapid saves.
  Future<void> updateProjectAtomic(
    String projectId,
    ProjectModel Function(ProjectModel) updater,
  ) async {
    while (_saveLocks[projectId] != null) {
      await _saveLocks[projectId];
    }
    final completer = Completer<void>();
    _saveLocks[projectId] = completer.future;

    try {
      final existing = getProject(projectId) ?? ProjectModel.empty(projectId);
      final updated = updater(existing);
      await saveProject(updated);
    } finally {
      _saveLocks.remove(projectId);
      completer.complete();
    }
  }

  /// Auto-saves row and stitch counts securely via the atomic lock.
  Future<void> autoSaveCounters({
    required String projectId,
    required int rowCount,
    required int stitchCount,
  }) async {
    await updateProjectAtomic(
      projectId,
      (existing) => existing.copyWith(
        currentRow: rowCount,
        currentStitch: stitchCount,
        lastAccessedAt: DateTime.now(),
      ),
    );
  }

  /// Auto-saves highlighter Y position securely via the atomic lock.
  Future<void> autoSaveHighlighterY({
    required String projectId,
    required double highlighterY,
  }) async {
    await updateProjectAtomic(
      projectId,
      (existing) => existing.copyWith(
        highlighterY: highlighterY,
        lastAccessedAt: DateTime.now(),
      ),
    );
  }

  /// Auto-saves active PDF page index securely via the atomic lock.
  Future<void> autoSaveCurrentPage({
    required String projectId,
    required int currentPage,
  }) async {
    await updateProjectAtomic(
      projectId,
      (existing) => existing.copyWith(
        currentPage: currentPage,
        lastAccessedAt: DateTime.now(),
      ),
    );
  }
}

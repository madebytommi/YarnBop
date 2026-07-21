import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project_model.dart';

/// Local Storage Service for auto-saving row counts, stitch counts, and page positions
class LocalStorageService {
  static const String _projectsKey = 'yarnbop_projects';

  Future<List<ProjectModel>> loadProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_projectsKey);
    if (data == null || data.isEmpty) return [];

    final List<dynamic> decoded = jsonDecode(data);
    return decoded.map((item) => ProjectModel.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<void> saveProjects(List<ProjectModel> projects) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(projects.map((p) => p.toJson()).toList());
    await prefs.setString(_projectsKey, encoded);
  }

  Future<void> saveSingleProject(ProjectModel project) async {
    final projects = await loadProjects();
    final index = projects.indexWhere((p) => p.id == project.id);
    if (index >= 0) {
      projects[index] = project;
    } else {
      projects.add(project);
    }
    await saveProjects(projects);
  }
}

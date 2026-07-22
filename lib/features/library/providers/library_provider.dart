import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/project_model.dart';
import '../../../core/storage/local_storage_service.dart';

final localStorageProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final libraryNotifierProvider =
    StateNotifierProvider<LibraryNotifier, List<ProjectModel>>((ref) {
  final storage = ref.watch(localStorageProvider);
  return LibraryNotifier(storage);
});

class LibraryNotifier extends StateNotifier<List<ProjectModel>> {
  final LocalStorageService _storage;

  LibraryNotifier(this._storage) : super([]) {
    loadProjects();
  }

  void loadProjects() {
    state = _storage.getAllProjects();
  }

  Future<void> addProject(ProjectModel project) async {
    await _storage.saveProject(project);
    loadProjects();
  }

  Future<void> updateProject(ProjectModel updatedProject) async {
    await _storage.saveProject(updatedProject);
    loadProjects();
  }

  Future<void> deleteProject(String id) async {
    await _storage.deleteProject(id);
    loadProjects();
  }
}

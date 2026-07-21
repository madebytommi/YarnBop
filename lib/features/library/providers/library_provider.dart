import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/project_model.dart';
import '../../../core/storage/local_storage_service.dart';

final localStorageProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

final libraryNotifierProvider = StateNotifierProvider<LibraryNotifier, List<ProjectModel>>((ref) {
  final storage = ref.watch(localStorageProvider);
  return LibraryNotifier(storage);
});

class LibraryNotifier extends StateNotifier<List<ProjectModel>> {
  final LocalStorageService _storage;

  LibraryNotifier(this._storage) : super([]) {
    loadProjects();
  }

  Future<void> loadProjects() async {
    state = await _storage.loadProjects();
  }

  Future<void> addProject(ProjectModel project) async {
    state = [...state, project];
    await _storage.saveSingleProject(project);
  }

  Future<void> updateProject(ProjectModel updatedProject) async {
    state = [
      for (final p in state)
        if (p.id == updatedProject.id) updatedProject else p
    ];
    await _storage.saveSingleProject(updatedProject);
  }

  Future<void> deleteProject(String id) async {
    state = state.where((p) => p.id != id).toList();
    await _storage.saveProjects(state);
  }
}

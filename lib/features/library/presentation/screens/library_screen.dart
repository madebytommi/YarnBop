import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/project_model.dart';
import '../../../pattern_rows/presentation/screens/text_import_screen.dart';
import '../../../pdf_reader/presentation/screens/pdf_reader_screen.dart';
import '../../providers/library_provider.dart';
import '../widgets/project_card.dart';

/// LibraryScreen serving as the front door of YarnBop.
/// Displays active pattern projects from Hive, integrates file_picker for local PDF import,
/// and launches the interactive PdfReaderScreen workspace.
class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(libraryNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundCanvas, // #F5F8FA
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue, // Classic Web Blue #1DA1F2
        elevation: 2.0, // 2010s drop shadow line
        title: const Text(
          'YarnBop — Pattern Library',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.text_snippet_outlined, color: Colors.white),
            tooltip: 'Import Text Pattern',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TextImportScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.note_add_outlined, color: Colors.white),
            tooltip: 'Import PDF Pattern',
            onPressed: () => _pickAndImportPdf(context, ref),
          ),
        ],
      ),
      body: projects.isEmpty
          ? _buildEmptyState(context, ref)
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return ProjectCard(
                  project: project,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PdfReaderScreen(projectId: project.id),
                      ),
                    );
                  },
                  onDelete: () {
                    _confirmDelete(context, ref, project);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFF0C85D0), width: 1.0),
          borderRadius: BorderRadius.circular(4.0),
        ),
        icon: const Icon(Icons.add),
        label: const Text(
          'New Project',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () => _pickAndImportPdf(context, ref),
      ),
    );
  }

  /// Triggers file_picker to select a PDF file from Android device storage
  Future<void> _pickAndImportPdf(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final file = result.files.single;
        final String filePath = file.path!;
        final String fileName = file.name.replaceAll('.pdf', '');

        final newProject = ProjectModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: fileName.isNotEmpty ? fileName : 'Pattern Project',
          pdfPath: filePath,
          createdAt: DateTime.now(),
          lastAccessedAt: DateTime.now(),
        );

        // Save to Hive
        await ref.read(libraryNotifierProvider.notifier).addProject(newProject);

        // Automatically launch PDF workspace
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PdfReaderScreen(projectId: newProject.id),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick PDF file: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20.0),
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          border: Border.all(color: AppColors.borderGray, width: 1.0),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.picture_as_pdf,
                size: 48,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'No Patterns Imported Yet',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.textDarkCharcoal,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Import an external PDF pattern from your device storage to start tracking line-by-line.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.0,
                color: AppColors.textMutedGray,
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton.icon(
              onPressed: () => _pickAndImportPdf(context, ref),
              icon: const Icon(Icons.file_upload_outlined),
              label: const Text('Import PDF Pattern'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, ProjectModel project) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text(
          'Delete Pattern Project?',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDarkCharcoal),
        ),
        content: Text('Are you sure you want to remove "${project.title}" from your library?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(libraryNotifierProvider.notifier).deleteProject(project.id);
              Navigator.pop(dialogCtx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}

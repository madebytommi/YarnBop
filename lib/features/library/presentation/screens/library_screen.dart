import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/project_model.dart';
import '../../providers/library_provider.dart';
import '../widgets/project_card.dart';
import '../../../pdf_reader/presentation/screens/pdf_reader_screen.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(libraryNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('YarnBop — Pattern Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Import PDF Pattern',
            onPressed: () => _handleImportPdf(context, ref),
          ),
        ],
      ),
      body: projects.isEmpty
          ? Center(
              child: Container(
                margin: const EdgeInsets.all(24.0),
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  border: Border.all(color: AppColors.borderGray, width: 1.0),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.note_add_outlined,
                      size: 48,
                      color: AppColors.primaryBlue,
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'No PDF Patterns Loaded',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDarkCharcoal,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Import external PDF patterns from Etsy, Ravelry, or device storage to start tracking line-by-line.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: AppColors.textMutedGray,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton.icon(
                      onPressed: () => _handleImportPdf(context, ref),
                      icon: const Icon(Icons.file_upload_outlined),
                      label: const Text('Import PDF Pattern'),
                    ),
                  ],
                ),
              ),
            )
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
                    ref.read(libraryNotifierProvider.notifier).deleteProject(project.id);
                  },
                );
              },
            ),
    );
  }

  void _handleImportPdf(BuildContext context, WidgetRef ref) async {
    // Demo import dialog for pattern selection (file_picker will be hooked up when dependencies added)
    final titleController = TextEditingController();
    final pathController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Import PDF Pattern', style: TextStyle(color: AppColors.textDarkCharcoal, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Pattern Name (e.g. Sweater Pattern)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: pathController,
              decoration: const InputDecoration(
                labelText: 'PDF Local File Path',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final newProject = ProjectModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  pdfPath: pathController.text.isNotEmpty ? pathController.text : 'demo_pattern.pdf',
                  createdAt: DateTime.now(),
                  lastAccessedAt: DateTime.now(),
                );
                ref.read(libraryNotifierProvider.notifier).addProject(newProject);
                Navigator.pop(dialogCtx);
              }
            },
            child: const Text('Add Pattern'),
          ),
        ],
      ),
    );
  }
}

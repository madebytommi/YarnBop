import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../providers/pattern_rows_provider.dart';

/// Interactive Viewer Screen for displaying and tracking PatternRow steps.
class PatternRowViewerScreen extends ConsumerWidget {
  final String projectId;

  const PatternRowViewerScreen({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rows = ref.watch(patternRowsNotifierProvider(projectId));
    final completedCount = rows.where((r) => r.isCompleted).length;

    return Scaffold(
      backgroundColor: AppColors.backgroundCanvas, // #F5F8FA
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue, // #1DA1F2
        elevation: 2.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Interactive Pattern Viewer',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: rows.isEmpty
          ? const Center(
              child: Text(
                'No pattern rows generated yet.',
                style: TextStyle(color: AppColors.textMutedGray),
              ),
            )
          : Column(
              children: [
                // Header progress summary bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Completed: $completedCount / ${rows.length} rows',
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDarkCharcoal,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          '${((completedCount / rows.length) * 100).toInt()}% Done',
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppColors.borderGray),
                // List of Pattern Rows
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: rows.length,
                    itemBuilder: (context, index) {
                      final row = rows[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        decoration: BoxDecoration(
                          color: row.isCompleted
                              ? AppColors.highlighterYellow.withValues(alpha: 0.3)
                              : AppColors.cardBackground,
                          border: Border.all(
                            color: row.isCompleted
                                ? AppColors.highlighterBorder
                                : AppColors.borderGray,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: CheckboxListTile(
                          value: row.isCompleted,
                          activeColor: AppColors.primaryBlue,
                          onChanged: (_) {
                            ref
                                .read(patternRowsNotifierProvider(projectId).notifier)
                                .toggleRowCompletion(row.rowNumber);
                          },
                          title: Text(
                            'Row ${row.rowNumber}',
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                              color: row.isCompleted
                                  ? AppColors.textMutedGray
                                  : AppColors.textDarkCharcoal,
                            ),
                          ),
                          subtitle: Text(
                            row.instruction,
                            style: TextStyle(
                              fontSize: 14.0,
                              decoration: row.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: row.isCompleted
                                  ? AppColors.textMutedGray
                                  : AppColors.textDarkCharcoal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

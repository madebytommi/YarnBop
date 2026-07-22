import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/pattern_row.dart';
import '../../providers/pattern_rows_provider.dart';

/// TextPatternViewerScreen displays the List<PatternRow> from Riverpod using a ListView.builder.
/// Employs Riverpod's .select() optimization on list items so tapping a row only rebuilds
/// that specific item widget, rather than the entire list.
class TextPatternViewerScreen extends ConsumerWidget {
  final String projectId;

  const TextPatternViewerScreen({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Select ONLY the total row count to build the ListView structure
    final rowCount = ref.watch(
      patternRowsNotifierProvider(projectId).select((rows) => rows.length),
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundCanvas, // #F5F8FA
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue, // #1DA1F2
        elevation: 2.0, // 2010s drop shadow line
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pattern Step Viewer',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: rowCount == 0
          ? const Center(
              child: Text(
                'No pattern rows found.',
                style: TextStyle(color: AppColors.textMutedGray, fontSize: 14.0),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: rowCount,
              itemBuilder: (context, index) {
                return _PatternRowTile(
                  projectId: projectId,
                  index: index,
                );
              },
            ),
    );
  }
}

/// Individual tappable row tile widget.
/// Listens ONLY to changes for its specific index via .select().
class _PatternRowTile extends ConsumerWidget {
  final String projectId;
  final int index;

  const _PatternRowTile({
    required this.projectId,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use Riverpod .select() to watch ONLY this specific index in the List<PatternRow>
    final PatternRow row = ref.watch(
      patternRowsNotifierProvider(projectId).select((rows) => rows[index]),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        // Retro yellow highlight if completed, white background if incomplete
        color: row.isCompleted
            ? AppColors.highlighterYellow // Retro yellow highlight #FFF9C4
            : AppColors.cardBackground, // White #FFFFFF
        border: Border.all(
          color: row.isCompleted
              ? AppColors.highlighterBorder
              : AppColors.borderGray, // 1px solid border
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2.0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4.0),
          onTap: () {
            // Toggle isCompleted status via Riverpod notifier
            ref
                .read(patternRowsNotifierProvider(projectId).notifier)
                .toggleRowCompletion(row.rowNumber);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row Number Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: row.isCompleted
                        ? AppColors.highlighterBorder.withValues(alpha: 0.3)
                        : AppColors.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(3.0),
                    border: Border.all(
                      color: row.isCompleted
                          ? AppColors.highlighterBorder
                          : AppColors.primaryBlue.withValues(alpha: 0.3),
                      width: 1.0,
                    ),
                  ),
                  child: Text(
                    'Row ${row.rowNumber}',
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: row.isCompleted
                          ? const Color(0xFF6B5E00)
                          : AppColors.primaryBlue,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                // Instruction Text
                Expanded(
                  child: Text(
                    row.instruction,
                    style: TextStyle(
                      fontSize: 14.0,
                      height: 1.3,
                      fontWeight: row.isCompleted
                          ? FontWeight.w500
                          : FontWeight.normal,
                      color: row.isCompleted
                          ? const Color(0xFF4A4200)
                          : AppColors.textDarkCharcoal,
                      decoration: row.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                // Checkmark Status Icon
                Icon(
                  row.isCompleted
                      ? Icons.check_box_outlined
                      : Icons.check_box_outline_blank,
                  color: row.isCompleted
                      ? const Color(0xFF6B5E00)
                      : AppColors.textMutedGray,
                  size: 22.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

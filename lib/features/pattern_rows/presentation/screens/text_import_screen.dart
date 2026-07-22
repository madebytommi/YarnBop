import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/pattern_row_parser.dart';
import '../../providers/pattern_rows_provider.dart';
import 'text_pattern_viewer_screen.dart';

/// TextImportScreen featuring a multi-line TextField for pasting raw pattern text.
/// Styled strictly with 2010s web nostalgia aesthetics: white container backgrounds,
/// 1px solid borders, and #1DA1F2 header bar.
class TextImportScreen extends ConsumerStatefulWidget {
  final String projectId;

  const TextImportScreen({
    super.key,
    this.projectId = 'text_pattern_project',
  });

  @override
  ConsumerState<TextImportScreen> createState() => _TextImportScreenState();
}

class _TextImportScreenState extends ConsumerState<TextImportScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _generatePattern() async {
    final rawText = _textController.text;
    final parsedRows = parsePatternRows(rawText);

    if (parsedRows.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter or paste pattern text with at least one valid line.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Save parsed list to Riverpod state & Hive
    await ref
        .read(patternRowsNotifierProvider(widget.projectId).notifier)
        .setRows(parsedRows);

    if (mounted) {
      // Navigate to interactive pattern row viewer screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TextPatternViewerScreen(projectId: widget.projectId),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'Import Text Pattern',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // White Container Card with 1px solid border
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.cardBackground, // Pure White #FFFFFF
                border: Border.all(color: AppColors.borderGray, width: 1.0), // 1px solid #E6E6E6
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Paste Written Pattern Instructions',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDarkCharcoal,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  const Text(
                    'Each line will automatically be parsed into a sequential row step.',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: AppColors.textMutedGray,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Large Multi-line TextField
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(color: AppColors.borderGray, width: 1.0),
                    ),
                    child: TextField(
                      controller: _textController,
                      maxLines: 12,
                      minLines: 8,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: AppColors.textDarkCharcoal,
                        height: 1.4,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Paste pattern text here...\n\ne.g.\nRow 1: K2, P2 across\nRow 2: P2, K2 across\nRow 3: K2TOG, YO, K4',
                        hintStyle: TextStyle(
                          color: AppColors.textMutedGray,
                          fontSize: 13.0,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            // 'Generate Pattern' Button
            ElevatedButton(
              onPressed: _generatePattern,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue, // #1DA1F2
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Color(0xFF0C85D0), width: 1.0),
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Generate Pattern',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

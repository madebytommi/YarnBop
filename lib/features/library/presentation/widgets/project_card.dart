import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/project_model.dart';

/// Project Card Widget adhering strictly to DESIGN_SYSTEM.md.
/// Features a pure white (#FFFFFF) background, a 1px solid soft gray (#E6E6E6) border,
/// sharp 4px corners, simple PDF icon placeholder, file title, and workspace metadata.
class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground, // Pure White #FFFFFF
        border: Border.all(color: AppColors.borderGray, width: 1.0), // #E6E6E6 border
        borderRadius: BorderRadius.circular(4.0), // Max 4px corner radius
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4.0),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              // PDF Placeholder Icon Container
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(4.0),
                  border: Border.all(
                    color: AppColors.primaryBlue.withValues(alpha: 0.25),
                    width: 1.0,
                  ),
                ),
                child: const Icon(
                  Icons.picture_as_pdf_outlined,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
              ),

              const SizedBox(width: 14.0),

              // Title and Workspace Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDarkCharcoal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Row: ${project.currentRow}  •  Stitch: ${project.currentStitch}  •  Page ${project.currentPage}',
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: AppColors.textMutedGray,
                      ),
                    ),
                  ],
                ),
              ),

              // Action Buttons
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.textMutedGray,
                  size: 20,
                ),
                tooltip: 'Delete Pattern',
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

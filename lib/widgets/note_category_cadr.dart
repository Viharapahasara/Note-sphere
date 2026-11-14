import 'package:flutter/material.dart';
import 'package:notes_sphere/constants/app_colors.dart';
import 'package:notes_sphere/constants/text_style.dart';
import 'package:notes_sphere/utils/router.dart';

class NoteCategoryCadr extends StatelessWidget {
  final String noteId;
  final String noteTitle;
  final String notes;
  final DateTime? date;
  final VoidCallback? onEdit;
  final Future<void> Function() removeNote;

  const NoteCategoryCadr({
    super.key,
    required this.noteId,
    required this.noteTitle,
    required this.notes,
    this.date,
    this.onEdit,
    required this.removeNote,
    Future<void> Function()? editNote,
  });

  Future<void> _confirmDelete(BuildContext context) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.kdeepBlue,
        title: const Text('Delete Note'),
        content: Text(
          'Are you sure you want to delete "$noteTitle"?',
          style: appTextStyle.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.kskyBlue),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await removeNote();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onEdit != null) {
          onEdit!();
        } else {
          AppRouter.router.push(
            '/create-note',
            extra: {
              'isNewCategory': false,
              'isEditing': true,
              'id': noteId,
            },
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.kdeepBlue,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.kskyBlue.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Title and Delete icon
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      noteTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: appTextStyle.headingMedium.copyWith(
                        fontSize: 16,
                        height: 1.2,
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => _confirmDelete(context),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Content snippet
              Expanded(
                child: Text(
                  notes,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: appTextStyle.bodyMedium.copyWith(
                    color: AppColors.kpeachCream.withValues(alpha: 0.75),
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ),

              const SizedBox(height: 8),
              // Bottom row: Edit hint
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.edit_outlined,
                    size: 14,
                    color: AppColors.kskyBlue.withValues(alpha: 0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Tap to edit',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.kskyBlue.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

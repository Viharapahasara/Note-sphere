import 'package:flutter/material.dart';
import 'package:notes_sphere/constants/app_colors.dart';
import 'package:notes_sphere/constants/app_constent.dart';
import 'package:notes_sphere/constants/text_style.dart';
import 'package:notes_sphere/services/notes_service.dart';
import 'package:notes_sphere/utils/router.dart';

class CategoryInputBottomsheet extends StatefulWidget {
  final VoidCallback? onNewNote;
  final VoidCallback? inNewCategory;

  const CategoryInputBottomsheet({
    super.key,
    this.onNewNote,
    this.inNewCategory,
  });

  @override
  State<CategoryInputBottomsheet> createState() =>
      _CategoryInputBottomsheetState();
}

class _CategoryInputBottomsheetState extends State<CategoryInputBottomsheet> {
  bool canCreateNewNote = false;
  List<String> categories = [];
  bool isLoading = true;

  Future<void> getAllCategories() async {
    final cats = await NotesService().getAllCategories();
    if (!mounted) return;
    setState(() {
      categories = cats;
      canCreateNewNote = cats.isNotEmpty;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.kDefaultPadding,
        vertical: 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.kdeepBlue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'What would you like to create?',
              style: appTextStyle.headingMedium,
            ),
          ),
          const SizedBox(height: 20),

          // Option 1: Create note in existing category (if any categories exist)
          if (canCreateNewNote) ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.kdarkNavy,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.note_add_outlined,
                  color: AppColors.kskyBlue,
                ),
              ),
              title: const Text(
                'Create a New Note',
                style: appTextStyle.bodyLarge,
              ),
              subtitle: Text(
                'Add to ${categories.length} existing categories',
                style: TextStyle(
                  color: AppColors.kpeachCream.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.kpeachCream,
              ),
              onTap: () {
                Navigator.of(context).pop();
                AppRouter.router.pushNamed(
                  'createNote',
                  extra: {
                    'isNewCategory': false,
                    'isEditing': false,
                    'id': '',
                  },
                );
              },
            ),
            const Divider(color: AppColors.kdarkNavy, height: 24),
          ],

          // Option 2: Create a new note category
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.kdarkNavy,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.create_new_folder_outlined,
                color: AppColors.kamberOrange,
              ),
            ),
            title: const Text(
              'Create New Note Category',
              style: appTextStyle.bodyLarge,
            ),
            subtitle: Text(
              'Start a brand new category folder',
              style: TextStyle(
                color: AppColors.kpeachCream.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: AppColors.kpeachCream,
            ),
            onTap: () {
              Navigator.of(context).pop();
              AppRouter.router.pushNamed(
                'createNote',
                extra: {
                  'isNewCategory': true,
                  'isEditing': false,
                  'id': '',
                },
              );
            },
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

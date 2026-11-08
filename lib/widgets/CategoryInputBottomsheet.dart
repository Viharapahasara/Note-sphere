import 'package:flutter/material.dart';
import 'package:notes_sphere/constants/app_colors.dart';
import 'package:notes_sphere/constants/app_constent.dart';
import 'package:notes_sphere/constants/text_style.dart';
import 'package:notes_sphere/services/notes_service.dart';
import 'package:notes_sphere/utils/router.dart';

class CategoryInputBottomsheet extends StatefulWidget {
  final Function() onNewNote;
  final Function() inNewCategory;

  const CategoryInputBottomsheet({
    super.key,
    required this.onNewNote,
    required this.inNewCategory,
  });

  

  @override
  State<CategoryInputBottomsheet> createState() =>
      _CategoryInputBottomsheetState();
}

class _CategoryInputBottomsheetState extends State<CategoryInputBottomsheet> {
 bool canCreateNewNote = false;

// Get all unique category names from the notes saved in Hive
Future<void> getAllCategories() async {
  print('getAllCategories called');

  final notes = await NotesService().loadNotes();
  print('notes count: ${notes.length}');

  final categories = <String>[];
  for (final note in notes) {
    if (!categories.contains(note.category)) {
      categories.add(note.category);
    }
  }
  print('categories: $categories');

  if (!mounted) return;

  setState(() {
    canCreateNewNote = categories.isNotEmpty;
  });
  print('canCreateNewNote: $canCreateNewNote');
}

 @override
 void initState() {
   getAllCategories();
   super.initState();
   
 }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: const BoxDecoration(
          color: AppColors.kdeepBlue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.kDefaultPadding),
        child: Column(
          children: [
            
           
            if (canCreateNewNote)
            Column(
              children: [
                 SizedBox(
              height: 20,
            ),
                GestureDetector(
                  onTap: () {
                   
                    
                      AppRouter.router.pushNamed(
                        'createNote',
                        extra: {
                          'isNewCategory': false,
                          'isEditing': false,
                          'id': '',
                        },
                      );
                    
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Create a New Note",
                        style:appTextStyle.bodyLarge,
                      ),
                      Icon(
                        Icons.arrow_right_outlined,
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              color: AppColors.kdarkNavy,
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
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
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Create New Note Category",
                    style: appTextStyle.bodyLarge,
                  ),
                  Icon(
                    Icons.arrow_right_outlined,
                  )
                ],
              ),
            ),

         
            
          ],
        ),
      ),
    );
  }
}

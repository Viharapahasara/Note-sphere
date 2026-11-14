import 'package:flutter/material.dart';
import 'package:notes_sphere/constants/app_colors.dart';
import 'package:notes_sphere/constants/app_constent.dart';
import 'package:notes_sphere/constants/text_style.dart';
import 'package:notes_sphere/models/notes_model.dart';
import 'package:notes_sphere/services/notes_service.dart';
import 'package:notes_sphere/utils/router.dart';
import 'package:notes_sphere/widgets/note_category_cadr.dart';

class Notesbycategory extends StatefulWidget {
  final String category;
  const Notesbycategory({super.key, required this.category});

  @override
  State<Notesbycategory> createState() => _NotesbycategoryState();
}

class _NotesbycategoryState extends State<Notesbycategory> {
  final NotesService noteService = NotesService();
  List<Notes> noteList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNotesByCategory();
  }

  // Load all notes by category
  Future<void> loadNotesByCategory() async {
    final list = await noteService.getNotesByCatrgoryName(widget.category);
    if (!mounted) return;
    setState(() {
      noteList = list;
      isLoading = false;
    });
  }

  Future<void> _openAddNote() async {
    await AppRouter.router.push(
      '/create-note',
      extra: {
        'isNewCategory': false,
        'isEditing': false,
        'id': '',
      },
    );
    await loadNotesByCategory();
  }

  Future<void> _openEditNote(String noteId) async {
    await AppRouter.router.push(
      '/create-note',
      extra: {
        'isNewCategory': false,
        'isEditing': true,
        'id': noteId,
      },
    );
    await loadNotesByCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.category,
              style: appTextStyle.headingMedium,
            ),
            Text(
              '${noteList.length} ${noteList.length == 1 ? 'note' : 'notes'}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.kpeachCream.withValues(alpha: 0.6),
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.kamberOrange,
        onPressed: _openAddNote,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.kDefaultPadding,
              ),
              child: noteList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.note_alt_outlined,
                            size: 64,
                            color: AppColors.kskyBlue.withValues(alpha: 0.4),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No notes in this category',
                            style: appTextStyle.headingMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap + below to add a note to "${widget.category}"',
                            style: TextStyle(
                              color:
                                  AppColors.kpeachCream.withValues(alpha: 0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.78,
                            ),
                            itemCount: noteList.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = noteList[index];
                              return NoteCategoryCadr(
                                noteId: item.id,
                                noteTitle: item.title,
                                notes: item.content,
                                date: item.date,
                                onEdit: () => _openEditNote(item.id),
                                removeNote: () async {
                                  await noteService.deleteNote(item.id);
                                  await loadNotesByCategory();
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Note deleted successfully!',
                                        ),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
            ),
    );
  }
}

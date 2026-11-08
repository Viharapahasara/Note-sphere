// ignore: file_names
import 'package:flutter/material.dart';
import 'package:notes_sphere/constants/app_constent.dart';
import 'package:notes_sphere/constants/text_style.dart';
import 'package:notes_sphere/models/notes_model.dart';
import 'package:notes_sphere/services/notes_service.dart';
import 'package:notes_sphere/utils/router.dart';
import 'package:notes_sphere/widgets/CategoryInputBottomsheet.dart';
import 'package:notes_sphere/widgets/notePage_card.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final NotesService notesService = NotesService();
  List<Notes> allNotes = [];
  Map<String, List<Notes>> noteWithCategory = {};

  @override
  void initState() {
    super.initState();
    _checkAndCreatData();
  }

  void _checkAndCreatData() async {
    final bool isNewUser = await notesService.isNewUser();
    print(isNewUser);

    //if the user is new create the inital notes
    if (isNewUser) {
      await notesService.creatInitalNotes();
    }
    //load the notes
    _loadNotes();
  }

  //load the notes
  Future<void> _loadNotes() async {
    final List<Notes> loadedNotes = await notesService.loadNotes();
    final Map<String, List<Notes>> noteByCategory =
        notesService.catagarizeNotes(loadedNotes);
    setState(() {
      allNotes = loadedNotes;
      noteWithCategory = noteByCategory;
      print(noteWithCategory);
      print(allNotes.length);
    });
  }

  //open bottom sheet
  void openBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CategoryInputBottomsheet(
          onNewNote: () {},
          inNewCategory: () {},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openBottomSheet();
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.kDefaultPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notes',
                style: appTextStyle.headingLarge,
              ),
              const SizedBox(height: 20),
              if (noteWithCategory.isEmpty)
                const Center(
                  child: Text('No notes yet. Tap + to add one!'),
                )
              else
                SizedBox(
                 // height: MediaQuery.of(context).size.height * 0.9,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppConstants.kDefaultPadding,
                      crossAxisSpacing: AppConstants.kDefaultPadding,
                    ),
                    itemCount: noteWithCategory.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String categoryName =
                          noteWithCategory.keys.elementAt(index);
                      final List<Notes> categoryNotes =
                          noteWithCategory[categoryName] ?? [];
                      final int notesCount = categoryNotes.length;

                      return GestureDetector(
                        onTap: () {
                          AppRouter.router.push(
                            '/categoryNote',
                            extra: categoryName,
                          );
                        },
                        child: Card(
                          child: NotepageCard(
                            title: categoryName,
                            numOfNotes: notesCount,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

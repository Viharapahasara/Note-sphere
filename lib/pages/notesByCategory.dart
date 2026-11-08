import 'package:flutter/material.dart';
import 'package:notes_sphere/constants/app_constent.dart';
import 'package:notes_sphere/constants/text_style.dart';
import 'package:notes_sphere/models/notes_model.dart';
import 'package:notes_sphere/services/notes_service.dart';
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

  @override
  void initState() {
    super.initState();
    loadNotesByCategory();
  }

  //load all notes by category
  Future<void> loadNotesByCategory() async {
    noteList = await noteService.getNotesByCatrgoryName(widget.category);
    setState(() {
      print(noteList.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: appTextStyle.headingLarge,
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.kDefaultPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                // height: MediaQuery.of(context).size.height*0.75,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 6.5 / 10,
                  ),
                  itemCount: noteList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return NoteCategoryCadr(
                      noteTitle: noteList[index].title,
                      notes: noteList[index].content,
                      removeNote: () async {},
                      editNote: () async {},
                    );
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom * 2,
              )
            ],
          ),
        ),
      ),
    );
  }
}

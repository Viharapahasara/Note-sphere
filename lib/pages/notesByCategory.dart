import 'package:flutter/material.dart';
import 'package:notes_sphere/constants/app_constent.dart';
import 'package:notes_sphere/constants/text_style.dart';
import 'package:notes_sphere/models/notes_model.dart';
import 'package:notes_sphere/services/notes_service.dart';

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
  Future <void> loadNotesByCategory ()async{
    noteList = await noteService.getNotesByCatrgoryName(widget.category);
    setState(() {
      print(noteList.length);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.kDefaultPadding),
        child: Column(children: [
            Text(
                 widget.category ,
                  style: AppTextStyle.headingLarge,
                ),
        ],),
      ),
    );
  }
}
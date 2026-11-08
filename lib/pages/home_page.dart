import 'package:flutter/material.dart';
import 'package:notes_sphere/constants/app_constent.dart';
import 'package:notes_sphere/constants/text_style.dart';
import 'package:notes_sphere/models/notes_model.dart';
import 'package:notes_sphere/services/notes_service.dart';
import 'package:notes_sphere/utils/router.dart';
import 'package:notes_sphere/widgets/note_card.dart';
import 'package:notes_sphere/widgets/progress_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

 List<Notes> _notes = [];
  Map<String, List<Notes>> _categorizedNotes = {};

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final service = NotesService();
    final notes = await service.loadNotes();
    if (!mounted) return;
    setState(() {
      _notes = notes;
      _categorizedNotes = service.catagarizeNotes(notes);
    });
  }
 
  
 

 
  @override
  Widget build(BuildContext context) {

   _getNonesNum () async{
   final int noteNo = await NotesService().allNotes.length;
   print(noteNo);
   return noteNo;
  }

    //claculation the progress precentage

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //for safe...
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
        
            //title
            const Padding(
              padding: EdgeInsets.all(AppConstants.kDefaultPadding),
              child: Text(
                "NoteSphere",
                style: appTextStyle.headingLarge,
              ),
            ),
        
            //main card
            const ProgressBar(compleatedTask: 5, totlaTask: 10,),
        
             Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppConstants.kDefaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //note card
                  GestureDetector(
                    onTap: () {
                     //go to the notes page
                     AppRouter.router.push("/notes");
                    },
                    child: NoteCard(
                      title: 'Notes',
                      subDetails: '${_notes.length} Notes',
                      icon: Icons.bookmark_add_outlined,
                    ),
                  ),
        
                  //to-do List card
                  GestureDetector(
                    onTap: (){
                      //go to the todo Page
                      AppRouter.router.push("/todo");
                    },
                    child: const NoteCard(
                      title: 'TO-DO List',
                      subDetails: '3 Task',
                      icon: Icons.checklist_outlined,
                    ),
                  ),
                ],
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.all(AppConstants.kDefaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Today's Progress",
                  style: appTextStyle.headingMedium,),
              
                  GestureDetector(
                    onTap: (){
                          print("see all working");
                    },
                    child: const Text("See All",
                    style: appTextStyle.button,),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:notes_sphere/constants/app_constent.dart';
import 'package:notes_sphere/constants/text_style.dart';
import 'package:notes_sphere/widgets/note_card.dart';
import 'package:notes_sphere/widgets/progress_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    //claculation the progress precentage

    return Scaffold(
      body: Column(
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
              style: AppTextStyle.headingLarge,
            ),
          ),

          //main card
          const ProgressBar(compleatedTask: 10, totlaTask: 10,),

          const Padding(
            padding:
                EdgeInsets.symmetric(horizontal: AppConstants.kDefaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //note card
                NoteCard(
                  title: 'Notes',
                  subDetails: '3 Notes',
                  icon: Icons.bookmark_add_outlined,
                ),

                //to-do List card
                NoteCard(
                  title: 'TO-DO List',
                  subDetails: '3 Task',
                  icon: Icons.checklist_outlined,
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
                style: AppTextStyle.headingMedium,),
            
                GestureDetector(
                  onTap: (){
                        print("see all working");
                  },
                  child: const Text("See All",
                  style: AppTextStyle.button,),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

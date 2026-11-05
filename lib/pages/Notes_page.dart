// ignore: file_names
import 'package:flutter/material.dart';
import 'package:notes_sphere/constants/app_constent.dart';
import 'package:notes_sphere/constants/text_style.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.add),),

      body: const Padding(
        padding: EdgeInsets.all(AppConstants.kDefaultPadding),
        child: Column(
          children: [
            Text("Notes",
            style: AppTextStyle.headingLarge,)
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:notes_sphere/constants/app_constent.dart';
import 'package:notes_sphere/constants/text_style.dart';

class NoteCategoryCadr extends StatefulWidget {
  final String noteTitle;
  final String notes;

  final Future Function() removeNote;
  final Future Function() editNote;

  const NoteCategoryCadr(
      {super.key,
      required this.noteTitle,
      required this.notes,
      required this.removeNote,
      required this.editNote});

  @override
  State<NoteCategoryCadr> createState() => _NoteCategoryCadrState();
}

class _NoteCategoryCadrState extends State<NoteCategoryCadr> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: (){}, icon: const Icon(Icons.edit_outlined)),
                IconButton(onPressed: (){}, icon: const Icon(Icons.delete_outline))
              ],
        
            ),
            Text(widget.noteTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.headingMedium,),
            const SizedBox(height: 10,),
        
            Text(widget.notes,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: AppTextStyle.bodyMedium,)
          ],
        
        ),
      )
      );
    
  }
}

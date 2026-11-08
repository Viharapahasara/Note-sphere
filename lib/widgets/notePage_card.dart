import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_sphere/constants/app_constent.dart';
import 'package:notes_sphere/constants/text_style.dart';
import 'package:notes_sphere/utils/router.dart';

class NotepageCard extends StatefulWidget {
  final String title;
  final int numOfNotes;
  const NotepageCard(
      {super.key, required this.title, required this.numOfNotes});

  @override
  State<NotepageCard> createState() => _NotepageCardState();
}

class _NotepageCardState extends State<NotepageCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.all(AppConstants.kDefaultPadding),
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  widget.title,
                  style: appTextStyle.headingMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '${widget.numOfNotes} ${widget.numOfNotes == 1 ? 'Note' : 'Notes'}',
                ),
              ],
            ),
          ),
        );
      
    
  }
}

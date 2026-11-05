import 'package:flutter/material.dart';
import 'package:notes_sphere/constants/app_colors.dart';
import 'package:notes_sphere/constants/app_constent.dart';
import 'package:notes_sphere/constants/text_style.dart';

class NoteCard extends StatefulWidget {
  final String title;
  final String subDetails;
  final IconData icon;
  const NoteCard({super.key, required this.title, required this.subDetails, required this.icon});

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
                  padding: const EdgeInsets.symmetric(vertical:  AppConstants.kDefaultPadding, ),
                  child: Card(
                    
                    child: SizedBox(
                      height: 150,
                      width: MediaQuery.of(context).size.width * 0.41,
                      child: Padding(
                        padding: const EdgeInsets.all(AppConstants.kDefaultPadding),
                        child: Column(children: [
                          Icon(widget.icon, 
                          size: 50, color:
                           AppColors.kamberOrange),
                                        
                           Text(widget.title,
                           style: AppTextStyle.bodyLarge,),
            
                           Text(widget.subDetails,
                           style: AppTextStyle.bodyMedium,)
                        ],),
                      ),
                    ),
                  ),
                );
  }
}
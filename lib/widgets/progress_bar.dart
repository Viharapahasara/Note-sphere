import 'package:flutter/material.dart';
import 'package:notes_sphere/constants/app_colors.dart';
import 'package:notes_sphere/constants/app_constent.dart';
import 'package:notes_sphere/constants/text_style.dart';

class ProgressBar extends StatefulWidget {
  final int compleatedTask;
  final int totlaTask;
  const ProgressBar(
      {super.key, required this.compleatedTask, required this.totlaTask});

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    //progress calculation
    num progress = widget.totlaTask != 0
        ? (widget.compleatedTask / widget.totlaTask) * 100
        : 0;

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppConstants.kDefaultPadding),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.kDefaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Progress",
                    style: AppTextStyle.headingMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //details
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: const Text(
                      "You have Colpleted 1 out 3 tasks keep up the progress",
                      style: AppTextStyle.bodyMedium,
                    ),
                  )
                ],
              ),

              //progress circle
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.kdeepBlue,
                      AppColors.kskyBlue,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text(
                    "${progress.toInt()}%",
                    style: AppTextStyle.progress,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:notes_sphere/constants/app_colors.dart';
import 'package:notes_sphere/constants/app_constent.dart';
import 'package:notes_sphere/constants/text_style.dart';

class ProgressBar extends StatelessWidget {
  final int compleatedTask;
  final int totlaTask;

  const ProgressBar({
    super.key,
    required this.compleatedTask,
    required this.totlaTask,
  });

  @override
  Widget build(BuildContext context) {
    // Progress calculation
    final double percentage = totlaTask > 0
        ? (compleatedTask / totlaTask).clamp(0.0, 1.0)
        : 0.0;
    final int progressPercent = (percentage * 100).toInt();

    String message;
    if (totlaTask == 0) {
      message = "No tasks yet. Tap + to add a task and track your progress!";
    } else if (compleatedTask >= totlaTask) {
      message = "All $totlaTask tasks completed! Outstanding job!";
    } else {
      message =
          "You have completed $compleatedTask out of $totlaTask tasks, keep up the progress!";
    }

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppConstants.kDefaultPadding),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.kdeepBlue,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.kskyBlue.withValues(alpha: 0.2),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppConstants.kDefaultPadding),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.kskyBlue.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.trending_up,
                              size: 18,
                              color: AppColors.kskyBlue,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Today's Progress",
                            style: appTextStyle.headingMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        message,
                        style: appTextStyle.bodyMedium.copyWith(
                          color: AppColors.kpeachCream.withValues(alpha: 0.75),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Circular Progress Indicator Stack
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 72,
                      height: 72,
                      child: CircularProgressIndicator(
                        value: percentage,
                        strokeWidth: 6,
                        backgroundColor: AppColors.kdarkNavy,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.kskyBlue,
                        ),
                      ),
                    ),
                    Text(
                      "$progressPercent%",
                      style: appTextStyle.progress.copyWith(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          //  const SizedBox(height: 14),
            // Linear Progress Track
           
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_sphere/constants/app_colors.dart';
import 'package:notes_sphere/constants/app_constent.dart';
import 'package:notes_sphere/constants/text_style.dart';

class TodoCard extends StatelessWidget {
  final String title;
  final bool statee;
  final VoidCallback onClick;
  final DateTime date;
  final DateTime time;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TodoCard({
    super.key,
    required this.title,
    required this.statee,
    required this.onClick,
    required this.date,
    required this.time,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final String dateString = DateFormat('dd MMM yyyy').format(date);
    final String timeString = DateFormat('hh:mm a').format(time);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.kDefaultPadding,
        vertical: 6,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Row(
            children: [
              // Checkbox
              Transform.scale(
                scale: 1.1,
                child: Checkbox(
                  value: statee,
                  onChanged: (value) => onClick(),
                  activeColor: AppColors.kamberOrange,
                  checkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  side: BorderSide(
                    color: statee
                        ? AppColors.kamberOrange
                        : AppColors.kskyBlue.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Title and details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: appTextStyle.headingMedium.copyWith(
                        fontSize: 16,
                        decoration: statee
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: statee
                            ? AppColors.kpeachCream.withValues(alpha: 0.4)
                            : AppColors.kpeachCream,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 13,
                          color: statee
                              ? AppColors.kskyBlue.withValues(alpha: 0.4)
                              : AppColors.kskyBlue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dateString,
                          style: TextStyle(
                            decoration: statee
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: statee
                                ? AppColors.kpeachCream.withValues(alpha: 0.4)
                                : AppColors.kpeachCream.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.access_time_outlined,
                          size: 13,
                          color: statee
                              ? AppColors.kskyBlue.withValues(alpha: 0.4)
                              : AppColors.kskyBlue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          timeString,
                          style: TextStyle(
                            decoration: statee
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: statee
                                ? AppColors.kpeachCream.withValues(alpha: 0.4)
                                : AppColors.kpeachCream.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Delete button if provided
              if (onDelete != null)
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                  tooltip: 'Delete task',
                  onPressed: onDelete,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

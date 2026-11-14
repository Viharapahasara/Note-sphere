import 'package:flutter/material.dart';
import 'package:notes_sphere/constants/app_colors.dart';
import 'package:notes_sphere/constants/app_constent.dart';
import 'package:notes_sphere/constants/text_style.dart';
import 'package:notes_sphere/models/todo_model.dart';
import 'package:notes_sphere/services/todo_service.dart';
import 'package:notes_sphere/widgets/todo_card.dart';

class TodoTab extends StatelessWidget {
  final List<todo> inCompleatedToDo;
  final List<todo> compleatedToDo;
  final Function(todo item)? onToggleDone;
  final Function(todo item)? onDelete;
  final Function(todo item)? onEdit;

  const TodoTab({
    super.key,
    required this.inCompleatedToDo,
    required this.compleatedToDo,
    this.onToggleDone,
    this.onDelete,
    this.onEdit,
  });

  Future<void> _handleToggleDone(BuildContext context, todo item) async {
    if (onToggleDone != null) {
      onToggleDone!(item);
    } else {
      await TodoService().toggleDone(item);
    }
  }

  Future<void> _handleDelete(BuildContext context, todo item) async {
    if (onDelete != null) {
      onDelete!(item);
    } else {
      await TodoService().deleteTodo(item.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (inCompleatedToDo.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.kDefaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 72,
                color: AppColors.kskyBlue.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'All caught up!',
                style: appTextStyle.headingMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'No pending tasks. Tap + to add a new task.',
                style: appTextStyle.bodyMedium.copyWith(
                  color: AppColors.kpeachCream.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: inCompleatedToDo.length,
      itemBuilder: (BuildContext context, int index) {
        final todo item = inCompleatedToDo[index];
        return Dismissible(
          key: Key(item.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.symmetric(
              horizontal: AppConstants.kDefaultPadding,
              vertical: 6,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.delete_outline, color: Colors.white, size: 24),
                SizedBox(width: 8),
                Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          onDismissed: (direction) {
            _handleDelete(context, item);
          },
          child: TodoCard(
            title: item.title,
            statee: item.isDone,
            date: item.date,
            time: item.time,
            onClick: () => _handleToggleDone(context, item),
            onTap: onEdit != null ? () => onEdit!(item) : null,
            onDelete: () => _handleDelete(context, item),
          ),
        );
      },
    );
  }
}

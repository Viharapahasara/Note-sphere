import 'package:flutter/material.dart';
import 'package:notes_sphere/constants/app_constent.dart';
import 'package:notes_sphere/constants/text_style.dart';
import 'package:notes_sphere/utils/router.dart';

class NoteCategoryCadr extends StatefulWidget {
  final String noteId;
  final String noteTitle;
  final String notes;

  final Future Function() removeNote;
  final Future Function() editNote;

  const NoteCategoryCadr({
    super.key,
    required this.noteId,
    required this.noteTitle,
    required this.notes,
    required this.removeNote,
    required this.editNote,
  });

  @override
  State<NoteCategoryCadr> createState() => _NoteCategoryCadrState();
}

class _NoteCategoryCadrState extends State<NoteCategoryCadr> {
  // Ask the user to confirm, then call the removeNote callback
  Future<void> _confirmDelete() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: (){
              Navigator.of(dialogContext).pop(true);
             widget.removeNote();
             ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note deleted successfully!')),
        );
            } ,
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    // Only delete if the user pressed Delete
    if (confirm == true) {
      await widget.removeNote();
    }
  }

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
                // Edit button
                IconButton(
                  onPressed: () {
                    AppRouter.router.push(
                      '/create-note',
                      extra: {
                        'isNewCategory': false,
                        'isEditing': true,
                        'id': widget.noteId,
                      },
                    );
                  },
                  icon: const Icon(Icons.edit_outlined),
                ),
                // Delete button
                IconButton(
                  onPressed: _confirmDelete,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            Text(
              widget.noteTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: appTextStyle.headingMedium,
            ),
            const SizedBox(height: 10),
            Text(
              widget.notes,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: appTextStyle.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
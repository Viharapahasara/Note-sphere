import 'package:flutter/material.dart';
import 'package:notes_sphere/constants/app_colors.dart';
import 'package:notes_sphere/constants/app_constent.dart';
import 'package:notes_sphere/constants/text_style.dart';
import 'package:notes_sphere/models/notes_model.dart';
import 'package:notes_sphere/services/notes_service.dart';
import 'package:notes_sphere/utils/router.dart';

class CreateNote extends StatefulWidget {
  // true  -> user types a brand new category name
  // false -> user picks an existing category from the dropdown
  final bool isNewCategory;
  const CreateNote({super.key, required this.isNewCategory});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  // GlobalKey to validate and manage the form state
  final _formKey = GlobalKey<FormState>();

  // Controllers to read the text input values
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  // Single service instance used for loading and saving notes (Hive)
  final NotesService _notesService = NotesService();

  // Categories shown in the dropdown (built from the notes saved in Hive)
  final List<String> _categories = [];

  // Currently selected category in the dropdown
  String _selectCategory = '';

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  // Load notes from Hive and build the unique category list
  Future<void> _loadCategories() async {
    final notes = await _notesService.loadNotes();
    final categories = <String>[];

    for (final note in notes) {
      if (!categories.contains(note.category)) {
        categories.add(note.category);
      }
    }

    // Guard: the widget may have been removed while loading
    if (!mounted) return;

    setState(() {
      _categories
        ..clear()
        ..addAll(categories);

      // Select the first category by default so it is never saved empty
      if (_categories.isNotEmpty && _selectCategory.isEmpty) {
        _selectCategory = _categories.first;
      }
    });
  }

  // Clean up the controllers when the widget is disposed
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  // --- Submit data ---
  Future<void> _submitData() async {
    // Run all field validators first
    if (_formKey.currentState!.validate()) {
      try {
        // Wait until the note is really saved in Hive before navigating away
        await _notesService.addNote(
          Notes(
            title: _titleController.text,
            category: widget.isNewCategory
                ? _categoryController.text
                : _selectCategory,
            content: _contentController.text,
            date: DateTime.now(),
          ),
        );

        // Guard: do not use context if the widget is no longer in the tree
        if (!mounted) return;

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note saved successfully!')),
        );

        // Go back to the home page
        AppRouter.router.go('/');
      } catch (e) {
        // Print the error and tell the user if saving fails
        print('Error saving note: $e');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save note: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Save button
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save_alt_outlined),
        onPressed: _submitData,
      ),
      appBar: AppBar(
        title: const Text("Create Note"),
        centerTitle: false,
        backgroundColor: AppColors.kdarkNavy,
        // Keep a small elevation when the content scrolls under the app bar
        scrolledUnderElevation: 1.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.kDefaultPadding),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 10),

              // Existing category: dropdown list
              if (!widget.isNewCategory)
                DropdownButtonFormField<String>(
                  // The key forces the dropdown to rebuild once the
                  // categories finish loading, so initialValue is applied
                  key: ValueKey(_categories.length),
                  initialValue: _selectCategory.isEmpty ? null : _selectCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: _categories
                      .map(
                        (category) => DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectCategory = value ?? '';
                    });
                  },
                ),

              // New category: text field
              if (widget.isNewCategory)
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(
                    labelText: 'New Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category';
                    }
                    return null;
                  },
                ),

              const SizedBox(height: 40),

              // Note title field
              TextFormField(
                controller: _titleController,
                style: const TextStyle(
                  color: AppColors.kpeachCream,
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                ),
                decoration: const InputDecoration(
                  hintText: 'Note Title',
                  hintStyle: TextStyle(
                    color: AppColors.kslateBlue,
                    fontSize: 40,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Note content field (grows with the text)
              TextFormField(
                maxLines: null,
                controller: _contentController,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(
                  color: AppColors.kpeachCream,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
                decoration: const InputDecoration(
                  hintText: 'Note Contents',
                  hintStyle: TextStyle(
                    color: AppColors.kslateBlue,
                    fontSize: 22,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some content';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
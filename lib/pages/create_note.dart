import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_sphere/constants/app_colors.dart';
import 'package:notes_sphere/constants/app_constent.dart';
import 'package:notes_sphere/constants/text_style.dart';
import 'package:notes_sphere/models/notes_model.dart';
import 'package:notes_sphere/services/notes_service.dart';
import 'package:uuid/uuid.dart';

class CreateNote extends StatefulWidget {
  final bool isNewCategory;
  final bool isEditing;
  final String id;

  const CreateNote({
    super.key,
    required this.isNewCategory,
    required this.isEditing,
    required this.id,
  });

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _newCategoryController = TextEditingController();

  final NotesService _notesService = NotesService();
  final List<String> _categories = [];
  String _selectCategory = '';
  late bool _isCreatingNewCategory;
  DateTime? _originalDate;

  @override
  void initState() {
    super.initState();
    _isCreatingNewCategory = widget.isNewCategory;

    if (widget.isEditing) {
      final note = _notesService.getNoteById(widget.id);
      if (note != null) {
        _titleController.text = note.title;
        _contentController.text = note.content;
        _selectCategory = note.category;
        _newCategoryController.text = note.category;
        _originalDate = note.date;
      }
    }

    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await _notesService.getAllCategories();
    if (!mounted) return;

    setState(() {
      _categories
        ..clear()
        ..addAll(categories);

      if (_selectCategory.isNotEmpty && !_categories.contains(_selectCategory)) {
        _categories.add(_selectCategory);
      }

      if (_categories.isNotEmpty && _selectCategory.isEmpty) {
        _selectCategory = _categories.first;
      }

      if (_categories.isEmpty) {
        _isCreatingNewCategory = true;
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _newCategoryController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) return;

    final String finalCategory = _isCreatingNewCategory
        ? _newCategoryController.text.trim()
        : _selectCategory.trim();

    if (finalCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or enter a category')),
      );
      return;
    }

    try {
      if (widget.isEditing) {
        final updatedNote = Notes(
          id: widget.id,
          title: _titleController.text.trim(),
          category: finalCategory,
          content: _contentController.text.trim(),
          date: DateTime.now(),
        );
        await _notesService.updateNote(updatedNote);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note updated successfully!')),
        );
      } else {
        final newNote = Notes(
          id: const Uuid().v4(),
          title: _titleController.text.trim(),
          category: finalCategory,
          content: _contentController.text.trim(),
          date: DateTime.now(),
        );
        await _notesService.addNote(newNote);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note created successfully!')),
        );
      }

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving note: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('dd MMMM yyyy, hh:mm a')
        .format(_originalDate ?? DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? "Edit Note" : "New Note",
          style: appTextStyle.headingMedium,
        ),
        centerTitle: false,
        backgroundColor: AppColors.kdarkNavy,
        actions: [
          IconButton(
            tooltip: 'Save Note',
            icon: const Icon(Icons.check, color: AppColors.kamberOrange, size: 28),
            onPressed: _submitData,
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.kamberOrange,
        icon: const Icon(Icons.save_outlined, color: Colors.white),
        label: Text(
          widget.isEditing ? "Save" : "Create",
          style: appTextStyle.button,
        ),
        onPressed: _submitData,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.kDefaultPadding,
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 12),

              // Category Selector Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.kdeepBlue,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.kskyBlue.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.folder_open_outlined,
                              size: 18,
                              color: AppColors.kskyBlue,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Category',
                              style: TextStyle(
                                color: AppColors.kskyBlue,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        if (_categories.isNotEmpty)
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
                            onPressed: () {
                              setState(() {
                                _isCreatingNewCategory = !_isCreatingNewCategory;
                              });
                            },
                            icon: Icon(
                              _isCreatingNewCategory
                                  ? Icons.list_outlined
                                  : Icons.add_circle_outline,
                              size: 16,
                              color: AppColors.kamberOrange,
                            ),
                            label: Text(
                              _isCreatingNewCategory
                                  ? 'Choose Existing'
                                  : 'New Category',
                              style: const TextStyle(
                                color: AppColors.kamberOrange,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (!_isCreatingNewCategory && _categories.isNotEmpty)
                      DropdownButtonFormField<String>(
                        value: _selectCategory.isEmpty ? null : _selectCategory,
                        dropdownColor: AppColors.kdeepBlue,
                        style: appTextStyle.bodyLarge,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.kdarkNavy,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: _categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(
                              category,
                              style: appTextStyle.bodyLarge,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectCategory = value;
                            });
                          }
                        },
                      )
                    else
                      TextFormField(
                        controller: _newCategoryController,
                        style: appTextStyle.bodyLarge,
                        decoration: InputDecoration(
                          hintText: 'e.g. Work, Ideas, Study',
                          hintStyle: TextStyle(
                            color: AppColors.kpeachCream.withValues(alpha: 0.4),
                          ),
                          filled: true,
                          fillColor: AppColors.kdarkNavy,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (_isCreatingNewCategory &&
                              (value == null || value.trim().isEmpty)) {
                            return 'Please enter a category name';
                          }
                          return null;
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Date info
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: AppColors.kpeachCream.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.isEditing
                        ? 'Edited $formattedDate'
                        : formattedDate,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.kpeachCream.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Note Title Field
              TextFormField(
                controller: _titleController,
                style: const TextStyle(
                  color: AppColors.kpeachCream,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Note Title',
                  hintStyle: TextStyle(
                    color: AppColors.kslateBlue.withValues(alpha: 0.7),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const Divider(color: AppColors.kdeepBlue, thickness: 1.5),
              const SizedBox(height: 8),

              // Note Content Field
              TextFormField(
                controller: _contentController,
                maxLines: null,
                minLines: 12,
                keyboardType: TextInputType.multiline,
                style: appTextStyle.bodyLarge.copyWith(
                  fontSize: 17,
                  height: 1.5,
                ),
                decoration: InputDecoration(
                  hintText: 'Write your thoughts here...',
                  hintStyle: TextStyle(
                    color: AppColors.kslateBlue.withValues(alpha: 0.7),
                    fontSize: 17,
                  ),
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter some content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

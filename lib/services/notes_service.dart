import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:notes_sphere/models/notes_model.dart';
import 'package:uuid/uuid.dart';

class NotesService {
  List<Notes> allNotes = [
    Notes(
      title: 'Welcome to Notes Sphere! 🚀',
      category: 'Welcome',
      content:
          'Start jotting down your brilliant ideas, quick thoughts, and daily to-dos right here. Everything stays safely saved on your device. Let\'s get creative!',
      date: DateTime.now(),
      id: const Uuid().v4(),
    ),
    Notes(
      title: 'How to Use This App 💡',
      category: 'Tips',
      content:
          'Tap the \'+\' button below to create a new note. Swipe left or right to organize, and use the search bar to find anything instantly. Simple and fast!',
      date: DateTime.now(),
      id: const Uuid().v4(),
    ),
    Notes(
      title: 'Family Catch-Up 📞',
      category: 'Reminders',
      content:
          'Call home around 7 PM today to talk with Mom and Dad. Ask how everyone is doing, update them on app project progress, confirm dates for the upcoming holiday trip, and remind sister about the gift list.',
      date: DateTime.now(),
      id: const Uuid().v4(),
    ),
  ];

  final _myBox = Hive.box('notes');

  // Check whether the user is new
  Future<bool> isNewUser() async {
    return _myBox.isEmpty;
  }

  // Method to create the initial notes if the box is empty
  Future<void> creatInitalNotes() async {
    if (_myBox.isEmpty) {
      await _myBox.put('notes', allNotes);
    }
  }

  // Method to load all notes
  Future<List<Notes>> loadNotes() async {
    final dynamic notes = _myBox.get('notes');

    if (notes != null && notes is List<dynamic>) {
      return notes.cast<Notes>().toList();
    }
    return [];
  }

  // Categorize all notes into a Map
  Map<String, List<Notes>> catagarizeNotes(List<Notes> allNotes) {
    final Map<String, List<Notes>> categorizedNotes = {};

    for (final note in allNotes) {
      if (categorizedNotes.containsKey(note.category)) {
        categorizedNotes[note.category]!.add(note);
      } else {
        categorizedNotes[note.category] = [note];
      }
    }
    return categorizedNotes;
  }

  // Get notes according to the category
  Future<List<Notes>> getNotesByCatrgoryName(String category) async {
    final List<Notes> all = await loadNotes();
    return all
        .where((n) =>
            n.category.trim().toLowerCase() == category.trim().toLowerCase())
        .toList();
  }

  // Get all unique categories
  Future<List<String>> getAllCategories() async {
    final List<Notes> all = await loadNotes();
    final List<String> categories = [];
    for (final note in all) {
      if (!categories.contains(note.category)) {
        categories.add(note.category);
      }
    }
    return categories;
  }

  // Search notes by title, content, or category
  Future<List<Notes>> searchNotes(String query) async {
    final List<Notes> all = await loadNotes();
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return all;
    return all.where((n) {
      return n.title.toLowerCase().contains(q) ||
          n.content.toLowerCase().contains(q) ||
          n.category.toLowerCase().contains(q);
    }).toList();
  }

  // Method to update / edit a note safely
  Future<void> updateNote(Notes note) async {
    try {
      final List<Notes> notes = await loadNotes();
      final int index = notes.indexWhere((element) => element.id == note.id);
      if (index != -1) {
        notes[index] = note;
        await _myBox.put('notes', notes);
      }
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  // Delete a note by its id
  Future<void> deleteNote(String noteId) async {
    try {
      final notes = await loadNotes();
      notes.removeWhere((note) => note.id == noteId);
      await _myBox.put('notes', notes);
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  // Method to add a new note
  Future<void> addNote(Notes note) async {
    try {
      final List<Notes> notes = await loadNotes();
      notes.add(note);
      await _myBox.put('notes', notes);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Find a single note by its id (returns null if not found)
  Notes? getNoteById(String id) {
    final dynamic stored = _myBox.get('notes');

    if (stored is List) {
      for (final item in stored) {
        if (item is Notes && item.id == id) {
          return item;
        }
      }
    }
    return null;
  }
}

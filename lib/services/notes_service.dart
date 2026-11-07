import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_sphere/models/notes_model.dart';

class NotesService {
  List<Notes> allNotes = [
    Notes(
      title: 'Weekend Grocery Shopping 🛒',
      category: 'Personal',
      content:
          'Need to visit the supermarket this Saturday morning. Items to buy: Whole milk, fresh eggs, brown bread, coffee powder, snacks for movie night, hand soap, and kitchen towels. Dont forget to use the loyalty app at checkout!',
      date: DateTime.now(),
    ),
    Notes(
      title: 'Weekend Movie Plan 🎬',
      category: 'Entertainment',
      content:
          'Planning a relaxing binge-watch session for Saturday night. Options to consider: Interstellar for sci-fi, The Social Network for tech drama, or Knives Out for a fun mystery. Get popcorn ready and keep headphones charged!',
      date: DateTime.now(),
    ),
    Notes(
      title: 'Family Catch-Up 📞',
      category: 'Reminders',
      content:
          'Call home around 7 PM today to talk with Mom and Dad. Ask how everyone is doing, update them on app project progress, confirm dates for the upcoming holiday trip, and remind sister about the gift list.',
      date: DateTime.now(),
    ),
  ];

  final _myBox = Hive.box('notes');

  //check wether the user is new user
  Future<bool> isNewUser() async {
    return _myBox.isEmpty;
  }

  // Method to create the initial notes if the box is empty
  Future<void> creatInitalNotes() async {
    if (_myBox.isEmpty) {
      await _myBox.put('notes', allNotes);
    }
  }

  //Method to load the notes
  Future<List<Notes>> loadNotes() async {
    final dynamic notes = _myBox.get('notes');

    if (notes != null && notes is List<dynamic>) {
      return notes.cast<Notes>().toList();
    }
    return [];
  }

  //catagorize all notes using the loop
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

  //method to get notes accoding to the category
  Future<List<Notes>> getNotesByCatrgoryName (String category) async{

    final dynamic storedNotes = _myBox.get('notes');
    final List<Notes> notes = [];

    if (storedNotes is List) {
      for (final dynamic item in storedNotes) {
        if (item is Notes && item.category == category) {
          notes.add(item);
        }
      }
    }
    return notes;
  }

  //method to update / edit a note
  Future <void> updateNote (Notes note)async {
    try{

      final dynamic allNotes = await _myBox.get('notes');
      final int index = allNotes.indexWhere((element) => element.id == note.id);

      allNotes[index] = note;

      await _myBox.put('notes', allNotes);
    }catch(err){
      print(err.toString());
    }

    //method to  delete a note
  Future <void> deleteNote (String noteId)async {
    try{

      final dynamic allNotes = await _myBox.get('notes');
      final int index = allNotes.indexWhere((element) => element.id == noteId);

      allNotes.removeAt(index);

      await _myBox.put('notes', allNotes);
    }catch(err){
      print(err.toString());
    }
  }
  }


}

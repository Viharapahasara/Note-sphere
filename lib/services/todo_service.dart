import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:notes_sphere/models/todo_model.dart';

class TodoService {
  final Box _myBox = Hive.box('todos');

  // Get Started todos
  List<todo> alltodo = [
    todo(
      title: 'Welcome! Tap the checkbox to mark a task as done',
      date: DateTime.now(),
      time: DateTime.now(),
      isDone: false,
    ),
    todo(
      title: 'Swipe a task to delete it',
      date: DateTime.now(),
      time: DateTime.now(),
      isDone: false,
    ),
    todo(
      title: 'Add your first task with the + button',
      date: DateTime.now(),
      time: DateTime.now(),
      isDone: false,
    ),
  ];

  // Check whether the user is new
  Future<bool> isNewUser() async {
    return _myBox.isEmpty;
  }

  // Create Data Box and add default data
  Future<void> createTodoBox() async {
    if (_myBox.isEmpty) {
      await _myBox.put('todos', alltodo);
    }
  }

  // Method to get data
  Future<List<todo>> getDAta() async {
    final dynamic todos = _myBox.get('todos');
    if (todos != null && todos is List<dynamic>) {
      return todos.cast<todo>().toList();
    }
    return [];
  }

  // Method to add a new todo
  Future<void> addTodo(todo newTodo) async {
    try {
      final List<todo> todos = await getDAta();
      todos.add(newTodo);
      await _myBox.put('todos', todos);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Method to update / edit a todo
  Future<void> updateTodo(todo updatedTodo) async {
    try {
      final List<todo> todos = await getDAta();
      final int index = todos.indexWhere((t) => t.id == updatedTodo.id);
      if (index != -1) {
        todos[index] = updatedTodo;
        await _myBox.put('todos', todos);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Method to delete a todo
  Future<void> deleteTodo(String todoId) async {
    try {
      final List<todo> todos = await getDAta();
      todos.removeWhere((t) => t.id == todoId);
      await _myBox.put('todos', todos);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Toggle done status
  Future<void> toggleDone(todo todoItem) async {
    final updated = todoItem.copyWith(isDone: !todoItem.isDone);
    await updateTodo(updated);
  }

  // Mark as done / save updated todo
  Future<void> markAsDone(todo todoItem) async {
    await updateTodo(todoItem);
  }

  // Clear all completed todos
  Future<void> clearCompleted() async {
    try {
      final List<todo> todos = await getDAta();
      todos.removeWhere((t) => t.isDone);
      await _myBox.put('todos', todos);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

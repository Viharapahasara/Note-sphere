import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_sphere/pages/Notes_page.dart';
import 'package:notes_sphere/pages/create_note.dart';
import 'package:notes_sphere/pages/home_page.dart';
import 'package:notes_sphere/pages/notesByCategory.dart';
import 'package:notes_sphere/pages/todo_page.dart';

class AppRouter {
  static final router = GoRouter(
    navigatorKey: GlobalKey<NavigatorState>(),
    debugLogDiagnostics: true,
    routes: [
      //home PAge
      GoRoute(
        name: "home",
        path: "/",
        builder: (context, state) {
          return const HomePage();
        },
      ),

      //Notes page
      GoRoute(
        name: "notes",
        path: "/notes",
        builder: (context, state) {
          return const NotesPage();
        },
      ),

      //toodo page
      GoRoute(
        name: "todo",
        path: "/todo",
        builder: (context, state) {
          return const TodoPage();
        },
      ),

      //note by category
      GoRoute(
        name: 'noteBycatrgory',
        path: "/categoryNote",
        builder: (context, state) {
          final String categoryy = state.extra as String;
          return Notesbycategory(
            category: categoryy,
          );
        },
      ),

      //create note
      GoRoute(
        name: 'createNote',
        path: '/create-note',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>? ?? {};

          final bool isNewCategory = data['isNewCategory'] ?? false;
          final bool isEditing = data['isEditing'] ?? false;
          final String id = data['id'] ?? '';
          return CreateNote(isNewCategory: isNewCategory, isEditing: isEditing, id: id);
        },
      )
    ],
  );

  static void refreshTodoPage(BuildContext context) {}
}
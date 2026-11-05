import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_sphere/pages/Notes_page.dart';
import 'package:notes_sphere/pages/home_page.dart';
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
        },),

      //toodo page
      GoRoute(
        name: "todo",
        path: "/todo",
        builder: (context, state) {
          return const TodoPage();
        },)
    ],
  );
}

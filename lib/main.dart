
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_sphere/constants/app_theme.dart';
import 'package:notes_sphere/models/notes_model.dart';
import 'package:notes_sphere/models/todo_model.dart';
import 'package:notes_sphere/pages/home_page.dart';
import 'package:notes_sphere/utils/router.dart';


void main () async{
  // Ensure Flutter bindings are initialized before calling SystemChrome
  WidgetsFlutterBinding.ensureInitialized();

  //initialize hive
  await Hive.initFlutter();

  //register the adapter
  Hive.registerAdapter(NotesAdapter());
  Hive.registerAdapter(todoAdapter());

  //open Hive boxes
  await Hive.openBox('notes');
  await Hive.openBox('todos');

  // --- LOCK ORIENTATION TO PORTRAIT ONLY ---
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "NoteSphere",
      debugShowCheckedModeBanner: false,
    // Apply the custom dark theme configuration
      theme: AppTheme.darkTheme,

      routerConfig: AppRouter.router,
  );
  }
}
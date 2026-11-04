
import 'package:flutter/material.dart';
import 'package:notes_sphere/constants/app_theme.dart';
import 'package:notes_sphere/pages/home_page.dart';
import 'package:notes_sphere/utils/router.dart';


void main (){
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
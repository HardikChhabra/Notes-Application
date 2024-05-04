import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/auth/auth_gate.dart';
import 'package:todo_list/firebase_options.dart';
import 'package:todo_list/responsive/responsive.dart';
import 'package:todo_list/themes/dark_mode.dart';
import 'package:todo_list/themes/light_mode.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  return runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const ResponsiveLayout(desktopBody: Scaffold(), mobileBody: AuthGate()),
        theme: lightMode,
        darkTheme: darkMode,
      )
  );
}
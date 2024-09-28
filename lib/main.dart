import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:watchdog_dashboard/config.dart';
import 'package:watchdog_dashboard/firebase_options.dart';
import 'package:watchdog_dashboard/modules/home/ui/home_page.dart';

void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WatchDog Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
          centerTitle: false,
        ),
      ),
      home: const HomePage(),
    );
  }
}

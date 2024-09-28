import 'package:flutter/material.dart';
import 'package:watchdog_dashboard/config.dart';
import 'package:watchdog_dashboard/modules/home/ui/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WatchDog Dashboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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

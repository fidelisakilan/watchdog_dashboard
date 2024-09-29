import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:watchdog_dashboard/config.dart';
import 'package:watchdog_dashboard/firebase_options.dart';
import 'package:watchdog_dashboard/modules/home/ui/home_page.dart';
import 'package:watchdog_dashboard/theme.dart';
import 'package:watchdog_dashboard/util.dart';

import 'modules/login/ui/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme =
        createTextTheme(context, "Inter Tight", "Chau Philomene One");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'WatchDog Dashboard',
      debugShowCheckedModeBanner: false,
      theme: theme.light().copyWith(
            appBarTheme: const AppBarTheme(
              color: Colors.transparent,
              centerTitle: false,
            ),
          ),
      scrollBehavior: ScrollConfiguration.of(context).copyWith(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
      ),
      home: const LoginPage(child: HomePage()),
    );
  }
}

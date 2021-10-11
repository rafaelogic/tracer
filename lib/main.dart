// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tracer/providers/log_provider.dart';
import 'package:tracer/providers/person_provider.dart';
import 'package:tracer/providers/sqlite_provider.dart';
import 'package:tracer/routes.dart';
import 'package:tracer/screens/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = SqliteProvider.instance;
  var count = await db.countTable();

  PersonProvider.instance.createPersonsTable();
  LogProvider.instance.createLogsTable();

  print("SQL Table Count: $count");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SNCES Tracer',
      home: AnimatedSplashScreen(
          duration: 3000,
          splash: 'assets/images/snces.png',
          splashIconSize: double.infinity,
          nextScreen: Home(),
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.fade,
          backgroundColor: Colors.white),
      routes: tracerRoutes,
    );
  }
}

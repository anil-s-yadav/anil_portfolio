import 'dart:ui';
import 'package:anil_portfolio/firebase_options.dart';
import 'package:anil_portfolio/homepage.dart';
import 'package:anil_portfolio/theme/theme.dart';
import 'package:anil_portfolio/theme/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Enable Firestore offline persistence:
    // On subsequent visits all data loads from IndexedDB at 0ms latency.
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }
  runApp(const MyApp());
}

class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    final TextTheme textTheme = createTextTheme(context, "Poppins", "Poppins");
    final MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Anil S. Yadav | Portfolio',
      scrollBehavior: const AppScrollBehavior(),
      theme: brightness == Brightness.light
          ? theme.lightMediumContrast()
          : theme.darkMediumContrast(),
      home: const MyHomePage(),
    );
  }
}

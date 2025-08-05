import 'package:anil_portfolio/homepage.dart';
import 'package:anil_portfolio/theme/theme.dart';
import 'package:anil_portfolio/theme/util.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    TextTheme textTheme = createTextTheme(context, "Poppins", "Poppins");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme:
          brightness == Brightness.light
              ? theme.lightMediumContrast()
              : theme.darkMediumContrast(),
      home: MyHomePage(),
    );
  }
}

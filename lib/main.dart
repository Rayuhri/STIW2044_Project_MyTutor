import 'package:flutter/material.dart';
import 'package:mytutor/view/splashpage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData.dark(),
        title: 'mytutor',
        home: const Scaffold(
          body: SplashPage(),
        ));
  }
}

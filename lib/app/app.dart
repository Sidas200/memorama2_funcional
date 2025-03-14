import 'package:flutter/material.dart';

import 'home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Memo",
      theme: ThemeData(
          fontFamily: "outfit",
          primarySwatch: Colors.lightBlue,
          useMaterial3: true),
      initialRoute: "home",
      routes: {
        "home": (BuildContext context) => const Home(),
      },
    );
  }
}

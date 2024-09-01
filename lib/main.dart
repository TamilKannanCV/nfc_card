import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';

import 'gen/fonts.gen.dart';
import 'screens/main_screen.dart';

Future<void> main() async {
  await FacebookAudienceNetwork.init();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        fontFamily: FontFamily.dMSerifDisplay,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const MainScreen(),
    );
  }
}

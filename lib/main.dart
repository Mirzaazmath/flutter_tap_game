

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tap_game/screens/game_screen.dart';
import 'package:flutter_tap_game/screens/home_screen.dart';

import 'components/flip_component.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  final pageFlipKey = GlobalKey<PageFlipBuilderState>();
  @override
  Widget build(BuildContext context) {
    final darkBlue =  Color.fromARGB(255, 18, 32, 47);
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home:PageFlipBuilder(

        key:pageFlipKey,

        frontBuilder: (BuildContext context) =>HomeScreen(

          onflip: () => pageFlipKey.currentState?.flip(),
        ),
        backBuilder: (BuildContext context) =>GameWidget(
          onflip: () {
            Navigator.pop(context,false);
            pageFlipKey.currentState?.flip();
          }
        ),
      )
      //HomeScreen(),
      //GameWidget(),
    );
  }
}









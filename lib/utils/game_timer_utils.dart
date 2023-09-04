import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// CUSTOM CLASS TO HANDLE TIMER IN OUR GAME
class GameTimer {
  Timer? _timer;
  ValueNotifier<int> remainingSeconds = ValueNotifier<int>(0);
// TIMER START METHOD
  void startGame() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? _level = prefs.getInt('level');
    int moretime=_level??0;
    _timer?.cancel();
    remainingSeconds.value = 15+(moretime-2);
    _timer = Timer.periodic( const  Duration(seconds: 1), (timer) {
      remainingSeconds.value--;
      if (remainingSeconds.value == 0) {
        _timer?.cancel();
      }
    });
  }
  // TIMER STOP METHODS
  void stopGame(){
    _timer?.cancel();
  }
}


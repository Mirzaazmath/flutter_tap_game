import 'dart:math';

import 'package:flutter/material.dart';

import '../components/dailog_component.dart';
import '../components/target_component.dart';
import '../data/data.dart';
import '../utils/game_timer_utils.dart';
import '../utils/text_utils.dart';
class GameWidget extends StatefulWidget {
  final VoidCallback ? onflip;
  GameWidget({this.onflip});
  @override
  _GameWidgetState createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  static final _rng = Random();

  late Alignment _playerAlignment;
  late List<Alignment> _targets;
  late TargetData _targetData;
  int _score = 0;
  int _traget=5;
  int _remaininglives=3;
  bool _gameInProgress = false;
  GameTimer _gameTimer = GameTimer();

  @override
  void initState() {
    super.initState();
    _playerAlignment = const  Alignment(0, 0);
    _gameTimer.remainingSeconds.addListener(() {
      if (_gameTimer.remainingSeconds.value == 0) {
        setState(() {
          _gameInProgress = false;
        });
      }
    });
    _randomize();
  }

  void _randomize() {
    _targetData = TargetData(
      type: TargetType.values[_rng.nextInt(2)],
      index: _rng.nextInt(targetColors.length),
    );
    _targets = [
      for (var i = 0; i < targetColors.length; i++)
        Alignment(
          _rng.nextDouble() * 2 - 1,
          _rng.nextDouble() * 2 - 1,
        )
    ];
  }

  void _startGame() {
    _randomize();
    setState(() {
      _score = 0;
      _remaininglives=3;
      _gameInProgress = true;
    });
    _gameTimer.startGame();
  }

  // This method contains most of the game logic
  void _handleTapDown(TapDownDetails details, int? selectedIndex) {
    if (!_gameInProgress) {
      return;
    }
    final size = MediaQuery.of(context).size;
    setState(() {
      if (selectedIndex != null) {
        _playerAlignment = _targets[selectedIndex];
        final didScore = selectedIndex == _targetData.index;
        Future.delayed( const Duration(milliseconds: 250), () {
          setState(() {
            if (didScore) {
              _score++;
            } else {
              if(_score<=0){
                _remaininglives--;

              }else{
                _score--;
                _remaininglives--;
              }


            }
            _randomize();
          });
        });
        // score point
      } else {
        _playerAlignment = Alignment(
          2 * (details.localPosition.dx / size.width) - 1,
          2 * (details.localPosition.dy / size.height) - 1,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 130,
        leading:Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            ValueListenableBuilder(
              valueListenable: _gameTimer.remainingSeconds,
              builder: (context, remainingSeconds, _) {
                return TextPrompt("Remain : ${remainingSeconds.toString()}",
                    fontSize: 18,

                    color: Colors.white);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for(int i =1;i<=3;i++)...[Icon(Icons.favorite,color:i<=_remaininglives? Colors.red:Colors.grey,)]
              ],
            )
          ],
        ),
        title:   Padding(
          padding: const  EdgeInsets.only(top: 10),
          child: Column(
            children: [
             GestureDetector(
               onTap: (){
                 showDialog(context: context,
                     builder: (BuildContext context){
                       return CustomDialogBox(
                         title: "Custom Dialog Demo",
                         descriptions: "Hii all this is a custom dialog in flutter and  you will be use in your flutter applications",
                         text: "Yes",

                       );
                     }
                 );
               },
                 child: const  TextPrompt("TAP",color: Colors.white,fontSize: 20,)),
              TextPrompt("${_targetData.text}",color: Colors.white,fontSize: 20,),

            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20,top: 10),
            child: TextPrompt(
              'Target: $_traget',
              color: Colors.white,
              fontSize: 18,
            ),
          ),

        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Handle taps anywhere
                Positioned.fill(
                  child: GestureDetector(
                    onTapDown: (details) => _handleTapDown(details, null),
                  ),
                ),


                // Targets
                for (var i = 0; i < targetColors.length; i++)
                  GestureDetector(
                    // Handle taps on targets
                    onTapDown: (details) => _handleTapDown(details, i),
                    // TO DO: Convert to AnimatedAlign & add a duration argument
                    child: AnimatedAlign(
                      duration:const  Duration(milliseconds: 300),
                      alignment: _targets[i],
                      child: Target(
                        color: targetColors[i],
                        textColor: textColors[i],
                        text: i.toString(),
                      ),
                    ),
                  ),
                // Next Command
                Align(
                  alignment: const Alignment(0, 0),
                  child: IgnorePointer(
                    ignoring: _gameInProgress,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        TextPrompt(
                          _gameInProgress ? "" : 'Game Over!',
                          color:  Colors.white,
                        ),

                        _gameInProgress? const SizedBox():   OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: const StadiumBorder(),
                            side: const BorderSide(width: 2, color: Colors.white),
                          ),
                          onPressed: _startGame,
                          child:const Padding(
                            padding:  EdgeInsets.all(8.0),
                            child: TextPrompt('Start', color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               const  TextPrompt("Level 1",color: Colors.white,fontSize: 20,),
                TextPrompt(
                  'Score: $_score',
                  color: Colors.white,
                  fontSize: 18,
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}
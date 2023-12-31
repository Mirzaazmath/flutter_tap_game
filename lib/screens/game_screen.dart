import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/dailog_component.dart';
import '../components/target_component.dart';
import '../data/data.dart';
import '../utils/game_timer_utils.dart';
import '../utils/text_utils.dart';
import 'package:audioplayers/audioplayers.dart';
class GameWidget extends StatefulWidget {
  final VoidCallback ? onflip;
  GameWidget({this.onflip});
  @override
  _GameWidgetState createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  // audio player for background music
  final bgplayer = AudioPlayer();
  final sucessplayer = AudioPlayer();
  final failplayer = AudioPlayer();
  // FOR RANDOM NUMBER
  static final _rng = Random();
  //  INITIAL  HIGH SCORE
  int _highscore=0;
  //  INITIAL LEVEL
  int _level=1;


  late Alignment _playerAlignment;
  late List<Alignment> _targets;
  late TargetData _targetData;
  // INITIAL SCORE
  int _score = 0;
  // INITIAL  TARGET
  int _traget=5;
  // REMANING LIVES
  int _remaininglives=3;
  // BOOL TO CHECK THIS IS IN PROGRESS OR NOT
  bool _gameInProgress = false;
  // GAME TIMER INITAIL FROM TIMER CLASS
  GameTimer _gameTimer = GameTimer();

  @override
  void initState() {
    super.initState();
    // METHOD TO GET THE HIGHSCORE OF THE USER
    _gethighscore();

    _playerAlignment = const  Alignment(0, 0);
    // GAME TIMER LISTENER
    _gameTimer.remainingSeconds.addListener(() async {
      // IF THE TIME REACH TO 0
      if (_gameTimer.remainingSeconds.value == 0){
        // BACKGROUND MUSIC STOPS
        await bgplayer.stop();
        // GAME IN PROGRESS STOPS
        _gameInProgress = false;
        // ALERT DAILOG TO DISPLAY RESULT
        _showResult();
        setState(() {

        });
      }
    });
    // RANDOMIZATION
    _randomize();
    // MUSIC PLAYER LISTENER
    bgplayer.onPlayerComplete.listen((_) async{
      // AFTER COMPLETE WE ARE AGAIN STARTING THE MUSIC

        await bgplayer.play(AssetSource('music/bg.mp3'));
      setState(() {

      });
    });
  }

  // METHOD TO GET HIGH SCORE FROM SharedPreferences
  // AND LEVEL
  _gethighscore()async{
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'counter' key. If it doesn't exist, returns null.
    final int? score = prefs.getInt('highscore');
    final int? level = prefs.getInt('level');

    print(score);
    setState(() {
      _traget=5;

      _highscore=score??0;
      // INCREMENT OF LEVEL
      _level=level??1;
      // INCREMENT OF TARGET
      _traget=_traget+_level;
    });


  }



// DISPOSE METHOD TO DISPOSE THE MUSIC  PLAYERS
  @override
  void dispose() {
    bgplayer.dispose();
    failplayer.dispose();
    sucessplayer.dispose();


    super.dispose();
  }
// RANDOM NUMBER GENERATOR METHOD
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
// START GAME
  void _startGame() async {
    await bgplayer.play(AssetSource('music/bg.mp3'));
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
   _remaininglives<=1? _isliveOver():null;
    final size = MediaQuery.of(context).size;
    setState(() {
      if (selectedIndex != null) {
        _playerAlignment = _targets[selectedIndex];
        final didScore = selectedIndex == _targetData.index;
        Future.delayed( const Duration(milliseconds: 250), () async {

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
  // REMAINING LIVES OVER
  _isliveOver(){
    setState(() {
      _gameInProgress = false;
      _gameTimer.remainingSeconds.value=0;
      _gameTimer.stopGame();



    });
  }
  // SHOW RESULT
  _showResult()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _score<_traget?await failplayer.play(AssetSource('music/error.mp3')):sucessplayer.play(AssetSource('music/success.mp3'));
    _highscore<_score? await prefs.setInt('highscore', _score):await prefs.setInt('highscore', _highscore);

    _score<_traget? await prefs.setInt('level', _level):await prefs.setInt('level', _level+1);


      showDialog(context: context,
          barrierDismissible: false,
          builder: (BuildContext context){
            return CustomDialogBox(
              title: _score<_traget?  "FAILED!":"SUCCESS",
              descriptions: _score<_traget? "Game Over" :" Level Up",
              text: _score<_traget?"Try Again":"Next Level",
              didwin: _score<_traget,

            );
          }
      );
    _gethighscore();
  }

  @override
  Widget build(BuildContext context) {
    // WillPopScope TO HANDLE BACK
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Do you want to Quit Game?'),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: widget.onflip!,
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('No'),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },

      child: Scaffold(
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
               const  TextPrompt("TAP",color: Colors.white,fontSize: 20,),
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
                   TextPrompt("Level $_level",color: Colors.white,fontSize: 20,),
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
      ),
    );
  }
}
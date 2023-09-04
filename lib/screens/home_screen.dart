import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:neopop/neopop.dart';
import '../utils/circular_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/text_utils.dart';
class HomeScreen extends StatefulWidget {
  final VoidCallback ? onflip;

  const HomeScreen({super.key,this.onflip});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _highscore=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _gethighscore();
  }
  _gethighscore()async{
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Try reading data from the 'counter' key. If it doesn't exist, returns null.
    final int? score = prefs.getInt('highscore');
    print(score);
    setState(() {
      _highscore=score??0;
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: (){},
          icon:const  Icon(Icons.settings),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                const ArcText(radius: 130, text: 'FLUTTER TAP GAME', textStyle: TextStyle(color:  Color(0xFF8DD04A),fontSize: 37,fontWeight: FontWeight.w800),),
                Column(
                  children: [
                    TextPrompt("$_highscore", color: Colors.white,fontSize: 40,),
                    const TextPrompt("HighScore", color: Colors.yellowAccent),
                  ],
                ),
              ],
            ),
          ),
         const  SizedBox(height: 50,),

          NeoPopTiltedButton(
            isFloating: true,
            onTapUp:widget.onflip!,
            decoration: const NeoPopTiltedButtonDecoration(
              color: Color(0xFF0D0D0D),
              plunkColor: Color(0xFF3F6915),
              shadowColor: Colors.black,
              border: Border.fromBorderSide(
                BorderSide(color: Color(0xFF8DD04A), width: 1),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 15),
              child: Text('Play Now', style: TextStyle(color: Colors.white)),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}


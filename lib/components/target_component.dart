import 'package:flutter/material.dart';
class Target extends StatelessWidget {
  const Target({
    Key? key,
    required this.color,
    required this.textColor,
    required this.text,
  }) : super(key: key);
  final Color color;
  final Color textColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return    Stack(
      alignment: Alignment.center,
      children: [

        Container(
          width: 75,
           height: 75,
          decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,

              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.5),blurRadius: 5,offset: const Offset(5,6))]

          ),
          child:  Align(
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),


        ),),


        Stack(

          children: [
            Container(
              margin: const  EdgeInsets.only(top:10,left: 15),
              height: 10,
              width: 10,
              decoration: const BoxDecoration(

                  shape: BoxShape.circle,

                  boxShadow: [
                    BoxShadow(color: Colors.white,blurRadius: 5,offset: const Offset(5,6))]

              ),


            ),

            Container(
              height: 80,
              width: 80,
              foregroundDecoration:const  BoxDecoration(
                shape: BoxShape.circle,
                //color: Colors.white
                backgroundBlendMode: BlendMode.overlay,
                gradient: LinearGradient(

                    colors: [Colors.black,Colors.white]
                ),

              ),


            ),
          ],
        ),
      ],
    );



  }
}


import 'package:flutter/material.dart';


class FlipGame extends StatefulWidget{
  const FlipGame({super.key});


  @override
  State<FlipGame> createState() => _FlipGameState();
}

class _FlipGameState extends State<FlipGame> {

  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Emoji Flip Game',style: TextStyle(color: Colors.white),),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.lightBlue,
              Colors.white,
            ],
          ),
          ),

        ),
      );

  }



}





import 'package:flutter/material.dart';
import '../widget/screen1.dart';

void main(){
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: FlipGame(),
      debugShowCheckedModeBanner: false,
    );
  }
}
import 'package:flutter/material.dart';


class FlipGame extends StatefulWidget{
  const FlipGame({super.key});


  @override
  State<FlipGame> createState() => _FlipGameState();
}

class _FlipGameState extends State<FlipGame> {

  List<String> a = ['🍎', '🍌', '🍇', '🍒', ];

  late List<String> b;
  late List<bool> itsFlipped;
  late List<bool> itsMatched;
  bool isBusy = false;

  int? currentIndex;


  //
  // void ShowFruits() {
  //   for (int i = 0; i < a.length; i++) {
  //     a.add(a[i]);
  //   }
  // }



  @override
  void initState() {
    super.initState();

    startGame();
  }

  void startGame(){
    b=[...a, ...a];
    //a.addAll(List.from(a));
    b.shuffle();

    itsFlipped = List.filled(b.length, false);
    itsMatched = List.filled(b.length, false);

    currentIndex = null;
    isBusy=false;
  }

  void onTapBox(int index){

    if (itsFlipped[index] || itsMatched[index] || isBusy) return;


    setState((){
      itsFlipped[index] = true;
    });

    if(currentIndex == null) {
      currentIndex = index;
    }else{
      if(b[currentIndex!] == b[index]) {
        setState(() {
          itsMatched[currentIndex!] = true;
          itsMatched[index] = true;

        });
        currentIndex = null;

        checkWin();
      }else{
        isBusy = true;
        int previousIndex = currentIndex!;

        Future.delayed(const Duration(milliseconds: 500),(){
          if (!mounted) return;

          setState(() {
            itsFlipped[previousIndex] = false;
            currentIndex = index;
          });
        });

      }
    }
  }

  void checkWin() {
    if (itsMatched.every((element) => element == true)) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text(" You Won!"),
          content: const Text("All fruits matched!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  startGame();
                });
              },
              child: const Text("Play Again"),
            )
          ],
        ),
      );
    }
  }


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
            begin: Alignment.bottomRight,
            end: Alignment.topRight,
            colors: [
              Colors.lightBlue,
              Colors.white,
            ],
          ),
          ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),

                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    height: 300,
                    width: 300,
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                        itemCount: b.length,
                        itemBuilder:(context, index){
                          return GestureDetector(
                            onTap: () => onTapBox(index),
                              //print('index no is: $index');


                            child: Container(
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  itsFlipped[index] || itsMatched[index] ? b[index] : ' ',
                                  style: const TextStyle(fontSize: 28),

                                ),
                              ),


                            ),

                          );
                        }),

                  ),
                ),
              ],
            ),
          ),
        ),

        ),
      );

  }



}





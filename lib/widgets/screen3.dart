import 'package:flutter/material.dart';

class FlipGame extends StatefulWidget {
  const FlipGame({super.key});

  @override
  State<FlipGame> createState() => _FlipGameState();
}

class _FlipGameState extends State<FlipGame> {

  List<String> baseFruits = [
    '🍎','🍌','🍇','🍒',
    '🍉','🥝','🍍','🥭',
    '🥭','🍓','🍑','🍋',
    '🍊','🥥','🍐','🍈'
  ];

  late List<String> fruits;
  late List<bool> itsFlipped;
  late List<bool> itsMatched;

  int? currentIndex;
  bool isBusy = false;
  int tapCount = 0;

  int level = 1;
  int gridCount = 4;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {

    int totalBoxes = gridCount * gridCount;
    int pairCount = totalBoxes ~/ 2;

    List<String> selected = baseFruits.take(pairCount).toList();

    fruits = [...selected, ...selected];
    fruits.shuffle();

    itsFlipped = List.filled(fruits.length, false);
    itsMatched = List.filled(fruits.length, false);

    currentIndex = null;
    isBusy = false;
    tapCount = 0;

    setState(() {});
  }

  void nextLevel() {
    level++;
    gridCount++;

    startGame();
  }

  void onTapBox(int index) {

    if (itsFlipped[index] || itsMatched[index] || isBusy) return;

    setState(() {
      itsFlipped[index] = true;
      tapCount++;
    });

    if (currentIndex == null) {

      currentIndex = index;

    } else {

      if (fruits[currentIndex!] == fruits[index]) {

        setState(() {
          itsMatched[currentIndex!] = true;
          itsMatched[index] = true;
        });

        currentIndex = null;
        checkWin();

      } else {

        isBusy = true;
        int previousIndex = currentIndex!;

        Future.delayed(const Duration(milliseconds: 600), () {

          setState(() {
            itsFlipped[previousIndex] = false;
            itsFlipped[index] = false;
            currentIndex = null;
            isBusy = false;
          });

        });
      }
    }
  }

  void checkWin() {
    if (itsMatched.every((element) => element == true)) {

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text("Level $level Completed 🎉"),
          content: Text("Total Taps: $tapCount\n\nGo to Level ${level + 1}?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                nextLevel();
              },
              child: const Text("Next Level"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            /// LEFT
            Text(
              "Level $level",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),

            /// CENTER
            const Text(
              "Emoji Chain Flip Game",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),

            /// RIGHT
            Text(
              "Taps: $tapCount",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
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
          child: SizedBox(
            height: 300,
            width: 300,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: fruits.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridCount,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => onTapBox(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black),
                      color: itsMatched[index]
                          ? Colors.green
                          : Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        itsFlipped[index] || itsMatched[index]
                            ? fruits[index]
                            : ' ----- ',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        onPressed: () {
          setState(() {
            level = 1;
            gridCount = 4;
            startGame();
          });
        },
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}





















































// import 'package:flutter/material.dart';
//
// class FlipGame extends StatefulWidget {
//   const FlipGame({super.key});
//
//   @override
//   State<FlipGame> createState() => _FlipGameState();
// }
//
// class _FlipGameState extends State<FlipGame> {
//
//   List<String> baseFruits = [
//     '🍎','🍌','🍇','🍒',
//     '🍉','🥝','🍍','🥭'
//   ];
//
//   late List<String> fruits;
//   late List<bool> itsFlipped;
//   late List<bool> itsMatched;
//
//   int? currentIndex;
//   bool isBusy = false;
//   int tapCount = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     startGame();
//   }
//
//   void startGame() {
//     fruits = [...baseFruits, ...baseFruits];
//     fruits.shuffle();
//
//     itsFlipped = List.filled(fruits.length, false);
//     itsMatched = List.filled(fruits.length, false);
//
//     currentIndex = null;
//     isBusy = false;
//     tapCount = 0;
//   }
//
//   void onTapBox(int index) {
//
//     if (itsFlipped[index] || itsMatched[index] || isBusy) return;
//
//     setState(() {
//       itsFlipped[index] = true;
//       tapCount++;
//     });
//
//     if (currentIndex == null) {
//       currentIndex = index;
//
//     } else {
//
//       if (fruits[currentIndex!] == fruits[index]) {
//         setState(() {
//           itsMatched[currentIndex!] = true;
//           itsMatched[index] = true;
//         });
//
//         currentIndex = null;
//         checkWin();
//
//       } else {
//         isBusy = true;
//         int previousIndex = currentIndex!;
//
//         Future.delayed(const Duration(milliseconds: 600), () {
//           //if (!mounted) return;
//
//           setState(() {
//             itsFlipped[previousIndex] = false;
//             //itsFlipped[index] = false;
//             //currentIndex = null;
//             currentIndex = index;
//             isBusy = false;
//           });
//         });
//       }
//     }
//   }
//
//   void checkWin() {
//     if (itsMatched.every((element) => element == true)) {
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           title: const Text(" You Won!"),
//           content: Text("Total Taps: $tapCount"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 setState(() {
//                   startGame();
//                 });
//               },
//               child: const Text("Play Again"),
//             )
//           ],
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.lightBlue,
//         centerTitle: true,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//
//
//             const Text(
//               "Level 1",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//               ),
//             ),
//
//
//             const Text(
//               "Emoji Chain Flip Game",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//               ),
//             ),
//
//
//             Text(
//               "Taps: $tapCount",
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//       ),
//
//
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.bottomRight,
//             end: Alignment.topRight,
//             colors: [
//               Colors.lightBlue,
//               Colors.white,
//             ],
//           ),
//         ),
//         child: Center(
//           child: SizedBox(
//             height: 300,
//             width: 300,
//             child: GridView.builder(
//               itemCount: fruits.length,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 4,
//                 crossAxisSpacing: 6,
//                 mainAxisSpacing: 6,
//               ),
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () => onTapBox(index),
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.black),
//                       color: itsMatched[index]
//                           ? Colors.green
//                           : Colors.white,
//                     ),
//                     child: Center(
//                       child: Text(
//                         itsFlipped[index] || itsMatched[index]
//                             ? fruits[index]
//                             : ' ----- ',
//                         style: const TextStyle(fontSize: 24),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//
//
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.lightBlue,
//         onPressed: () {
//           setState(() {
//             startGame();
//           });
//         },
//         child: const Icon(Icons.refresh, color: Colors.white),
//       ),
//       //floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//     );
//
//
//
//   }
// }

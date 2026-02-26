import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';


class EmojiGame extends StatefulWidget {
  const EmojiGame({super.key});

  @override
  State<EmojiGame> createState() => _EmojiGameState();
}

class _EmojiGameState extends State<EmojiGame> {
  int level = 1;
  int tapCount = 0;

  int gridCount = 4;
  double boardSize = 320;
  double emojiSize = 24;

  int matchNeed = 2;

  List<String> fruits = [];
  List<bool> itsFlipped = [];
  List<bool> itsMatched = [];
  List<int> selectedIndexes = [];

  bool busy = false;

  final List<String> baseFruits = [
    "🍎","🍌","🍇","🍒","🍉","🥝","🍍","🥭",
    "🍑","🍓","🥥","🍋","🍈","🍏","🍊","🥕",
    "🌽","🍆","🥔","🥦","🥑","🌶️","🥬","🧄",
    "🍄","🥜","🍞","🧀","🍪","🍩","🍫","🍿"
  ];

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void configureLevel() {
    if (level == 1) {
      gridCount = 4;
      boardSize = 320;
      matchNeed = 2;
    } else if (level == 2) {
      gridCount = 6;
      boardSize = 350;
      matchNeed = 2;
    } else if (level == 3) {
      gridCount = 6;
      boardSize = 350;
      matchNeed = 3;
    } else {
      gridCount = 8;
      boardSize = 380;
      matchNeed = 3;
    }

    emojiSize = boardSize / (gridCount * 3.2);
    print(emojiSize);
  }

  void startGame() {
    configureLevel();

    int totalBoxes = gridCount * gridCount;
    int uniqueCount = totalBoxes ~/ matchNeed;

    List<String> chosen = baseFruits.take(uniqueCount).toList();

    fruits = [];
    for (var f in chosen) {
      for (int i = 0; i < matchNeed; i++) {
        fruits.add(f);
      }
    }

    fruits.shuffle(Random());

    itsFlipped = List.filled(fruits.length, false);
    itsMatched = List.filled(fruits.length, false);

    //itsFlipped = List.generate(fruits.length, (_) => false);
    //itsMatched = List.generate(fruits.length, (_) => false);
    selectedIndexes.clear();
    tapCount = 0;

    setState(() {});
  }

  void onTapBox(int index) {
    if (busy) return;
    if (itsMatched[index]) return;
    if (itsFlipped[index]) return;

    setState(() {
      itsFlipped[index] = true;
      selectedIndexes.add(index);
      tapCount++;
    });

    if (selectedIndexes.length == matchNeed) {
      busy = true;

      Future.delayed(const Duration(milliseconds: 400), () {
        bool allSame = selectedIndexes.every(
                (i) => fruits[i] == fruits[selectedIndexes.first]);

        if (allSame) {
          for (var i in selectedIndexes) {
            itsMatched[i] = true;
          }
        } else {
          for (var i in selectedIndexes) {
            itsFlipped[i] = false;
          }
        }

        selectedIndexes.clear();
        busy = false;

        if (itsMatched.every((e) => e)) {
          levelUp();
        }

        setState(() {});
      });
    }
  }

  void levelUp() {
    level++;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          matchNeed == 2
              ? "Level Up! "
              : " Triple Match Mode Active!",
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    startGame();
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
            Text(
              "Level $level",
              style:
              const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const Text(
              "Emoji Flip",
              style:
              TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              "Taps: $tapCount",
              style:
              const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topRight,
            colors: [Colors.lightBlue, Colors.white],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),


            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
              decoration: BoxDecoration(
                color: matchNeed == 2
                    ? Colors.blue
                    : Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Text(
                matchNeed == 2
                    ? "Match 2 Same Fruits"
                    : " Triple Match Mode (Match 3)",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,color: Colors.white),
              ),
            ),

            const SizedBox(height: 50),

            Center(
              child: SizedBox(
                height: boardSize,
                width: boardSize,
                child: GridView.builder(
                  physics:
                  const NeverScrollableScrollPhysics(),
                  itemCount: fruits.length,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridCount,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => onTapBox(index),
                      child: AnimatedContainer(
                        duration:
                        const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(10),
                          border:
                          Border.all(color: Colors.black),
                          color: itsMatched[index]
                              ? Colors.green
                              : Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            itsFlipped[index] ||
                                itsMatched[index]
                                ? fruits[index]
                                : '',
                            style: TextStyle(
                                fontSize: emojiSize),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        onPressed: () {
          //level = 1;
          startGame();
        },
        child: const Icon(Icons.refresh,
            color: Colors.white),
      ),
    );
  }
}
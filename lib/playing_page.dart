// playing_page.dart
import 'package:flutter/material.dart';
import 'package:hangman/colors.dart';
import 'package:hangman/figure_image.dart';
import 'package:hangman/letter.dart';
import 'package:hangman/game.dart';

class PlayingPage extends StatefulWidget {
  @override
  _PlayingPageState createState() => _PlayingPageState();
}

class _PlayingPageState extends State<PlayingPage> {
  List<String> words = [
    "Flutter", "Dart", "Mobile", "Develop", "Hangman", "Play", "Great",
    "Project", "Clear", "Amazing", "Better", "Tiger", "Small", "Fight",
    "Size", "Space", "Shadow", "Soccer", "Beach", "Sound", "Best"
  ];

  late String word;

  List<String> alphabets = [
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
    "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
  ];

  @override
  void initState() {
    super.initState();

    word = (List.from(words)..shuffle()).first.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text("Hangman"),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Stack(
              children: [
                figureImage(Game.tries >= 0, "assets/hang.png"),
                figureImage(Game.tries >= 1, "assets/head.png"),
                figureImage(Game.tries >= 2, "assets/body.png"),
                figureImage(Game.tries >= 3, "assets/ra.png"),
                figureImage(Game.tries >= 4, "assets/la.png"),
                figureImage(Game.tries >= 5, "assets/rl.png"),
                figureImage(Game.tries >= 6, "assets/ll.png"),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: word
                .split('')
                .map((e) => letter(e.toUpperCase(),
                !Game.selectedChar.contains(e.toUpperCase())))
                .toList(),
          ),

          SizedBox(
            width: double.infinity,
            height: 250.0,
            child: GridView.count(
              crossAxisCount: 7,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              padding: EdgeInsets.all(8.0),
              children: alphabets.map((e) {
                return RawMaterialButton(
                  onPressed: Game.selectedChar.contains(e)
                      ? null
                      : () {
                    setState(() {
                      Game.selectedChar.add(e);
                      print(Game.selectedChar);
                      if (!word.split('').contains(e.toUpperCase())) {
                        Game.tries++;
                        checkGameStatus();
                      } else {
                        checkGameStatus();
                      }
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    e,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  fillColor: Game.selectedChar.contains(e)
                      ? Colors.black87
                      : Colors.blue,
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  void checkGameStatus() {
    if (Game.tries == 6) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Game Over"),
            content: Text("You've been hanged!"),
            actions: [
              TextButton(
                onPressed: () {
                  startNewGame();
                  Navigator.pop(context);
                },
                child: Text("New Game"),
              ),
            ],
          );
        },
      );
    } else if (word.split('').every((char) =>
        Game.selectedChar.contains(char.toUpperCase()))) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("You Win!"),
            content: Text("Congratulations, you've guessed the word!"),
            actions: [
              TextButton(
                onPressed: () {
                  startNewGame();
                  Navigator.pop(context);
                },
                child: Text("New Game"),
              ),
            ],
          );
        },
      );
    }
  }

  void startNewGame() {
    setState(() {
      word = (List.from(words)..shuffle()).first.toUpperCase();
      Game.selectedChar.clear();
      Game.tries = 0;
    });
  }
}

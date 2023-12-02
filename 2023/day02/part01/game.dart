import 'dart:io';

import 'round.dart';

class Game {
  Game(String line) {
    List<String> splitedByColon = line.split(": ");
    this._id = int.parse(splitedByColon.first.split(" ").last);
    for (String round in splitedByColon.last.split("; ")) {
      int r = 0;
      int g = 0;
      int b = 0;
      for (String play in round.split(", ")) {
        int count = int.parse(play.split(" ").first);
        String color = play.split(" ").last;
        switch (color) {
          case "red":
            r = count;
            break;
          case "green":
            g = count;
            break;
          case "blue":
            b = count;
            break;
          default:
            print("[ERROR] Switch case default, color='$color'");
            exit(1);
        }
      }
      this._roundList.add(Round(r, g, b));
    }
  }
  bool isPossible(int r, int g, int b) {
    for (var round in this._roundList) {
      if (round.r > r || round.g > g || round.b > b) {
        return false;
      }
    }
    return true;
  }
  String toString() => "Game ${this.id}: [" + this._roundList.map((round) => "Round(${round.r}, ${round.g}, ${round.b})").toList().join("; ") + "]";

  int get id => this._id;

  int _id = 0;
  List<Round> _roundList = [];
}
import 'dart:io';

import 'game.dart';

void main(List<String> args) {
  if (args.length != 1) {
    print("[ERROR] Usage: ${Platform.script.path.split("/").last} <input file>");
    exit(1);
  }
  int r = 12;
  int g = 13;
  int b = 14;
  int sum = 0;
  for (String line in File(args.first).readAsLinesSync()) {
    Game game = Game(line);
    if (game.isPossible(r, g, b)) {
      sum += game.id;
    }
  }
  print("Result: $sum");
}
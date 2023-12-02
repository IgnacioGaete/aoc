import 'dart:io';

import 'game.dart';

void main(List<String> args) {
  if (args.length != 1) {
    print("[ERROR] Usage: ${Platform.script.path.split("/").last} <input file>");
    exit(1);
  }
  int sum = 0;
  for (String line in File(args.first).readAsLinesSync()) {
    Game game = Game(line);
    sum += game.power;
  }
  print("Result: $sum");
}
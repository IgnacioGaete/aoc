import 'dart:io';

import 'hand.dart';

void main(List<String> args) {
  if (args.length != 1) {
    print("[ERROR] Usage: ${Platform.script.path.split("/").last} <input file>");
    exit(1);
  }
  List<Hand> hands = [];
  for (String line in File(args.first).readAsLinesSync()) {
    String cards = line.split(" ").first;
    int bid = int.parse(line.split(" ").last);
    hands.add(Hand(cards, bid));
  }
  hands.sort((x, y) => x.getTotalStrength() - y.getTotalStrength());
  int totalWinnings = 0;
  for (var i = 0; i < hands.length; i++) {
    int rank = i + 1;
    int bid = hands[i].bid;
    totalWinnings += bid * rank;
  }
  print("Total winnings: $totalWinnings");
}
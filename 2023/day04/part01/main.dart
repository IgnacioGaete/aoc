import 'dart:io';

import 'card.dart';

void main(List<String> args) {
  if (args.length != 1) {
    print("[ERROR] Usage: ${Platform.script.path.split("/").last} <input text>");
    exit(1);
  }
  List<Card> cards = loadCards(args.first);
  int sum = cards.map((e) => e.getPoints()).reduce((value, element) => value + element);
  print("Result = $sum");
}

List<Card> loadCards(String filePath) {
  List<Card> cards = [];
  for (String line in File(filePath).readAsLinesSync()) {
    int id = int.parse(line.split(": ").first.split(" ").last);
    List<int> wNumbers = line.split(": ").last.split(" | ").first.trim().split(" ").map((e) => e.isNotEmpty ? int.parse(e.trim()) : -1).toList();
    List<int> pNumbers = line.split(": ").last.split(" | ").last.trim().split(" ").map((e) => e.isNotEmpty ? int.parse(e.trim()) : -1).toList();
    wNumbers.removeWhere((element) => element == -1);
    pNumbers.removeWhere((element) => element == -1);
    cards.add(Card(id, wNumbers, pNumbers));
  }
  return cards;
}
import 'dart:io';
import 'dart:math';
import 'knot.dart';

class Rope {
  Rope(int lenght){
    if (lenght < 1) {
      print("[ERROR] Rope lenght must be grater than 1");
      exit(1);
    }
    this._head = Knot(0, 0, lenght);
  }

  void followInstructions(String filePath){
    for (var line in File(filePath).readAsLinesSync()) {
      String dir = line.split(" ").first;
      int count = int.parse(line.split(" ").last);
      this._head.followInstruction(dir, count);
    }
  }

  Set<Point> tailVisitedPoints(){
    Knot? cursor = this._head;
    while (cursor?.nextKnot != null) {
      cursor = cursor?.nextKnot;
    }
    return cursor != null ? cursor.visitedPoints : Set();
  }

  String toString() => "Rope:${this._head}";

  Knot _head = Knot(0, 0, 0);
}

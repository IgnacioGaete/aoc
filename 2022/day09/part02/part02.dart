import "lib/rope.dart";
import "dart:io";

void main(List<String> argv) {
  if (argv.length != 1) {
    print("[ERROR] Usage: ${Platform.script.path.split('/').last} <input file>");
    exit(1);
  }
  Rope rope = new Rope(10);
  rope.followInstructions(argv.first);
  var visitedPoints = rope.tailVisitedPoints();
  print("count: ${visitedPoints.length}");
}
import 'dart:io';

import 'desertmap.dart';

void main(List<String> args) {
  if (args.length != 1) {
    print("[ERROR] Usage: ${Platform.script.path.split("/").last} <input file>");
    exit(1);
  }
  DesertMap map = DesertMap.fromFile(args.first);
  int escapeSteps = map.getEscapeStepsCount();
  print("Steps: $escapeSteps");
}
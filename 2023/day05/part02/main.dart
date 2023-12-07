import 'dart:io';

import 'almanac.dart';

void main(List<String> args) {
  if (args.length != 1) {
    print("[ERROR] Usage: ${Platform.script.path.split("/").last} <input file>");
    exit(1);
  }
  Almanac almanac = Almanac(args.first);
  print("Result: ${almanac.getMinLocationId()}");
}
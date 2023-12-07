import 'dart:io';
import 'dart:math';

import 'almanac.dart';

void main(List<String> args) {
  if (args.length != 1) {
    print("[ERROR] Usage: ${Platform.script.path.split("/").last} <input file>");
    exit(1);
  }
  Almanac almanac = Almanac(args.first);
  Map<int, int> seedToLoc = Map.fromIterable(almanac.seeds, key: (e) => e, value: (e) => almanac.mapId("seed", "location", e));
  int minLocNumb = seedToLoc.values.reduce(min);
  print("Lowest location number: $minLocNumb");
}
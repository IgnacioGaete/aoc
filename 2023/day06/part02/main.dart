import 'dart:io';
import 'dart:math';

import 'racerecord.dart';

void main(List<String> args) {
  if (args.length != 1) {
    print("[ERROR] Usage: ${Platform.script.path.split("/").last} <input file>");
    exit(1);
  }
  RaceRecord record = loadRecord(args.first);
  int result = getOptimalTimes(record).length;
  print("Result: $result");
}

RaceRecord loadRecord(String filePath) {
  int raceTime = 0;
  int bestDistance = 0;
  for (String line in File(filePath).readAsLinesSync()) {
    String label = line.split(":").first.trim();
    int data = int.parse(line.split(":").last.replaceAll(" ", ""));
    switch (label) {
      case "Time":
        raceTime = data;
        break;
      case "Distance":
        bestDistance = data;
        break;
      default:
        print("[ERROR] Unreachable case: label='$label'");
        exit(1);
    }
  }
  return RaceRecord(raceTime, bestDistance);
}

List<int> getOptimalTimes(RaceRecord record) {
  /**
   * d = x * (T - x)
   * x**2 - T*x + d = 0
   * delta = T**2 - 4*d
   */
  List<int> times = [];
  int delta = record.raceTime * record.raceTime - 4 * record.bestDistance;
  if (delta > 0) {
    int minTime = ((record.raceTime - sqrt(delta)) / 2).ceil();
    int maxTime = ((record.raceTime + sqrt(delta)) / 2).ceil();
    for (var time = minTime; time < maxTime; time++) {
      int distance = time * (record.raceTime - time);
      if (distance > record.bestDistance) {
        times.add(time);
      }
    }
  }
  return times;
}
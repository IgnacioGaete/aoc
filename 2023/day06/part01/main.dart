import 'dart:io';
import 'dart:math';

import 'racerecord.dart';

void main(List<String> args) {
  if (args.length != 1) {
    print("[ERROR] Usage: ${Platform.script.path.split("/").last} <input file>");
    exit(1);
  }
  List<RaceRecord> records = loadRecords(args.first);
  int result = 1;
  for (RaceRecord record in records) {
    result *= getOptimalTimes(record).length;
  }
  print("Result: $result");
}

List<RaceRecord> loadRecords(String filePath) {
  List<int> times = [];
  List<int> distances = [];
  for (String line in File(filePath).readAsLinesSync()) {
    String label = line.split(":").first.trim();
    Iterable<int> data = line.split(":").last.trim().split(" ").where((e) => e.isNotEmpty).map((e) => int.parse(e.trim()));
    switch (label) {
      case "Time":
        times.addAll(data);
        break;
      case "Distance":
        distances.addAll(data);
        break;
      default:
        print("[ERROR] Unreachable case: label='$label'");
        exit(1);
    }
  }
  if (times.length != distances.length) {
    print("[ERROR] times and distances have different lenghts");
    exit(1);
  }
  return List<RaceRecord>.generate(times.length, (i) => RaceRecord(times[i], distances[i]));
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
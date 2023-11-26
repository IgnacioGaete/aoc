import 'dart:io';

import 'lib/cpu.dart';

void main(List<String> argv) {
  if (argv.length != 1) {
    print("[ERROR] Usage: dart run ${Platform.script.path.split("/").last} <input file>");
    exit(1);
  }
  Cpu cpu = Cpu(1);
  cpu.followInstructions(argv.first);
  List<int> execSignalStrength = cpu.execSignalStrength;
  int sum = 0;
  int count = 0;
  for (var i = 0; i < execSignalStrength.length; ++i) {
    if ((i + 1 - 20)%40 == 0) {
      print(execSignalStrength[i]);
      sum += execSignalStrength[i];
      ++count;
      if (count == 6) {
        break;
      }
    }
  }
  print("sum: ${sum}");
}
import 'dart:io';

import 'lib/cpu.dart';

void main(List<String> argv) {
  if (argv.length != 1) {
    print("[ERROR] Usage: dart run ${Platform.script.path.split("/").last} <input file>");
    exit(1);
  }
  Cpu cpu = Cpu(1);
  cpu.followInstructions(argv.first);
  cpu.drawImage("output.txt");//EHZFZHCZ
}
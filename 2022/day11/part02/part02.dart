import "dart:io";
import "entities/pack.dart";

void main(List<String> args) {
  if (args.length != 1) {
    print("[ERROR] Usage: ${Platform.script.path.split("/").last} <input file>");
    exit(1);
  }
  Stopwatch sw = Stopwatch();
  sw.start();
  Pack pack = Pack(args.first);
  pack.simulateRounds(10000);
  print("monkey business level: ${pack.monkeyBusinessLevel}");
  sw.stop();
  print("time: ${sw.elapsed}");
}
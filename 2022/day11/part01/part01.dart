import "dart:io";
import "entities/pack.dart";

void main(List<String> args) {
  if (args.length != 1) {
    print("[ERROR] Usage: ${Platform.script.path.split("/").last} <input file>");
    exit(1);
  }
  Pack pack = Pack(args.first);
  pack.simulateRounds(20);
  print("monkey business level: ${pack.monkeyBusinessLevel}");
}
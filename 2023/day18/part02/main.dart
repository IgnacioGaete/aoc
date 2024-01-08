import 'dart:io';

void main(List<String> args) {
  if (args.length != 1) {
    print("[ERROR] Usage: ${Platform.script.path.split("/").last} <input file>");
    exit(1);
  }
  print("Result: ${getPoolArea(File(args.first).readAsLinesSync())}");
}

int getPoolArea(List<String> lines) {
  var x0 = 0;
  var y0 = 0;
  var L = 0;
  var b = 0;
  for (String line in lines) {
    var splited = line.split("#").last.split("");
    splited.removeLast();
    var dir = splited.removeLast();// R:0, D:1, L:2, U:3
    var n = int.parse(splited.join(), radix: 16);
    var x1 = switch (dir) {
      "0" => x0 + n,
      "2" => x0 - n,
      _ => x0
    };
    var y1 = switch (dir) {
      "3" => y0 + n,
      "1" => y0 - n,
      _ => y0
    };
    var l = x0 == x1 ? x0 * (y1 - y0) : - y0 * (x1 - x0);
    b += n;
    L += l;
    x0 = x1;
    y0 = y1;
  }
  L = L.abs();
  return ((L + b) / 2).floor() + 1; // Green's theorem + Pick's theorem
}
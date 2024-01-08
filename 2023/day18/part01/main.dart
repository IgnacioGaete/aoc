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
    var splited = line.split(" ");
    var dir = splited.first;
    var n = int.parse(splited[1]);
    var x1 = switch (dir) {
      "R" => x0 + n,
      "L" => x0 - n,
      _ => x0
    };
    var y1 = switch (dir) {
      "U" => y0 + n,
      "D" => y0 - n,
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
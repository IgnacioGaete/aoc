import 'dart:io';

void main(List<String> args) {
  if (args.length != 1) {
    print("[ERROR] Usage: ${Platform.script.path.split("/").last} <input text>");
    exit(1);
  }
  List<int> partNumbers = getPartNumbers(args.first);
  int sum = partNumbers.reduce((value, element) => value + element);
  print("Result: $sum");
}

List<int> getPartNumbers(String filePath) {
  List<int> partNumbers = [];
  List<String> lines = File(filePath).readAsLinesSync();
  for (int y = 0; y < lines.length; y++) {
    String stringNumb = "";
    for (int x = 0; x < lines[y].length; x++) {
      if (isDigit(lines[y][x])) {
        stringNumb += lines[y][x];
      }
      if (x == lines[y].length - 1 || !isDigit(lines[y][x])) {
        if (stringNumb.isNotEmpty) {
          int xn = x - stringNumb.length + (x == lines[y].length - 1 && isDigit(lines[y][x])? 1 : 0);
          int yn = y;
          List<String> neighbors = getNeighbors(xn, yn, stringNumb, filePath);
          if (neighbors.any((neighbor) => isSymbol(neighbor))) {
            partNumbers.add(int.parse(stringNumb));
          }
          stringNumb = "";
        }
      }
    }
  }
  return partNumbers;
}

List<String> getNeighbors(int xn, int yn, String stringNumb, String filePath) {
  List<String> neighbors = [];
  List<String> lines = File(filePath).readAsLinesSync();
  int height = lines.length;
  int width = lines.first.length;
  for (int y = -1; y <= 1; y++) {
    for (int x = -1; x <= stringNumb.length ; x++) {
      int ys = yn + y;
      int xs = xn + x;
      if (ys >= 0 && ys < height && xs >= 0 && xs < width) {
        if (!(ys == yn && xs >= xn && xs <= xn + stringNumb.length - 1)) {
          neighbors.add(lines[ys][xs]);
        }
      }
    }
  }
  return neighbors;
}

bool isDigit(String char) => "0123456789".contains(char);

bool isSymbol(String char) => char != "." && !isDigit(char);
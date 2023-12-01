import 'dart:io';

void main(List<String> args) {
  if (args.length != 1) {
    print("[ERROR] Usage: ${Platform.script.path.split("/").last} <input text>");
    exit(1);
  }
  int sum = 0;
  for (String line in File(args.first).readAsLinesSync()) {
    sum += getCalibrationNumber(line);
  }
  print("Sum of all calibration numbers: $sum");
}

int getCalibrationNumber(String line) {
  const List<String> digitWords = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];
  List<int> digits = [];
  String word = "";
  for (var i = 0; i < line.length; i++) {
    if (isDigit(line[i])) {
      digits.add(int.parse(line[i]));
      word = "";
    } else {
      word += line[i];
    }
    for (var j = 0; j < digitWords.length; j++) {
      if (word.contains(digitWords[j])) {
        digits.add(j + 1);
        word = word[word.length - 1];
        break;
      }
    }
  }
  if (digits.length == 1) {
    digits.add(digits.first);
  }
  int result = 10 * digits.first + digits.last;
  return result;
}

bool isDigit(String c) {
  return "0123456789".contains(c);
}
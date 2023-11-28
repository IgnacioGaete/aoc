import 'dart:io';
import 'dart:math';

import 'mokey.dart';

class Pack {
  Pack(String filePath) {
    var lines = File(filePath).readAsLinesSync();
    while (lines.length > 0) {
      String line = lines.removeAt(0);
      if (line.startsWith("Monkey")) {
        List<int> initList = [];
        int Function(int)? operation;
        int Function(int)? test;
        while (lines.length > 0) {
          String property = lines.removeAt(0).trim();
          if (property.isEmpty) {
            break;
          }
          String propName = property.split(": ").first;
          String propValue = property.split(": ").last;
          switch (propName) {
            case "Starting items":
              initList = propValue.split(", ").map((x) => int.parse(x)).toList();
              break;
            case "Operation":
              operation = this.parseOperation(propValue);
              break;
            case "Test":
              String ifTrue = "";
              String ifFalse = "";
              while(lines.length > 0 && !(ifTrue.isNotEmpty && ifFalse.isNotEmpty)) {
                List<String> option = lines.removeAt(0).trim().split(": ");
                if (option.isEmpty) {
                  break;
                }
                switch (option.first) {
                  case "If true":
                    ifTrue = option.last;
                    break;
                  case "If false":
                    ifFalse = option.last;
                    break;
                  default:
                    print("[ERROR] Unreachable case: option='$option'");
                    exit(1);
                }
              }
              test = this.parseTest(propValue, ifTrue, ifFalse);
              break;
            default:
              print("[ERROR] Unreachable switch case: propName='$propName'");
              exit(1);
          }
        }
        this._monkeys.add(Monkey(initList, operation, test));
      }
    }
  }

  void simulateRounds(int count) {
    while (count-- > 0) {
      for (var i = 0; i < this._monkeys.length; i++) {
        print("Monkey $i:");
        while (this._monkeys[i].itemsCount > 0) {
          Point inspectResult = this._monkeys[i].inspectItem();
          this._monkeys[inspectResult.y.toInt()].addItem(inspectResult.x.toInt());
          print("\t$inspectResult");
        }
      }
    }
  }

  int Function(int)? parseOperation(String propValue) {
    String formula = propValue.split(" = ").last;
    if (formula.contains("+")) {
      String rhs = formula.split(" + ").last;
      if (rhs == "old") {
        return (int x) => x + x;
      } else {
        return (int x) => x + int.parse(rhs);
      }
    } else if (formula.contains("*")) {
      String rhs = formula.split(" * ").last;
      if (rhs == "old") {
        return (int x) => x * x;
      } else {
        return (int x) => x * int.parse(rhs);
      }
    } else {
      print("[WARN] parseOperation unrechable condition: formula='$formula'");
      return null;
    }
  }

  int Function(int)? parseTest(String test, String ifTrue, String ifFalse) {
    if (test.startsWith("divisible")) {
      int number = int.parse(test.split(" ").last);
      int indexTrue = int.parse(ifTrue.split(" ").last);
      int indexFalse = int.parse(ifFalse.split(" ").last);
      return (int x) => x % number == 0 ? indexTrue : indexFalse;
    } else {
      print("[WARN] parseTest unreachable test='$test'");
      return null;
    }
  }

  int get monkeyBusinessLevel {
    List<int> inspectedItems = this._monkeys.map((monkey) => monkey.inspectedItemsCount).toList();
    inspectedItems.sort();
    inspectedItems = inspectedItems.reversed.toList();
    print(inspectedItems);
    return inspectedItems[0] * inspectedItems[1];
  }
  
  List<Monkey> _monkeys = [];
}
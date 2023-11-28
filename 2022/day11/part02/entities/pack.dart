import 'dart:io';
import 'mokey.dart';

class Pack {
  Pack(String filePath) {
    var lines = File(filePath).readAsLinesSync();
    BigInt modulus = BigInt.one;
    while (lines.length > 0) {
      String line = lines.removeAt(0);
      if (line.startsWith("Monkey")) {
        List<BigInt> initList = [];
        BigInt Function(BigInt)? operation;
        int Function(BigInt)? nextIndexTest;
        while (lines.length > 0) {
          String property = lines.removeAt(0).trim();
          if (property.isEmpty) {
            break;
          }
          String propName = property.split(": ").first;
          String propValue = property.split(": ").last;
          switch (propName) {
            case "Starting items":
              initList = propValue.split(", ").map((x) => BigInt.from(int.parse(x))).toList();
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
              nextIndexTest = this.parseTest(propValue, ifTrue, ifFalse);
              modulus *= this.extractModulus(propValue);
              break;
            default:
              print("[ERROR] Unreachable switch case: propName='$propName'");
              exit(1);
          }
        }
        this._monkeys.add(Monkey(initList, operation, nextIndexTest));
      }
    }
    for (var monkey in this._monkeys) {
      monkey.modulus = modulus;
    }
  }

  void simulateRounds(int count) {
    while (count-- > 0) {
      for (var i = 0; i < this._monkeys.length; i++) {
        while (this._monkeys[i].itemsCount > 0) {
          InspectItemResult inspectResult = this._monkeys[i].inspectItem();
          this._monkeys[inspectResult.index].addItem(inspectResult.value);
        }
      }
    }
  }

  BigInt Function(BigInt)? parseOperation(String propValue) {
    String formula = propValue.split(" = ").last;
    if (formula.contains("+")) {
      String rhs = formula.split(" + ").last;
      if (rhs == "old") {
        return (BigInt x) => x + x;
      } else {
        return (BigInt x) => x + BigInt.from(int.parse(rhs));
      }
    } else if (formula.contains("*")) {
      String rhs = formula.split(" * ").last;
      if (rhs == "old") {
        return (BigInt x) => x * x;
      } else {
        return (BigInt x) => x * BigInt.from(int.parse(rhs));
      }
    } else {
      print("[WARN] parseOperation unrechable condition: formula='$formula'");
      return null;
    }
  }

  int Function(BigInt)? parseTest(String test, String ifTrue, String ifFalse) {
    if (test.startsWith("divisible")) {
      int number = int.parse(test.split(" ").last);
      int indexTrue = int.parse(ifTrue.split(" ").last);
      int indexFalse = int.parse(ifFalse.split(" ").last);
      return (BigInt x) => x.gcd(BigInt.from(number)).compareTo(BigInt.one) == 0 ? indexFalse : indexTrue;
    } else {
      print("[WARN] parseTest unreachable test='$test'");
      return null;
    }
  }

  BigInt extractModulus(String propValue) => BigInt.from(int.parse(propValue.split(" ").last));

  int get monkeyBusinessLevel {
    List<int> inspectedItems = this._monkeys.map((monkey) => monkey.inspectedItemsCount).toList();
    print(inspectedItems);
    inspectedItems.sort();
    inspectedItems = inspectedItems.reversed.toList();
    return inspectedItems[0] * inspectedItems[1];
  }
  
  List<Monkey> _monkeys = [];
}
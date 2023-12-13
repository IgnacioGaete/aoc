import 'dart:io';

class Node {
  static const String space = " ";
  static const int base = 26;
  static int valueFromName(String name) => name.codeUnitAt(2) + name.codeUnitAt(1) * base + name.codeUnitAt(0) * base * base;
  Node(String name, String leftName, String rightName) {
    if (name.length != 3) {
      print("[ERROR] Node value lenght must be 3, got: '$name'");
      exit(1);
    }
    if (leftName.length != 3) {
      print("[ERROR] Node leftValue lenght must be 3, got: '$leftName'");
      exit(1);
    }
    if (rightName.length != 3) {
      print("[ERROR] Node rightValue lenght must be 3, got: '$rightName'");
      exit(1);
    }
    _name = name;
    _value = Node.valueFromName(name);
    _leftName = leftName;
    _rightName = rightName;
  }

  String stringRepr() => _stringRepr(0, "", this);

  String _stringRepr(int level, String prevString, Node node) {
    prevString += "${space * level}$node";
    if (node.leftNode != null) {
      prevString += "\n${space * (level)}left:\n";
      prevString += _stringRepr(level + 1, "", node.leftNode!);
    }
    if (node.rightNode != null) {
      prevString += "\n${space * (level)}right:\n";
      prevString += _stringRepr(level + 1, "", node.rightNode!);
    }
    return prevString;
  }

  @override
  String toString() => "$name = ($leftName, $rightName)";

  String get name => _name;
  int get value => _value;
  String get leftName => _leftName;
  String get rightName => _rightName;
  Node? get leftNode => _leftNode;
  Node? get rightNode => _rightNode;

  set leftNode(Node? value) { _leftNode = value; }
  set rightNode(Node? value) { _rightNode = value; }

  int _value = 0;
  String _name = "";
  String _leftName = "";
  String _rightName = "";
  Node? _leftNode;
  Node? _rightNode;
}
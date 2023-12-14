import 'dart:io';

import 'node.dart';

class DesertMap {
  static DesertMap fromFile(String filePath) {
    List<String> lines = File(filePath).readAsLinesSync();
    String directions = lines.removeAt(0);
    lines.removeWhere((element) => element.isEmpty);
    DesertMap map = DesertMap(directions, lines);
    return map;
  }

  DesertMap(String directions, List<String> nodesData) {
    if (!(directions.contains("R") || directions.contains("L"))) {
      print("[ERROR] Bad directions, got '$directions'");
      exit(1);
    }
    _directions = directions;
    for (String data in nodesData) {
      String value = data.split(" = ").first;
      String leftValue = data.split(" = ").last.split(", ").first.substring(1);
      String rightValue = data.split(" = ").last.split(", ").last.substring(0, 3);
      Node node = Node(value, leftValue, rightValue);
      if (_rootNode == null) {
        _rootNode = node;
      } else {
        _addNode(_rootNode, node);
      }
    }
  }

  int getEscapeStepsCount() {
    Node? cursor = _searchNode(_rootNode, "AAA");
    int count = 0;
    while (cursor != null && cursor.name != "ZZZ") {
      String nextValue = _directions[count % _directions.length] == "R" ? cursor.rightName : cursor.leftName;
      cursor = _searchNode(_rootNode, nextValue);
      count++;
    }
    return count;
  }

  @override
  String toString() => _rootNode!.stringRepr();

  void _addNode(Node? cursor, Node node) {
    if (cursor == null) {
      return;
    }
    int comp = node.name.compareTo(cursor.name);
    if (comp == 0) {
      print("[WARN] Found same value while creating a node: value='${node.name}'");
      return;
    }
    if (comp > 0) {
      if (cursor.rightNode == null) {
        cursor.rightNode = node;
      } else {
        _addNode(cursor.rightNode, node);
      }
    }
    if (comp < 0) {
      if (cursor.leftNode == null) {
        cursor.leftNode = node;
      } else {
        _addNode(cursor.leftNode, node);
      }
    }
  }

  Node? _searchNode(Node? cursor, String name) {
    if (cursor == null) {
      print("[ERROR] Couldn't find value '$name'");
      exit(1);
    }
    int comp = name.compareTo(cursor.name);
    if (comp == 0) {
      return cursor;
    }
    Node? nextCursor = comp > 0 ? cursor.rightNode : cursor.leftNode;
    return _searchNode(nextCursor, name);
  }

  String _directions = "";
  Node? _rootNode;
}
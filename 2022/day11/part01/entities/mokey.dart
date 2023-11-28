import 'dart:math';

class Monkey {
  Monkey(List<int> initList, int Function(int)? operation, int Function(int)? nextIndex) {
    this._itemList = initList;
    this._operation = operation;
    this._nextIndex = nextIndex;
  }


  Point inspectItem() {
    int item = this._itemList.removeAt(0);
    item = this._operation!(item);
    item = (item / 3).floor();
    this._inspectedItemsCount++;
    return Point(item, this._nextIndex!(item));
  }

  void addItem(int item) {
    this._itemList.add(item);
  }

  int get inspectedItemsCount => this._inspectedItemsCount;
  int get itemsCount => this._itemList.length;

  List<int> _itemList = [];
  int Function(int)? _operation;
  int Function(int)? _nextIndex;
  int _inspectedItemsCount = 0;

}
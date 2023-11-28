class InspectItemResult {
  InspectItemResult(BigInt value, int index) {
    this.value = value;
    this.index = index;
  }
  String toString() => "InspectItemResult(index=${this.index}, value=${this.value})";
  BigInt value = BigInt.from(0);
  int index = 0;
}

class Monkey {
  Monkey(List<BigInt> initList, BigInt Function(BigInt)? operation, int Function(BigInt)? nextIndex) {
    this._itemList = initList;
    this._operation = operation;
    this._nextIndex = nextIndex;
  }


  InspectItemResult inspectItem() {
    BigInt item = this._itemList.removeAt(0);
    item = this._operation!(item);
    //item = (item / 3).floor();
    this._inspectedItemsCount++;
    return InspectItemResult(item, this._nextIndex!(item));
  }

  void addItem(BigInt item) {
    this._itemList.add(item.modPow(BigInt.one, this._modulus));
  }

  int get inspectedItemsCount => this._inspectedItemsCount;
  int get itemsCount => this._itemList.length;

  void set modulus(BigInt value) {this._modulus = value;}

  List<BigInt> _itemList = [];
  BigInt Function(BigInt)? _operation;
  int Function(BigInt)? _nextIndex;
  int _inspectedItemsCount = 0;
  BigInt _modulus = BigInt.zero;
}
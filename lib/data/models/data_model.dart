class DataModel {
  int count;
  String name;

  DataModel() {
    this.count = 0;
    this.name = "";
  }

  @override
  String toString() {
    return 'DataModel{count: $count, name: $name}';
  }

//  DataModel(this._count, this._name);
//
//  int get count => _count;
//
//  String get name => _name;
}

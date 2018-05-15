class AppState {
  int count;
  String name;
  MainScreenTab selectedTab;

  AppState({this.count, this.name, this.selectedTab}) {
    this.count = count ?? 0;
    this.name = name ?? "Nobody1";
    this.selectedTab = selectedTab ?? MainScreenTab.STORE;

//    this.count = 2;
//    this.name = "eff";
//    this.selectedTab = MainScreenTab.STORE;
  }

//  AppState() {
//    this.count = 0;
//    this.name = "";
//    this.selectedTab = MainScreenTab.AC;
//  }

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

enum MainScreenTab {
  AC,
  STORE,
  ADB,
}

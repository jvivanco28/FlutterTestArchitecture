import 'package:test_bloc/data/rest/models/post_model.dart';

class AppState {
  int count;
  String name;
  MainScreenTab selectedTab;
  List<Post> posts;

  AppState(
      [this.count = 0,
      this.name = "Derp",
      this.selectedTab = MainScreenTab.STORE]);
}

enum MainScreenTab {
  AC,
  STORE,
  ADB,
}

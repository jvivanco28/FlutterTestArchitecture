import 'package:flutter/material.dart';
import 'package:test_bloc/data/business_logic/data_bloc.dart';
import 'package:test_bloc/data/state/app_state.dart';
import 'package:test_bloc/ui/widgets/data_provider_widget.dart';
import 'package:test_bloc/ui/widgets/button_count_tab_content.dart';
import 'package:test_bloc/ui/widgets/adb_tab_content.dart';
import 'package:test_bloc/ui/widgets/ac_tab_content.dart';

class HomePage extends StatelessWidget {
  final String title;

  final GlobalKey<ScaffoldState> _scaffoldKey =
  new GlobalKey<ScaffoldState>(debugLabel: "HomePageScaffoldKey");

  HomePage(this.title);

  void showSnackBar(SnackBar snackbar) {
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget getContentWidgetForTab(MainScreenTab tab) {
    // Just using the same screen for all tabs at the moment.
    switch (tab) {
      case MainScreenTab.AC:
        return AirConditionerTabContent();
      case MainScreenTab.STORE:
        return ButtonCountTabContent();
      case MainScreenTab.ADB:
        return AdbTabContent();
      default:
        return ButtonCountTabContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    ApplicationBloc dataBloc = DataProviderWidget.of(context);
    debugPrint("Called HomePage Build");

    return new StreamBuilder<MainScreenTab>(
      // Initial data until event gets pushed.
        initialData: MainScreenTab.ADB,
        stream: dataBloc.tabSelectionRelay,
        builder: (context, snapshot) => Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(title),
          ),
          body: getContentWidgetForTab(snapshot.data),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: snapshot.data.index,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.ac_unit),
                title: Text("A/C"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.store),
                title: Text("Store"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.adb),
                title: Text("ADB"),
              ),
            ],
            onTap: (index) =>
                dataBloc.updateActiveTab(MainScreenTab.values[index]),
          ),
          // Then, we'll pass this callback to the button's `onPressed` handler.
          floatingActionButton: FloatingActionButton(
            onPressed: () => dataBloc.counterStreamController
                .add(IncrementCounterModel("New Person")),
            tooltip: 'Increment',
            child: Icon(Icons.add),

          ),
        ));
  }
}

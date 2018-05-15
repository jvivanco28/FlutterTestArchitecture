import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_bloc/data/business_logic/data_bloc.dart';
import 'package:test_bloc/data/state/app_state.dart';
import 'package:test_bloc/ui/button_count_tab_content.dart';
import 'package:test_bloc/ui/data_provider_widget.dart';
import 'package:test_bloc/ui/adb_tab_content.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  State createState() {
    return MyAppState();
  }
}

// WidgetsBindingObservable mixin lets us hook into app life cycle callbacks.
class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  StreamSubscription _snackbackObserver;
  HomePage _homePage;

  @override
  void initState() {
    debugPrint("MyAppState initState");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    debugPrint("MyAppState Disposed");
    WidgetsBinding.instance.removeObserver(this);

    // Dispose of biz logic on app dispose.
    final ApplicationBloc dataBloc = DataProvider.of(context);

    // "Call dispose if dataBloc is not null".
    dataBloc?.dispose();
    _snackbackObserver?.cancel();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Resume anything that was paused (websockets, etc.).
      debugPrint("APP STATE RESUMED");
    } else if (state == AppLifecycleState.paused) {
      // Pause or kill running observables. Would we kill our event listeners?
      debugPrint("APP STATE PAUSED");
    }
  }

  void showSnackbar(String msg) {
    debugPrint("Received snackbar! $msg");

    _homePage?.showSnackBar(SnackBar(content: new Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    const title = "Test Streams";

    _homePage = HomePage(title);

    final DataProvider widget = new DataProvider(
      child:
          MaterialApp(theme: ThemeData.dark(), title: title, home: _homePage),
    );

    _snackbackObserver = widget.dataBloc.snackbarMsgRelay.listen(showSnackbar);

    return widget;
  }
}

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
        return ButtonCountTabContent();
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
    ApplicationBloc dataBloc = DataProvider.of(context);

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

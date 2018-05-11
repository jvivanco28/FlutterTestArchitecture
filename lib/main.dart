import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_bloc/data/business_logic/data_bloc.dart';
import 'package:test_bloc/ui/data_provider_widget.dart';

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
    final DataBloc dataBloc = DataProvider.of(context);

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
      child: MaterialApp(
          theme: ThemeData.dark(), title: title, home: _homePage),
    );

    _snackbackObserver = widget.dataBloc.snackbarMsgRelay.listen(showSnackbar);

    return widget;
  }
}

class HomePage extends StatelessWidget {

  final String title;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>(debugLabel: "HomePageScaffoldKey");

  HomePage(this.title);

  void showSnackBar(SnackBar snackbar) {
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    DataBloc dataBloc = DataProvider.of(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(title),
      ),
      body: new Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          StreamBuilder<String>(
            initialData: "Nobody",
            stream: dataBloc.updatedByRelay,
            builder: (context, snapshot) => Text(
                  '${snapshot.data} has pushed the button this many times:',
                ),
          ),
          StreamBuilder<int>(
            initialData: 0,
            stream: dataBloc.counterRelay,
            builder: (context, snapshot) => Text(
                  "${snapshot.data}",
                  style: Theme.of(context).textTheme.display1,
                ),
          ),
        ]),
      ),

      // Then, we'll pass this callback to the button's `onPressed` handler.
      floatingActionButton: FloatingActionButton(
        onPressed: () => dataBloc.counterStreamController
            .add(IncrementCounter("New Person")),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

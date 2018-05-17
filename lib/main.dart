import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_bloc/data/business_logic/data_bloc.dart';
import 'package:test_bloc/ui/widgets/data_provider_widget.dart';
import 'package:test_bloc/ui/screens/home_page.dart';

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
    final ApplicationBloc dataBloc = DataProviderWidget.of(context);

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
    debugPrint("Called MyAppState Build");

    const title = "Test Streams";

    _homePage = HomePage(title);

    final DataProviderWidget widget = new DataProviderWidget(
      child:
          MaterialApp(theme: ThemeData.dark(), title: title, home: _homePage),
    );

    _snackbackObserver = widget.dataBloc.snackbarMsgRelay.listen(showSnackbar);

    return widget;
  }
}

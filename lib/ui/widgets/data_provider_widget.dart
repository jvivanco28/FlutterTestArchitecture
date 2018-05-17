import 'package:flutter/widgets.dart';
import 'package:test_bloc/data/business_logic/data_bloc.dart';

// This "widget" simply contains our biz logic.
class DataProviderWidget extends InheritedWidget {

  final ApplicationBloc dataBloc;

  DataProviderWidget({
    Key key,
    ApplicationBloc dataBloc,
    Widget child,
  })  : dataBloc = dataBloc ?? ApplicationBloc(),
        super(key: key, child: child) {

    debugPrint("CREATE DATA PROVIDER");
  } //  DataProviderWidget({

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO ALTER THIS!
    return true;
  }

  static ApplicationBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(DataProviderWidget)
            as DataProviderWidget)
        .dataBloc;
  }
}

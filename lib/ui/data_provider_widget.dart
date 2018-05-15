import 'package:flutter/widgets.dart';
import 'package:test_bloc/data/business_logic/data_bloc.dart';

// This "widget" simply contains our biz logic.
class DataProvider extends InheritedWidget {

  final ApplicationBloc dataBloc;

  DataProvider({
    Key key,
    ApplicationBloc dataBloc,
    Widget child,
  })  : dataBloc = dataBloc ?? ApplicationBloc(),
        super(key: key, child: child) {

    debugPrint("CREATE DATA PROVIDER");
  } //  DataProviderWidget({

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ApplicationBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(DataProvider)
            as DataProvider)
        .dataBloc;
  }
}

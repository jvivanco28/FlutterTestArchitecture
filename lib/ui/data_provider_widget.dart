import 'package:flutter/widgets.dart';
import 'package:test_bloc/data/business_logic/data_bloc.dart';

// This "widget" simply contains our biz logic.
class DataProvider extends InheritedWidget {

  final DataBloc dataBloc;

  DataProvider({
    Key key,
    DataBloc dataBloc,
    Widget child,
  })  : dataBloc = dataBloc ?? DataBloc(),
        super(key: key, child: child) {

    debugPrint("CREATE DATA PROVIDER");
  } //  DataProviderWidget({

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static DataBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(DataProvider)
            as DataProvider)
        .dataBloc;
  }
}

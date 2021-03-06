import 'package:flutter/material.dart';
import 'package:test_bloc/data/business_logic/data_bloc.dart';
import 'package:test_bloc/ui/widgets/data_provider_widget.dart';

class ButtonCountTabContent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    debugPrint("Called ButtonCountTabContent Build");

    ApplicationBloc dataBloc = DataProviderWidget.of(context);

    return StreamBuilder<IncrementCounterModel>(
      // This seems kinda shitty that we need to do this but oh well. The
      // state *should* be coming from the app state, not here.
      initialData: IncrementCounterModel.initial(),
      stream: dataBloc.counterIncrementRelay,
      builder: (context, snapshot) {

        debugPrint("Called ButtonCountTabContent.streambuilder Build");

        return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              '${snapshot.data
                  .updatedBy} has pushed the button this many times:',
            ),
            Text(
              "${snapshot.data.count}",
              style: Theme
                  .of(context)
                  .textTheme
                  .display1,
            ),
          ]),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

class AdbTabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint("Called AdbTabContent Build");

    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          "This is the ADB tab",
          style: Theme.of(context).textTheme.display1,
        ),
      ]),
    );
  }
}

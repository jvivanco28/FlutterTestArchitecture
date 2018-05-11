import 'package:flutter/material.dart';

class ButtonCountContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
        child:
            new Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        'You have pushed the button this many times:',
      ),
      Text(
        "0",
        style: Theme.of(context).textTheme.display1,
      ),
    ]));
  }
}

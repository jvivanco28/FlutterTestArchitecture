import 'package:flutter/material.dart';
import 'package:test_bloc/data/business_logic/data_bloc.dart';
import 'package:test_bloc/data/rest/models/post_model.dart';
import 'package:test_bloc/ui/widgets/data_provider_widget.dart';

// Terribly named widget... we're going to display some "posts" in this widget.
class AirConditionerTabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ApplicationBloc bloc = DataProvider.of(context);

    return new StreamBuilder<List<Post>>(
        stream: bloc.postListRelay,
        builder: (context, snapshot) {
          return ListView(children: _getListWidgets(snapshot.data, bloc));
        });
  }

  List<Widget> _getListWidgets(List<Post> posts, ApplicationBloc bloc) {
    return posts != null
        ? posts.map((post) => _createWidgetForPost(post, bloc)).toList()
        : [];
  }

  Widget _createWidgetForPost(Post post, ApplicationBloc bloc) =>
//      new GestureDetector(
//          onTap: () {
//            bloc.snackbarMsgRelay.add("tapped on ID ${post.id}");
//          },
//        child: Padding(
//            padding: new EdgeInsets.all(10.0),
//            child: new Text("${post.title}")),

      ListTile(
          leading: Icon(Icons.flight_land),
          title: Text("${post.id} ${post.title}"),
          subtitle: Text("${post.body}"),
          isThreeLine: true,
          onTap: () {
            bloc.snackbarMsgRelay.add("tapped on ID ${post.id}");
          });
}

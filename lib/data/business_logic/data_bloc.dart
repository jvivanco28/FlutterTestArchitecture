import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:test_bloc/data/models/data_model.dart';
import 'package:test_bloc/data/repositories/posts_repository.dart';
import 'package:test_bloc/data/rest/exceptions/api_exceptions.dart';

class DataBloc {
  final PostsRepository _postsRepository = new PostsRepository();

  // Input Streams
  final StreamController<IncrementCounter> _counterStreamController =
      StreamController<IncrementCounter>();

  // Output Streams (FYI: generic values should be view models)
  final BehaviorSubject<int> _counterRelay = BehaviorSubject<int>(seedValue: 0);
  final BehaviorSubject<String> _updatedByRelay =
      BehaviorSubject<String>(seedValue: "Nobody");

  final PublishSubject<String> _snackbarMsgRelay = PublishSubject<String>();

  DataModel _dataModel;

  DataBloc() {
    // Initial State
    this._dataModel = DataModel();

    // Listen to input streams
    _counterStreamController.stream.listen((incrementCounterEvent) =>
        _handleCounterIncrement(incrementCounterEvent));
  }

  _handleCounterIncrement(IncrementCounter incrementCounterEvent) {
    // Increment counter and post event
    _dataModel.count++;
    _counterRelay.add(_dataModel.count);

    // Update name only if it's different (post event if it is).
    if (_dataModel.name != incrementCounterEvent._updatedBy) {
      _dataModel.name = incrementCounterEvent._updatedBy;
      _updatedByRelay.add(_dataModel.name);
    }
    debugPrint("counter stream event! $_dataModel");

    // Maybe this action would invoke a RESTful request...
    _postsRepository
        .fetchPost(1)
//        .then(_derp)
        .then((post) => _snackbarMsgRelay.add(post.title))
        .catchError(_onError);
  }

//  _derp(Post post) {
//    debugPrint("Fetched post! $post");
//  }

  _onError(error) {
    debugPrint("Error fetching post. $error");

    if (error is RestApiException) {
      // Display the error from the response.
      _snackbarMsgRelay.add(error.errorModel.msg);
    } else {
      // Put generic error msg here.
      _snackbarMsgRelay.add("Sorry, something weird happened.");
    }
  }

  StreamController<IncrementCounter> get counterStreamController =>
      _counterStreamController;

  BehaviorSubject<int> get counterRelay => _counterRelay;

  BehaviorSubject<String> get updatedByRelay => _updatedByRelay;

  PublishSubject<String> get snackbarMsgRelay => _snackbarMsgRelay;

  dispose() {
    _counterStreamController.close();
    _counterRelay.close();
    _updatedByRelay.close();
  }
}

class IncrementCounter {
  final String _updatedBy;
  final int _count;

  // Always increment by 1
  IncrementCounter(this._updatedBy, [this._count = 1]);

  String get updatedBy => _updatedBy;

  int get count => _count;

  @override
  String toString() {
    return 'IncrementCounter{_updatedBy: $_updatedBy, _count: $_count}';
  }
}

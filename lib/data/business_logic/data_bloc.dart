import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:test_bloc/data/repositories/posts_repository.dart';
import 'package:test_bloc/data/rest/exceptions/api_exceptions.dart';
import 'package:test_bloc/data/state/app_state.dart';

// I think we should have a BLOC class for every screen (similar to presenter)
// and one App-level BLOC which just contains all other BLOCs.
class ApplicationBloc {
  final PostsRepository _postsRepository = new PostsRepository();

  // Input Streams
  final StreamController<IncrementCounterModel> _counterStreamController =
      StreamController<IncrementCounterModel>();

  // Output Streams (FYI: generic values should be view models)
  final BehaviorSubject<IncrementCounterModel> _counterIncrementRelay =
      BehaviorSubject<IncrementCounterModel>();

  final BehaviorSubject<MainScreenTab> _tabSelectionRelay =
      BehaviorSubject<MainScreenTab>();

  final PublishSubject<String> _snackbarMsgRelay = PublishSubject<String>();

  // This is our "state" object
  AppState _state;

  ApplicationBloc() {
    // Initial State
    this._state = AppState();

    // Listen to input streams
    _counterStreamController.stream.listen((incrementCounterEvent) =>
        _handleCounterIncrement(incrementCounterEvent));

    _pushAllStates();
  }

  _pushAllStates() {
    this
        ._counterIncrementRelay
        .add(IncrementCounterModel(_state.name, _state.count));
    this._tabSelectionRelay.add(_state.selectedTab);
  }

  _handleCounterIncrement(IncrementCounterModel incrementCounterEvent) {
    // Increment counter and post event
    _state.count++;

    // Update name only if it's different (post event if it is).
    if (_state.name != incrementCounterEvent.updatedBy) {
      _state.name = incrementCounterEvent.updatedBy;
    }
    _counterIncrementRelay
        .add(IncrementCounterModel(_state.name, _state.count));

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

  // Handle incoming app state changes the Rx way
  StreamController<IncrementCounterModel> get counterStreamController =>
      _counterStreamController;

  // Or handle them the regular ol' functional way.
  void updateActiveTab(MainScreenTab tab) {
    _state.selectedTab = tab;
    _tabSelectionRelay.add(_state.selectedTab);
  }

  BehaviorSubject<IncrementCounterModel> get counterIncrementRelay =>
      _counterIncrementRelay;

  BehaviorSubject<MainScreenTab> get tabSelectionRelay => _tabSelectionRelay;

  PublishSubject<String> get snackbarMsgRelay => _snackbarMsgRelay;

  dispose() {
    _counterStreamController.close();
    _tabSelectionRelay.close();
    _snackbarMsgRelay.close();
  }
}

class IncrementCounterModel {
  final String updatedBy;
  final int count;

  // Always increment by 1
  IncrementCounterModel(this.updatedBy, [this.count = 1]);

  factory IncrementCounterModel.initial() => IncrementCounterModel("", 0);
}

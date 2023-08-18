import 'dart:async';

import 'package:cybersec_news/hackernews_api/hackernews_api.dart';
import 'package:cybersec_news/models/all_story_data.dart';
import 'package:cybersec_news/models/base.dart';
import 'package:cybersec_news/models/home_story_data.dart';
import 'package:cybersec_news/utility/api_cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

enum StoryQueryState { querying, background_querying, done, error }

class StoryStateWrapper {
  final BaseDataClass? data;
  final StoryQueryState state;

  StoryStateWrapper({required this.state, required this.data});
}

class HnProvider extends ChangeNotifier {
  final BehaviorSubject<StoryStateWrapper> _homeState =
      BehaviorSubject<StoryStateWrapper>();

  HomeStoryData softDataHolder =
      HomeStoryData(carouselTopStories: [], newStories: []);

  AllStorySoftDataHolder allDataSoftHolder = AllStorySoftDataHolder.none();

  final BehaviorSubject<StoryStateWrapper> _allStoryState =
      BehaviorSubject<StoryStateWrapper>();

  BehaviorSubject<StoryStateWrapper> get allStoryState => _allStoryState;

  BehaviorSubject<StoryStateWrapper> get homeState => _homeState;

  HnProvider() {
    bool forceOverride = false;
    HomeStoryData initialData = HackerNewsCacheHelper.getCachedHomeData();
    softDataHolder = initialData;
    if (softDataHolder.newStories.isEmpty ||
        softDataHolder.carouselTopStories.isEmpty) {
      print("H#08: Is this true everytime??");
      forceOverride = true;
    }
    //TODO: Cases to handle using switch on home page.
    // Background querying + no data = First run of the app OR Timeout of cache
    // Background Query + data = show the app
    homeState.add(StoryStateWrapper(
        state: StoryQueryState.background_querying, data: softDataHolder));
    allStoryState.add(StoryStateWrapper(
        state: StoryQueryState.querying, data: allDataSoftHolder));
    debugPrint(HackerNewsCacheHelper.cacheTimeout().toString());
    getHomeData(override: forceOverride);
  }

  Future<void> getAllStories(HnNewsType type) async {
    allStoryState.add(StoryStateWrapper(
        state: StoryQueryState.querying, data: allDataSoftHolder));
    if ((type == HnNewsType.newStories &&
            allDataSoftHolder.newStories.isNotEmpty) ||
        (type == HnNewsType.topStories &&
            allDataSoftHolder.topStories.isNotEmpty)) {
      allStoryState.add(StoryStateWrapper(
          state: StoryQueryState.background_querying, data: allDataSoftHolder));
    }
    try {
      final response = await HackerNewsCacheHelper.getAllStories(type);
      if (type == HnNewsType.topStories) {
        allDataSoftHolder.topStories = response;
      } else {
        allDataSoftHolder.newStories = response;
      }

      allStoryState.add(StoryStateWrapper(
          state: StoryQueryState.done, data: allDataSoftHolder));
    } catch (err, stk) {
      debugPrint("Error in querying home data: $err --> $stk");
      allStoryState.add(StoryStateWrapper(
          state: StoryQueryState.error, data: allDataSoftHolder));
    }
  }

  Future<void> getHomeData({bool override = false}) async {
    try {
      if (override || (!override && HackerNewsCacheHelper.cacheTimeout())) {
        final homeDataResponse =
            await HackerNewsCacheHelper.getHomeStoriesFromNetwork();
        softDataHolder = HomeStoryData(
            carouselTopStories: homeDataResponse.carouselTopStories,
            newStories: homeDataResponse.newStories);
      }
      homeState.add(
          StoryStateWrapper(state: StoryQueryState.done, data: softDataHolder));
    } catch (err, stk) {
      debugPrint("Error in querying home data: $err --> $stk");
      homeState.add(StoryStateWrapper(
          state: StoryQueryState.error, data: softDataHolder));
    }
  }

  void softQuery() {
    print("Is this getting called");
    homeState.add(
        StoryStateWrapper(state: StoryQueryState.done, data: softDataHolder));
  }

  /// To be called when the user executes an action that translates to the
  /// equivalent of force-refresh. Executes an API call which is then cached.
  Future<void> hardQuery() async {
    await getHomeData(override: true);
  }
}

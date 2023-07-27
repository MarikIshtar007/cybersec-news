import 'dart:async';

import 'package:cybersec_news/models/HomeStoryData.dart';
import 'package:cybersec_news/models/base.dart';
import 'package:cybersec_news/models/home_response.dart';
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

  BehaviorSubject<StoryStateWrapper> get homeState => _homeState;

  HnProvider() {
    bool forceOverride = false;
    HomeResponse initialData = HackerNewsCacheHelper.getCachedHomeData();
    softDataHolder = HomeStoryData(
        carouselTopStories: initialData.topStories,
        newStories: initialData.newStories);
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
    debugPrint(HackerNewsCacheHelper.cacheTimeout().toString());
    getHomeData(override: forceOverride);
  }

  //TODO: Find an efficient way to handle this logic
  Future<void> getHomeData({bool override = false}) async {
    try {
      if (override) {
        final homeDataResponse =
            await HackerNewsCacheHelper.getHomeStoriesFromNetwork();
        softDataHolder = HomeStoryData(
            carouselTopStories: homeDataResponse.topStories,
            newStories: homeDataResponse.newStories);
      } else {
        if (HackerNewsCacheHelper.cacheTimeout()) {
          final homeDataResponse =
              await HackerNewsCacheHelper.getHomeStoriesFromNetwork();
          softDataHolder = HomeStoryData(
              carouselTopStories: homeDataResponse.topStories,
              newStories: homeDataResponse.newStories);
        }
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

import 'dart:async';

import 'package:cybersec_news/models/HomeStoryData.dart';
import 'package:cybersec_news/models/base.dart';
import 'package:cybersec_news/models/home_response.dart';
import 'package:cybersec_news/utility/api_cache_helper.dart';
import 'package:flutter/material.dart';

enum StoryQueryState { querying, background_querying, done, error }

class StoryStateWrapper {
  final BaseDataClass? data;
  final StoryQueryState state;

  StoryStateWrapper({required this.state, required this.data});
}

class HnProvider extends ChangeNotifier {
  final StreamController<StoryStateWrapper> _homeStories =
      StreamController.broadcast()
        ..add(StoryStateWrapper(state: StoryQueryState.querying, data: null));

  HomeStoryData softDataHolder =
      HomeStoryData(carouselTopStories: [], newStories: []);

  StreamController<StoryStateWrapper> get homeStories => _homeStories;

  HnProvider() {
    HomeResponse initialData = HackerNewsCacheHelper.getCachedHomeData();
    softDataHolder = HomeStoryData(
        carouselTopStories: initialData.topStories,
        newStories: initialData.newStories);
    homeStories.add(StoryStateWrapper(
        state: StoryQueryState.background_querying, data: softDataHolder));
    getHomeData();
  }

  //TODO: Find an efficient way to handle this logic
  Future<void> getHomeData({bool override = false}) async {
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
    homeStories.add(
        StoryStateWrapper(state: StoryQueryState.done, data: softDataHolder));
  }

  void softQuery() {
    homeStories.add(
        StoryStateWrapper(state: StoryQueryState.done, data: softDataHolder));
  }

  /// To be called when the user executes an action that translates to the
  /// equivalent of force-refresh. Executes an API call which is then cached.
  Future<void> hardQuery() async {
    await getHomeData(override: true);
  }
}

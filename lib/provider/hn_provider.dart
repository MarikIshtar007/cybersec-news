import 'dart:async';

import 'package:cybersec_news/hackernews_api/hackernews_api.dart';
import 'package:cybersec_news/models/HomeStoryData.dart';
import 'package:cybersec_news/models/base.dart';
import 'package:flutter/material.dart';

enum StoryQueryState { querying, done, error }

class StoryStateWrapper {
  final BaseDataClass? data;
  final StoryQueryState state;

  StoryStateWrapper({required this.state, required this.data});
}

class HnProvider extends ChangeNotifier {
  final StreamController<StoryStateWrapper> _homeStories =
      StreamController.broadcast()
        ..add(StoryStateWrapper(state: StoryQueryState.querying, data: null));

  StreamController<StoryStateWrapper> get homeStories => _homeStories;

  HnProvider() {
    getHomeData();
  }

  // Use flutter_cache_manager to cache api. Solve the repeated calls

  void getHomeData() async {
    List<HnStory> carouselTopStories = await HackerNews.getCarouselTopStories();
    List<HnStory> homeNewStories =
        await HackerNews.getStories(HnNewsType.newStories, count: 10);
    HomeStoryData homeStoryData = HomeStoryData(
        carouselTopStories: carouselTopStories, newStories: homeNewStories);
    homeStories.add(
        StoryStateWrapper(state: StoryQueryState.done, data: homeStoryData));
  }
}

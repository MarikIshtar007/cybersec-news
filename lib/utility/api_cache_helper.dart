import 'dart:convert';

import 'package:cybersec_news/hackernews_api/hackernews_api.dart';
import 'package:cybersec_news/models/all_story_data.dart';
import 'package:cybersec_news/models/home_story_data.dart';
import 'package:cybersec_news/utility/constants.dart';
import 'package:cybersec_news/utility/local_storage_schematic.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class HackerNewsCacheHelper {
  static const int _cacheTimeout = 3600 * 1000 * 1; // 1 hour timeout
  static final box = Hive.box('apiResponse');

  static bool cacheTimeout() {
    final cachedTopStoryResponse = box.values.firstWhere(
        (response) => response.url == kTopStoryIden,
        orElse: () => null);

    // Get new stories
    final LocalStorageSchematic cachedNewStoryResponse = box.values.firstWhere(
        (response) => response.url == kNewStoryIden,
        orElse: () => null);
    if (cachedNewStoryResponse == null || cachedTopStoryResponse == null)
      return true;
    print('${cachedNewStoryResponse.response}');
    return ((DateTime.now().millisecondsSinceEpoch -
                cachedTopStoryResponse.timestamp >
            _cacheTimeout) ||
        (DateTime.now().millisecondsSinceEpoch -
                cachedNewStoryResponse.timestamp >
            _cacheTimeout));
  }

  static HomeStoryData getCachedHomeData() {
    final List<HnStory> newStories = [];
    final List<HnStory> topStories = [];

    // Get top stories
    final cachedTopStoryResponse = box.values.firstWhere(
        (localStorageSchematic) => localStorageSchematic.url == kTopStoryIden,
        orElse: () => null);

    // Get new stories
    final cachedNewStoryResponse = box.values.firstWhere(
        (localStorageSchematic) => localStorageSchematic.url == kNewStoryIden,
        orElse: () => null);

    debugPrint("The extracted cachedTopStories are: $cachedTopStoryResponse");
    debugPrint("The extracted cachedNewStories are: $cachedNewStoryResponse");

    if (cachedTopStoryResponse != null) {
      final jsonTopData =
          json.decode(cachedTopStoryResponse.response) as Map<String, dynamic>;
      topStories.addAll((jsonTopData['data'] as List)
          .map((e) => HnStory.fromJson(e))
          .toList());
    }

    if (cachedNewStoryResponse != null) {
      final jsonNewData =
          json.decode(cachedNewStoryResponse.response) as Map<String, dynamic>;
      newStories.addAll((jsonNewData['data'] as List)
          .map((e) => HnStory.fromJson(e))
          .toList());
    }
    return HomeStoryData(
        carouselTopStories: topStories, newStories: newStories);
  }

  static Future<HomeStoryData> getHomeStoriesFromNetwork() async {
    // Get new data when cache is invalid/unavailable
    final result = await HackerNews.getStories(HnNewsType.topStories, 8);
    final jsonResponse = result.response as Map<String, dynamic>;

    final resultTwo = await HackerNews.getStories(HnNewsType.newStories, 10);
    final jsonResponseTwo = resultTwo.response as Map<String, dynamic>;

    // Clean cache before storing new data
    await box.clear();

    //Store new response to cache
    final lss = LocalStorageSchematic()
      ..url = kTopStoryIden
      ..response = json.encode(jsonResponse)
      ..timestamp = DateTime.now().millisecondsSinceEpoch;

    final lssTwo = LocalStorageSchematic()
      ..url = kNewStoryIden
      ..response = json.encode(jsonResponseTwo)
      ..timestamp = DateTime.now().millisecondsSinceEpoch;
    await box.add(lss).onError((error, stackTrace) {
      debugPrint("H#08: Error occurred $error");
      return 1;
    });
    await box.add(lssTwo).onError((error, stackTrace) {
      debugPrint("H#08: Error occurred $error");
      return 1;
    });

    return HomeStoryData(
        carouselTopStories: (jsonResponse['data'] as List)
            .map((e) => HnStory.fromJson(e))
            .toList(),
        newStories: (jsonResponseTwo['data'] as List)
            .map((e) => HnStory.fromJson(e))
            .toList());
  }

  static Future<AllStoryData> getAllStories(HnNewsType type) async {
    final result = await HackerNews.getStories(type, 50);
    final jsonRes = result.response as Map<String, dynamic>;

    return AllStoryData(
        (jsonRes['data'] as List).map((e) => HnStory.fromJson(e)).toList());
  }
}

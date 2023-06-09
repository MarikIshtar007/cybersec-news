import 'dart:convert';

import 'package:cybersec_news/hackernews_api/helper/constants.dart';
import 'package:cybersec_news/hackernews_api/helper/enums.dart';
import 'package:cybersec_news/hackernews_api/helper/exception.dart';
import 'package:cybersec_news/hackernews_api/model/comment.dart';
import 'package:cybersec_news/hackernews_api/model/story.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HackerNews {
  HackerNews({
    this.newsType = HnNewsType.topStories,
  });

  ///Specify news type
  ///
  ///[HnNewsType.topStories]
  ///[HnNewsType.askStories]
  ///[HnNewsType.newStories]
  ///[HnNewsType.showStories]
  ///[HnNewsType.jobStories]
  ///
  /// default is
  ///[HnNewsType.topStories]
  final HnNewsType newsType;

  static Future<List<HnStory>> getCarouselTopStories() async {
    final List<http.Response> response =
        await _getStories(HnNewsType.topStories, count: 8);

    final List<HnStory> stories = response.map((response) {
      final json = jsonDecode(response.body);

      return HnStory.fromJson(json);
    }).toList();

    return stories;
  }

  ///Function used to access stories which returns `List<Story>`
  static Future<List<HnStory>> getStories(HnNewsType type,
      {int count = 10}) async {
    final List<http.Response> responses = await _getStories(type);

    final List<HnStory> stories = responses.map((response) {
      final json = jsonDecode(response.body);

      return HnStory.fromJson(json);
    }).toList();

    return stories;
  }

  ///Function used to access single story by using [storyID]
  Future<HnStory> getStory(int storyID) async {
    http.Response response = await _getStory(storyID);

    final json = jsonDecode(response.body);

    return HnStory.fromJson(json);
  }

  ///Function used to access list of storyIds
  Future<List<dynamic>> getStoryIds(HnNewsType newsType) async {
    final response = await http.get(urlForStories(newsType));

    if (response.statusCode == 200) {
      dynamic storyIds = jsonDecode(response.body);

      return storyIds;
    } else {
      throw NewsException("Unable to fetch data! ${response.statusCode}");
    }
  }

  ///Function used to access story kids and return `List<Comments>`
  static Future<List<HnComment>> getComments(List<dynamic> kidIds) async {
    final List<http.Response> responses = await _getComments(kidIds);
    final List<HnComment> stories = responses.map((response) {
      debugPrint(response.body);
      final json = jsonDecode(response.body);

      return HnComment.fromJson(json);
    }).toList();

    return stories;
  }

  static Future<List<http.Response>> _getStories(HnNewsType type,
      {int count = 10}) async {
    final Uri uri = urlForStories(type);
    debugPrint("Request sent: ${uri.toString()}");
    final response = await http.get(urlForStories(type));
    debugPrint("Response Code: ${response.statusCode}");
    debugPrint("Response : ${response.body}");

    if (response.statusCode == 200) {
      Iterable storyIds = jsonDecode(response.body);

      return Future.wait(storyIds.take(count).map((storyId) {
        return _getStory(storyId);
      }));
    } else {
      throw NewsException("Unable to fetch data! ${response.statusCode}");
    }
  }

  ///Function used to access single story by using [storyId]
  static Future<http.Response> _getStory(int storyId) {
    return http.get(urlForStory(storyId));
  }

  static Future<List<http.Response>> _getComments(List<dynamic> kidIds) async {
    return Future.wait(kidIds.take(30).map((kidId) {
      return http.get(urlForStory(kidId));
    }));
  }
}

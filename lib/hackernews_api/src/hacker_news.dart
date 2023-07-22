import 'dart:convert';

import 'package:cybersec_news/hackernews_api/helper/constants.dart';
import 'package:cybersec_news/hackernews_api/helper/enums.dart';
import 'package:cybersec_news/hackernews_api/helper/exception.dart';
import 'package:cybersec_news/hackernews_api/model/comment.dart';
import 'package:cybersec_news/hackernews_api/model/story.dart';
import 'package:cybersec_news/models/api_response.dart';
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

  ///Queries the list of ids of the provided type and then gets each of its stories.
  /// Returns a GenericResponse object type with the response of a Map<String, dynamic>
  /// having the _data_ field set to a list of story objects.
  static Future<GenericResponse> getStories(HnNewsType type, int count) async {
    final Uri uri = urlForStories(type);
    final response = await http.get(urlForStories(type));
    debugPrint("GET Request sent to: ${uri.toString()}");
    debugPrint("Response Code:       ${response.statusCode}");
    debugPrint("Response :           ${response.body}");

    if (response.statusCode == 200) {
      Iterable storyIds = jsonDecode(response.body);
      Map<String, dynamic> data = <String, dynamic>{"data": []};
      var limitedItems = storyIds.take(count);
      for (int ids in limitedItems) {
        (data['data'] as List).add(json.decode((await _getStory(ids)).body));
      }

      debugPrint("Final Response: ${data.toString()}");
      return GenericResponse(status: 200, response: data, error: null);
    } else {
      throw NewsException("Unable to fetch data! ${response.statusCode}");
    }
  }

  ///Function used to access single story by using [storyId]
  static Future<http.Response> _getStory(int storyId) async {
    final http.Response response = await http.get(urlForStory(storyId));
    debugPrint("What is the response here ${storyId} => ${response.body}");
    return response;
  }

  static Future<List<http.Response>> _getComments(List<dynamic> kidIds) async {
    return Future.wait(kidIds.take(30).map((kidId) {
      return http.get(urlForStory(kidId));
    }));
  }
}

import 'package:cybersec_news/hackernews_api/model/story.dart';

class HomeResponse {
  final List<HnStory> topStories;
  final List<HnStory> newStories;

  HomeResponse({required this.topStories, required this.newStories});

  @override
  String toString() {
    // TODO: implement toString
    return "Object of HomeResponse:\n${this.topStories.toString()} \n${this.newStories.toString()}";
  }
}

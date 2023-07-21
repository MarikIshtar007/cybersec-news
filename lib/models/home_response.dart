import 'package:cybersec_news/hackernews_api/model/story.dart';

class HomeResponse {
  final List<HnStory> topStories;
  final List<HnStory> newStories;

  HomeResponse({required this.topStories, required this.newStories});
}

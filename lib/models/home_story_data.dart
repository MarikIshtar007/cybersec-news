import 'package:cybersec_news/hackernews_api/model/story.dart';
import 'package:cybersec_news/models/base.dart';

class HomeStoryData extends BaseDataClass {
  final List<HnStory> carouselTopStories;
  final List<HnStory> newStories;

  HomeStoryData({required this.carouselTopStories, required this.newStories});
}

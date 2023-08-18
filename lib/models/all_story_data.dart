import 'package:cybersec_news/hackernews_api/model/story.dart';
import 'package:cybersec_news/models/base.dart';

class AllStorySoftDataHolder extends BaseDataClass {
  List<HnStory> newStories;
  List<HnStory> topStories;

  AllStorySoftDataHolder({required this.newStories, required this.topStories});
  AllStorySoftDataHolder.none(
      {this.newStories = const [], this.topStories = const []});
}

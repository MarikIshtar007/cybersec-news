import 'package:cybersec_news/hackernews_api/model/story.dart';
import 'package:cybersec_news/models/base.dart';

class AllStoryData extends BaseDataClass {
  final List<HnStory> dataList;

  AllStoryData(this.dataList);

  AllStoryData.none({this.dataList = const []});
}

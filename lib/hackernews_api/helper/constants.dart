import 'package:intl/intl.dart';

import 'enums.dart';

Uri urlForStory(int storyId) {
  return Uri.parse("https://hacker-news.firebaseio.com/v0/item/$storyId.json");
}

Uri urlForStories(HnNewsType newsType) {
  return Uri.parse(newsType == HnNewsType.topStories
      ? "https://hacker-news.firebaseio.com/v0/topstories.json"
      : "https://hacker-news.firebaseio.com/v0/newstories.json");
}

DateFormat kStoryTileFormatter = DateFormat('yMMMd');

const double kHorizontalSpacingMargin = 14;
const double kVerticalSmallSpaceMargin = 5;

String getUniqueHeroTag(String content, {required String prefix}) {
  return prefix + content;
}

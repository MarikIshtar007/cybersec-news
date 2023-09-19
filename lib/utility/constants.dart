import 'dart:ui';

import 'package:cybersec_news/hackernews_api/hackernews_api.dart';

const String kTopStoryIden = "getTopStories";
const String kNewStoryIden = "getNewStories";

const Color hnPrimaryColor = Color(0xFF424242);
const Color hnSecondaryColor = Color(0xFFCFD8DC);
const Color hnPrimaryTextColor = Color(0xFFF2F2F2);

String enumToString(HnNewsType type) {
  switch (type) {
    case HnNewsType.topStories:
      return "Top Stories";

    case HnNewsType.newStories:
      return "New Stories";

    case HnNewsType.askStories:
      return "Ask Stories";

    case HnNewsType.showStories:
      return "Show Stories";

    case HnNewsType.jobStories:
      return "Job Stories";
  }
}

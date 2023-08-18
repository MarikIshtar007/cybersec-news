import 'package:cybersec_news/hackernews_api/hackernews_api.dart';

const String kTopStoryIden = "getTopStories";
const String kNewStoryIden = "getNewStories";

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

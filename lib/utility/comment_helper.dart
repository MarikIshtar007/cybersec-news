String getCommentTime(int timestamp) {
  DateTime commentTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  Duration duration = DateTime.now().difference(commentTime);

  if (duration.inDays > 0) {
    return "${duration.inDays.toString()}d";
  } else if (duration.inHours > 0) {
    return "${duration.inHours.toString()}h";
  } else if (duration.inMinutes > 0) {
    return "${duration.inMinutes.toString()}m";
  } else {
    return "${duration.inSeconds.toString()}";
  }
}

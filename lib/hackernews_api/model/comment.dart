class HnComment {
  ///The item's unique id.
  final int id;

  ///The comment, story or poll text. HTML.
  final String text;

  ///The username of the item's author.
  final String by;

  ///The type of item. One of "job", "story", "comment", "poll", or "pollopt".
  final String type;

  ///The item's parent. For comments, either another comment
  ///or the relevant story. For pollopts, the relevant poll.
  final int parent;

  ///Creation time of the story, in unix time
  final int time;

  ///Story is dead or not
  final bool dead;

  ///Story is deleted or not
  final bool deleted;

  ///The ids of the item's comments, in ranked display order
  final List<dynamic> kids;

  HnComment({
    required this.id,
    required this.text,
    required this.by,
    required this.type,
    required this.parent,
    required this.time,
    required this.dead,
    required this.deleted,
    required this.kids,
  });

  factory HnComment.fromJson(json) {
    return HnComment(
      id: json['id'],
      text: json["text"],
      by: json['by'],
      type: json['type'],
      parent: json['parent'],
      time: json['time'],
      dead: json['dead'] ?? false,
      deleted: json['deleted'] ?? false,
      kids: json['kids']?.cast<int>() ?? [],
    );
  }
}

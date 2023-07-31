import 'package:cybersec_news/hackernews_api/hackernews_api.dart';
import 'package:cybersec_news/hackernews_api/helper/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StoryDetailOpenWidget extends StatefulWidget {
  final HnStory hnStory;

  const StoryDetailOpenWidget(this.hnStory, {Key? key}) : super(key: key);

  @override
  State<StoryDetailOpenWidget> createState() => _StoryDetailOpenWidgetState();
}

class _StoryDetailOpenWidgetState extends State<StoryDetailOpenWidget> {
  final List<HnComment> comments = [];

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    comments.clear();
    comments.addAll(await HackerNews.getComments(widget.hnStory.kids));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.01,
            horizontal: MediaQuery.of(context).size.width * 0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width:
                      Theme.of(context).textTheme.headlineSmall!.fontSize! * 3,
                  height:
                      Theme.of(context).textTheme.headlineSmall!.fontSize! * 3,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text(
                    widget.hnStory.title[0],
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.headlineSmall!.fontSize! *
                              1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.hnStory.title,
                        style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .fontSize,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      RichText(
                          text: TextSpan(
                              text: "by ${widget.hnStory.by} ",
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontStyle: FontStyle.italic,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .fontSize),
                              children: [
                            TextSpan(
                              text:
                                  " •  ${kStoryTileFormatter.format(DateTime.fromMillisecondsSinceEpoch(widget.hnStory.time * 1000))}",
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontStyle: FontStyle.normal,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .fontSize),
                            )
                          ])),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        child: Text(
                          'Read more!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                        ),
                      ),
                      TextButton(
                        child: Row(
                          children: [
                            Text(
                              'Copy Link',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              width: 14,
                            ),
                            FaIcon(
                              FontAwesomeIcons.clipboard,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        child: Row(
                          children: [
                            Text(
                              'Share',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 14,
                            ),
                            FaIcon(
                              FontAwesomeIcons.shareFromSquare,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // Expanded(
                //   flex: 2,
                //   child: Column(
                //     children: [
                //       Text('by ${widget.hnStory.by}'),
                //       Text(
                //         kStoryTileFormatter.format(
                //             DateTime.fromMillisecondsSinceEpoch(
                //                 widget.hnStory.time * 1000)),
                //         style: TextStyle(
                //           color: Colors.grey,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //       Text((widget.hnStory.kids.isEmpty ||
                //               widget.hnStory.descendants == 0)
                //           ? 'No Comments'
                //           : '${NumberFormat.compact().format(widget.hnStory.descendants)} comments')
                //     ],
                //   ),
                // ),
              ],
            ),
            Divider(
              endIndent: 30,
              indent: 30,
              thickness: 3,
              color: Colors.grey,
            ),
            Text(
              'Comments',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            if (comments.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final commentData = comments[index];
                    if (commentData.type == "comment") {
                      return Comment(commentData);
                    } else {
                      print(commentData.type);
                      return FlutterLogo();
                    }
                  },
                  itemCount: comments.length,
                ),
              )
            else
              Text('No comments today!!!!!!!')
          ],
        ),
      ),
    );
  }
}

class Comment extends StatefulWidget {
  final HnComment commentData;

  const Comment(this.commentData, {Key? key}) : super(key: key);

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onLongPress: () {
          //TODO Handle copying to clipboard
        },
        isThreeLine: false,
        dense: true,
        minVerticalPadding: 0,
        contentPadding: EdgeInsets.symmetric(horizontal: 0),
        title: RichText(
            text: TextSpan(
                text: "${widget.commentData.by}  ",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
                children: [
              TextSpan(
                  text:
                      "•  " + getCommentTime(widget.commentData.time) + " ago",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ))
            ])),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Html(
              data: widget.commentData.text,
              onLinkTap: (url, context, map, element) {
                debugPrint("The tapped url: $url");
                //TODO: Launch webview to view the comment in:
                // Either make a custom webview or a custom page to
                // showcase just the post and comment in question.
              },
              //TODO: Add onImageTAp
//https://github.com/Sub6Resources/flutter_html/tree/master/example
              onAnchorTap: (url, _, __, ___) {
                print("dddd $url");
              },
            ),
            //TODO: Launch new page and show single comment tree with recursive child iterations
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.2),
              child: InkWell(
                onTap: () {
                  //TODO: Goto new page
                },
                child: Text('Read Replies'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

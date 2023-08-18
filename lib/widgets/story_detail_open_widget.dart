import 'package:cybersec_news/hackernews_api/hackernews_api.dart';
import 'package:cybersec_news/utility/comment_helper.dart';
import 'package:cybersec_news/widgets/story_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
            StoryHeader(widget.hnStory),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: TextButton(
                    child: Text(
                      'Read the Story',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () async {
                      try {
                        await launchUrl(Uri.parse(widget.hnStory.url));
                      } catch (err, stk) {
                        debugPrint("Something went wrong: $err => $stk");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Something went wrong'),
                        ));
                      }
                    },
                    style: TextButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 6,
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
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 6,
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
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            Divider(
              endIndent: 30,
              indent: 30,
              thickness: 2,
              height: 28,
              color: Colors.grey,
            ),
            Text(
              'Comments',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            if (comments.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final commentData = comments[index];
                    if (commentData.type == "comment") {
                      if (commentData.by.isEmpty)
                        return const SizedBox.shrink();
                      return Comment(widget.hnStory, commentData);
                    } else {
                      print(commentData.type);
                      return FlutterLogo();
                    }
                  },
                  itemCount: comments.length,
                ),
              )
            else
              const Text('No comments today!!!!!!!')
          ],
        ),
      ),
    );
  }
}

class Comment extends StatefulWidget {
  final HnStory hnStory;
  final HnComment commentData;

  const Comment(this.hnStory, this.commentData, {Key? key}) : super(key: key);

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      child: ListTile(
        onLongPress: () async {
          await Clipboard.setData(ClipboardData(
                  text:
                      "${widget.commentData.by} wrote :\n${widget.commentData.text}"))
              .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Successfully copied to clipboard"))));
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
                  text: "•  ${getCommentTime(widget.commentData.time)} ago",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ))
            ])),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Html(
                data: widget.commentData.text,
                onLinkTap: (url, _, __, ___) {
                  debugPrint("The tapped url: $url");
                  //TODO: Launch webview to view the comment in:
                  try {
                    if (url != null) {
                      launchUrl(Uri.parse(url));
                    }
                  } catch (err, stk) {
                    debugPrint("Something went wrong: $err => $stk");
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Something went wrong'),
                    ));
                  }
                },
                //TODO: Add onImageTAp
//https://github.com/Sub6Resources/flutter_html/tree/master/example
                onAnchorTap: (url, _, __, ___) {
                  try {
                    if (url != null) {
                      launchUrl(Uri.parse(url));
                    }
                  } catch (err, stk) {
                    debugPrint("Something went wrong: $err => $stk");
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Something went wrong'),
                    ));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cybersec_news/hackernews_api/hackernews_api.dart';
import 'package:cybersec_news/utility/comment_helper.dart';
import 'package:cybersec_news/widgets/story_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class CommentDetail extends StatefulWidget {
  final HnStory hnStory;
  final HnComment hnComment;
  const CommentDetail(this.hnStory, this.hnComment, {Key? key})
      : super(key: key);

  @override
  State<CommentDetail> createState() => _CommentDetailState();
}

class _CommentDetailState extends State<CommentDetail> {
  final Map<int, dynamic> comments = {};

  @override
  void initState() {
    super.initState();
    queryChildComments(widget.hnComment);
  }

  Future<void> queryChildComments(HnComment comment) async {
    if (comment.kids.isEmpty) return;
    // for(int id in comment.kids){
    //   HnComment
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          automaticallyImplyLeading: true,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              StoryHeader(widget.hnStory),
              SizedBox(
                height: 16,
              ),
              Card(
                elevation: 0.0,
                color: Colors.transparent,
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
                          text: "${widget.hnComment.by}  ",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                          children: [
                        TextSpan(
                            text: "•  " +
                                getCommentTime(widget.hnComment.time) +
                                " ago",
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
                          data: widget.hnComment.text,
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
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HnCommentView {
  int id;
  String text;
  String by;
  String type;
  int parent;
  int time;
  List<HnCommentView> children;

  HnCommentView(
      {required this.id,
      required this.text,
      required this.by,
      required this.type,
      required this.time,
      required this.parent,
      List<HnCommentView>? children})
      : children = children ?? [];
}

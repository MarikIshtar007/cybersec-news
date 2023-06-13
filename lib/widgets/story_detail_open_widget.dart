import 'package:cybersec_news/hackernews_api/hackernews_api.dart';
import 'package:cybersec_news/hackernews_api/helper/constants.dart';
import 'package:flutter/material.dart';
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
            vertical: MediaQuery.of(context).size.height * 0.03,
            horizontal: MediaQuery.of(context).size.width * 0.05),
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
                          'Read it!',
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
                              'Copy',
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
            if (comments.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return FlutterLogo();
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

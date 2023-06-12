import 'package:animations/animations.dart';
import 'package:cybersec_news/hackernews_api/hackernews_api.dart';
import 'package:cybersec_news/hackernews_api/helper/constants.dart';
import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class HnStoryListTile extends StatefulWidget {
  final HnStory hnStory;

  HnStoryListTile(this.hnStory, {Key? key}) : super(key: key);

  @override
  State<HnStoryListTile> createState() => _HnStoryListTileState();
}

class _HnStoryListTileState extends State<HnStoryListTile> {
  final List<HnComment> comments = [];

  void getComments() async {
    comments.clear();
    comments.addAll(await HackerNews.getComments(widget.hnStory.kids));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // return InkWell(
    //   onTap: () {
    //     Navigator.of(context)
    //         .push(MaterialPageRoute(builder: (context) => StoryScreen()));
    //   },
    //   child: Card(
    //     margin: EdgeInsets.only(
    //         bottom: Theme.of(context).textTheme.displaySmall!.fontSize! * 0.4),
    //     elevation: 0.0,
    //     child: ListTile(
    //       visualDensity: VisualDensity(vertical: 4),
    //       leading: Hero(
    //         tag: getUniqueHeroTag(hnStory.id.toString(), prefix: hnStory.type),
    //         child: Container(
    //           alignment: Alignment.center,
    //           width: Theme.of(context).textTheme.displaySmall!.fontSize! * 1.5,
    //           height: Theme.of(context).textTheme.displaySmall!.fontSize! * 1.5,
    //           decoration: BoxDecoration(
    //             color: Colors.grey.shade300,
    //             borderRadius: BorderRadius.circular(12),
    //           ),
    //           padding: EdgeInsets.all(10),
    //           child: Text(
    //             hnStory.title[0],
    //             style: TextStyle(
    //               fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //         ),
    //       ),
    //       title: Padding(
    //         padding: EdgeInsets.only(
    //             bottom:
    //                 Theme.of(context).textTheme.displaySmall!.fontSize! * 0.2),
    //         child: Text(
    //           hnStory.title,
    //           style: TextStyle(
    //             color: Colors.grey.shade800,
    //             fontWeight: FontWeight.w700,
    //           ),
    //         ),
    //       ),
    //       subtitle: Padding(
    //         padding: const EdgeInsets.only(right: 8.0),
    //         child: Row(
    //           children: [
    //             SizedBox(
    //               width: 4,
    //             ),
    //             Text(
    //               '@' + hnStory.by,
    //             ),
    //             Spacer(),
    //             Icon(
    //               Icons.access_time_outlined,
    //               size: 20,
    //             ),
    //             SizedBox(
    //               width: 4,
    //             ),
    //             Text(
    //               kStoryTileFormatter.format(
    //                   DateTime.fromMillisecondsSinceEpoch(hnStory.time * 1000)),
    //             ),
    //             Spacer(),
    //             FaIcon(
    //               FontAwesomeIcons.comments,
    //               size: 20,
    //             ),
    //             SizedBox(
    //               width: 4,
    //             ),
    //             Text(hnStory.kids.length.toString())
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    return OpenContainer(
      tappable: false,
      closedBuilder: (context, action) {
        return GestureDetector(
          onTap: () {
            action();
            getComments();
          },
          child: Card(
            margin: EdgeInsets.only(
                bottom:
                    Theme.of(context).textTheme.displaySmall!.fontSize! * 0.4),
            elevation: 0.0,
            child: ListTile(
              visualDensity: VisualDensity(vertical: 4),
              leading: Hero(
                tag: getUniqueHeroTag(widget.hnStory.id.toString(),
                    prefix: widget.hnStory.type),
                child: Container(
                  alignment: Alignment.center,
                  width:
                      Theme.of(context).textTheme.displaySmall!.fontSize! * 1.5,
                  height:
                      Theme.of(context).textTheme.displaySmall!.fontSize! * 1.5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text(
                    widget.hnStory.title[0],
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.displaySmall!.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              title: Padding(
                padding: EdgeInsets.only(
                    bottom:
                        Theme.of(context).textTheme.displaySmall!.fontSize! *
                            0.2),
                child: Text(
                  widget.hnStory.title,
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '@' + widget.hnStory.by,
                    ),
                    Spacer(),
                    Icon(
                      Icons.access_time_outlined,
                      size: 20,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      kStoryTileFormatter.format(
                          DateTime.fromMillisecondsSinceEpoch(
                              widget.hnStory.time * 1000)),
                    ),
                    Spacer(),
                    FaIcon(
                      FontAwesomeIcons.comments,
                      size: 20,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(widget.hnStory.kids.length.toString())
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 300),
      transitionType: ContainerTransitionType.fadeThrough,
      openBuilder: (context, _) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.03,
                horizontal: MediaQuery.of(context).size.width * 0.05),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: DropCapText(
                      widget.hnStory.title,
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.headlineSmall!.fontSize,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w700,
                      ),
                      dropCapPosition: DropCapPosition.start,
                      dropCapPadding: EdgeInsets.only(right: 16),
                      dropCap: DropCap(
                        width: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .fontSize! *
                            3,
                        height: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .fontSize! *
                            3,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            widget.hnStory.title[0],
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .fontSize! *
                                  1.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Row(
                          children: [
                            TextButton(
                              child: Text('Visit'),
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text('by ${widget.hnStory.by}'),
                            Text(
                              kStoryTileFormatter.format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      widget.hnStory.time * 1000)),
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text((widget.hnStory.kids.isEmpty ||
                                    widget.hnStory.descendants == 0)
                                ? 'No Comments'
                                : '${NumberFormat.compact(locale: widget.hnStory.descendants.toString())} comments')
                          ],
                        ),
                      ),
                      Text(
                        '@ ${widget.hnStory.by}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    endIndent: 30,
                    indent: 30,
                    thickness: 3,
                    color: Colors.grey,
                  ),
                  if (comments.isNotEmpty)
                    ListView.builder(
                      itemBuilder: (context, index) {
                        return FlutterLogo();
                      },
                      itemCount: comments.length,
                    )
                  else
                    Text('No comments today!!!!!!!')
                ],
              ),
            ),
          ),
        );
      },
    );
    // return InkWell(
    //   onTap: () {
    //     // Handle the onTap for redirecting to a new screen.
    //     // Hero Animations cue. Look into push transitions as well
    //   },
    //   child: ,
    // );
  }
}

// Legacy Code:
/*
Kept for dev purposes:
    Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Flexible(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.16,
              height: MediaQuery.of(context).size.width * 0.16,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(10),
              child: Text(
                hnStory.title[0],
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  hnStory.title,
                )
              ],
            ),
          )
        ],
      ),
    );
 */

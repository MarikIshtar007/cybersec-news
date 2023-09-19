import 'package:animations/animations.dart';
import 'package:cybersec_news/hackernews_api/hackernews_api.dart';
import 'package:cybersec_news/hackernews_api/helper/constants.dart';
import 'package:cybersec_news/utility/constants.dart';
import 'package:cybersec_news/widgets/story_detail_open_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HnStoryListTile extends StatefulWidget {
  final HnStory hnStory;

  HnStoryListTile(this.hnStory, {Key? key}) : super(key: key);

  @override
  State<HnStoryListTile> createState() => _HnStoryListTileState();
}

class _HnStoryListTileState extends State<HnStoryListTile> {
  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      // DO NOT REMOVE; unless flutter fixes this bug
      // Roundabout way of opening the container using tappable false is to
      // prevent multiple recalls of the build method of the open widget,
      // leading to multiple API calls
      // Ref: https://github.com/flutter/flutter/issues/74111
      tappable: false,
      closedColor: hnPrimaryColor,
      closedBuilder: (context, action) {
        return GestureDetector(
          onTap: () {
            action();
          },
          child: Card(
            color: hnPrimaryColor,
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
                    color: hnSecondaryColor,
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
                    color: hnPrimaryTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.ideographic,
                  children: [
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      '@' + widget.hnStory.by,
                      style: TextStyle(
                        color: hnPrimaryTextColor,
                      ),
                    ),
                    Spacer(),
                    FaIcon(
                      FontAwesomeIcons.clock,
                      size: 14,
                      color: hnPrimaryTextColor,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      kStoryTileFormatter.format(
                          DateTime.fromMillisecondsSinceEpoch(
                              widget.hnStory.time * 1000)),
                      style: TextStyle(
                        color: hnPrimaryTextColor,
                      ),
                    ),
                    Spacer(),
                    FaIcon(
                      FontAwesomeIcons.comments,
                      size: 14,
                      color: hnPrimaryTextColor,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      widget.hnStory.kids.length.toString(),
                      style: TextStyle(
                        color: hnPrimaryTextColor,
                      ),
                    )
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
        return StoryDetailOpenWidget(widget.hnStory);
      },
    );
  }
}

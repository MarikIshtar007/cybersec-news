import 'package:cybersec_news/hackernews_api/helper/constants.dart';
import 'package:cybersec_news/hackernews_api/model/story.dart';
import 'package:flutter/material.dart';

class StoryHeader extends StatelessWidget {
  final HnStory hnStory;
  const StoryHeader(this.hnStory, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: Theme.of(context).textTheme.headlineSmall!.fontSize! * 3,
          height: Theme.of(context).textTheme.headlineSmall!.fontSize! * 3,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(10),
          child: Text(
            hnStory.title[0],
            style: TextStyle(
              fontSize:
                  Theme.of(context).textTheme.headlineSmall!.fontSize! * 1.5,
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
                hnStory.title,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w700,
                ),
              ),
              RichText(
                  text: TextSpan(
                      text: "by ${hnStory.by} ",
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge!.fontSize),
                      children: [
                    TextSpan(
                      text:
                          " •  ${kStoryTileFormatter.format(DateTime.fromMillisecondsSinceEpoch(hnStory.time * 1000))}",
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.normal,
                          fontSize:
                              Theme.of(context).textTheme.bodyLarge!.fontSize),
                    )
                  ])),
            ],
          ),
        )
      ],
    );
  }
}

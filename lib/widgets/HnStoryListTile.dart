import 'package:cybersec_news/hackernews_api/hackernews_api.dart';
import 'package:cybersec_news/hackernews_api/helper/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HnStoryListTile extends StatelessWidget {
  final HnStory hnStory;
  const HnStoryListTile(this.hnStory, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
          bottom: Theme.of(context).textTheme.displaySmall!.fontSize! * 0.4),
      elevation: 0.0,
      child: ListTile(
        visualDensity: VisualDensity(vertical: 4),
        leading: Container(
          alignment: Alignment.center,
          width: Theme.of(context).textTheme.displaySmall!.fontSize! * 1.5,
          height: Theme.of(context).textTheme.displaySmall!.fontSize! * 1.5,
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
        title: Padding(
          padding: EdgeInsets.only(
              bottom:
                  Theme.of(context).textTheme.displaySmall!.fontSize! * 0.4),
          child: Text(
            hnStory.title,
            style: TextStyle(
              color: Colors.grey.shade800,
            ),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.at,
                size: 20,
              ),
              Text(
                hnStory.by,
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
                    DateTime.fromMillisecondsSinceEpoch(hnStory.time * 1000)),
              ),
              Spacer(),
              FaIcon(
                FontAwesomeIcons.comments,
                size: 20,
              ),
              SizedBox(
                width: 4,
              ),
              Text(hnStory.kids.length.toString())
            ],
          ),
        ),
      ),
    );
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

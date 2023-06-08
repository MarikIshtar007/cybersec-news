import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cybersec_news/hackernews_api/helper/constants.dart';
import 'package:cybersec_news/models/announcement_data.dart';
import 'package:flutter/material.dart';

class Announcements extends StatefulWidget {
  const Announcements({Key? key}) : super(key: key);

  @override
  State<Announcements> createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  @override
  void initState() {
    super.initState();
    print('Wonder if this gets printed');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: kHorizontalSpacingMargin,
          vertical: kVerticalSmallSpaceMargin),
      child: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('announcements').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final List<AnnouncementData> data = snapshot.data!.docs
              .map((doc) => AnnouncementData.fromDocumentSnapshot(doc))
              .toList();
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return AnnouncementTile(data[index]);
            },
          );
        },
      ),
    );
  }
}

class AnnouncementTile extends StatelessWidget {
  final AnnouncementData data;

  const AnnouncementTile(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: data.backdrop.isEmpty
                ? const AssetImage('assets/nyit_bear.png')
                : NetworkImage(data.backdrop) as ImageProvider,
            fit: BoxFit.cover),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
          child: Column(
            children: [
              Flexible(
                child: Text(
                  data.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Flexible(
                  child: Text(
                data.description,
                maxLines: 3,
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
              )),
              if (data.images.isNotEmpty)
                ListView.builder(
                  itemBuilder: (context, index) {
                    if (index == data.images.length) {
                      return Icon(
                        Icons.keyboard_arrow_right,
                        size: 45,
                      );
                    }
                    return Container(
                      width: 60,
                      height: 60,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.pinkAccent,
                      ),
                    );
                  },
                  itemCount: data.images.length + 1,
                ),
              TextButton(
                onPressed: () {},
                child: Text('See More'),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16))),
              )
            ],
          ),
        ),
      ),
    );
  }
}

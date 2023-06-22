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
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: kHorizontalSpacingMargin,
          vertical: kVerticalSmallSpaceMargin),
      child: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('announcements').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(snapshot.error.toString()),
            ));
          }
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
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Color(0xFF24366E),
            image: DecorationImage(
                opacity: 0.4,
                image: data.backdrop.isEmpty
                    ? const AssetImage('assets/nyit_bear.png')
                    : NetworkImage(data.backdrop) as ImageProvider)),
        margin: EdgeInsets.symmetric(vertical: 10),
        width: MediaQuery.of(context).size.width * 0.85,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                data.name,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Expanded(
                child: Text(
              data.description,
              maxLines: 3,
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w800,
                fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                fontStyle: FontStyle.italic,
              ),
            )),
            // if (data.images.isNotEmpty)
            //   ListView.builder(
            //     itemBuilder: (context, index) {
            //       if (index == data.images.length) {
            //         return Icon(
            //           Icons.keyboard_arrow_right,
            //           size: 45,
            //         );
            //       }
            //       return Container(
            //         width: 60,
            //         height: 60,
            //         margin: EdgeInsets.all(10),
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(16),
            //           color: Colors.pinkAccent,
            //         ),
            //       );
            //     },
            //     itemCount: data.images.length + 1,
            //   ),

            if (data.actionBtnDisplay)
              TextButton(
                onPressed: () {},
                child: Text(
                  data.actionBtnText,
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.headlineSmall!.fontSize),
                ),
                style: TextButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16))),
              ),
          ],
        ),
      ),
    );
  }
}

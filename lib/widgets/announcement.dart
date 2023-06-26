import 'package:cached_network_image/cached_network_image.dart';
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
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return FractionallySizedBox(
                heightFactor: 0.8,
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          data.name,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xFF24366E),
                            fontSize: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .fontSize,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          data.description,
                          maxLines: 3,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xFF24366E).withOpacity(0.6),
                            fontWeight: FontWeight.w800,
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .fontSize,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        child: Container(
                          height: MediaQuery.of(context).size.width * 0.13,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ImageFullView(data.images[index])));
                                },
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Hero(
                                    tag: data.images[index],
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                              data.images[index],
                                            ),
                                            fit: BoxFit.fill,
                                          )),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: data.images.length,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
      },
      child: AspectRatio(
        aspectRatio: 1.1,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color(0xFF24366E),
              image: DecorationImage(
                  opacity: 0.4,
                  fit: BoxFit.fill,
                  image: data.backdrop.isEmpty
                      ? const AssetImage(
                          'assets/nyit_bear.png',
                        )
                      : CachedNetworkImageProvider(
                          data.backdrop,
                        ) as ImageProvider)),
          margin: EdgeInsets.symmetric(vertical: 10),
          width: MediaQuery.of(context).size.width * 0.85,
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.04,
              vertical: 10),
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
                    fontSize:
                        Theme.of(context).textTheme.displaySmall!.fontSize,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Flexible(
                child: Text(
                  data.description,
                  maxLines: 3,
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w800,
                    fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageFullView extends StatelessWidget {
  final String _imageUrl;
  const ImageFullView(this._imageUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: true
      ),
      backgroundColor: Colors.black,
      body: InteractiveViewer(
        child: Hero(
          tag: _imageUrl,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: CachedNetworkImageProvider(
                      _imageUrl,
                    ))),
          ),
        ),
      ),
    );
  }
}

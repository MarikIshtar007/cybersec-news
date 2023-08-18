import 'package:cybersec_news/hackernews_api/hackernews_api.dart';
import 'package:cybersec_news/models/all_story_data.dart';
import 'package:cybersec_news/provider/hn_provider.dart';
import 'package:cybersec_news/utility/constants.dart';
import 'package:cybersec_news/widgets/hn_story_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class StoryViewAllScreen extends StatefulWidget {
  final HnNewsType type;

  const StoryViewAllScreen(this.type, {Key? key}) : super(key: key);

  @override
  State<StoryViewAllScreen> createState() => _StoryViewAllScreenState();
}

class _StoryViewAllScreenState extends State<StoryViewAllScreen> {
  @override
  void initState() {
    super.initState();
    queryAllStories();
  }

  void queryAllStories() {
    Provider.of<HnProvider>(context, listen: false).getAllStories(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.white,
          ),
          automaticallyImplyLeading: true,
          title: Text(enumToString(widget.type)),
          actions: [
            IconButton(
              icon: FaIcon(FontAwesomeIcons.arrowsRotate),
              onPressed: () async {
                await Provider.of<HnProvider>(context, listen: false)
                    .getAllStories(widget.type);
              },
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: StreamBuilder(
          stream: Provider.of<HnProvider>(context).allStoryState.stream,
          builder: (context, AsyncSnapshot<StoryStateWrapper> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went terribly wrong. '));
            }
            if (snapshot.data == null) {
              return Center(
                child: ListTile(
                  title: Text("Wow. So empty"),
                  leading: CircularProgressIndicator(),
                ),
              );
            }
            switch (snapshot.data!.state) {
              case StoryQueryState.background_querying:
                final data = snapshot.data!.data as AllStorySoftDataHolder;
                if (widget.type == HnNewsType.topStories) {
                  return BasicListView(
                    data.topStories,
                    loading: true,
                  );
                } else {
                  return BasicListView(
                    data.newStories,
                    loading: true,
                  );
                }
              case StoryQueryState.querying:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case StoryQueryState.done:
                final data = snapshot.data!.data as AllStorySoftDataHolder;
                if (widget.type == HnNewsType.topStories) {
                  return BasicListView(data.topStories);
                } else {
                  return BasicListView(data.newStories);
                }
              case StoryQueryState.error:
                final data = snapshot.data!.data as AllStorySoftDataHolder;
                if ((widget.type == HnNewsType.topStories &&
                        data.topStories.isEmpty) ||
                    (widget.type == HnNewsType.newStories &&
                        data.newStories.isEmpty)) {
                  return Center(
                      child: Text(
                          "It seems we are having trouble connecting to the network-something"));
                }
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                    'There was some error getting updated data. Please try again later!',
                  ),
                  duration: Duration(seconds: 6),
                  dismissDirection: DismissDirection.horizontal,
                ));
                if (widget.type == HnNewsType.newStories) {
                  return BasicListView(data.newStories);
                } else {
                  return BasicListView(data.topStories);
                }
            }
          },
        ));
  }
}

class BasicListView extends StatelessWidget {
  final List<HnStory> hnStoryList;
  final bool loading;

  const BasicListView(this.hnStoryList, {this.loading = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        ListView.builder(
          itemCount: hnStoryList.length,
          itemBuilder: (context, index) {
            return HnStoryListTile(hnStoryList[index]);
          },
        ),
        AnimatedPositioned(
          top: loading ? 40 : -60,
          duration: Duration(milliseconds: 400),
          child: Material(
            elevation: 4.0,
            shape: CircleBorder(),
            child: Container(
                height: 50,
                width: 50,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircularProgressIndicator()),
          ),
        )
      ],
    );
  }
}

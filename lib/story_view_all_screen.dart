import 'package:cybersec_news/hackernews_api/hackernews_api.dart';
import 'package:cybersec_news/provider/hn_provider.dart';
import 'package:cybersec_news/utility/string_capitalization.dart';
import 'package:cybersec_news/widgets/hn_story_tile.dart';
import 'package:flutter/material.dart';
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
          automaticallyImplyLeading: true,
          title: Text(widget.type.toString().split('.').last.capitalize()),
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
                  return BasicListView(data.topStories.dataList);
                } else {
                  return BasicListView(data.newStories.dataList);
                }
              case StoryQueryState.querying:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case StoryQueryState.done:
                final data = snapshot.data!.data as AllStorySoftDataHolder;
                if (widget.type == HnNewsType.topStories) {
                  return BasicListView(data.topStories.dataList);
                } else {
                  return BasicListView(data.newStories.dataList);
                }
              case StoryQueryState.error:
                final data = snapshot.data!.data as AllStorySoftDataHolder;
                return Center(
                    child: Text(
                        "It seems we are having trouble connecting to the network-something"));
              // if (data.newStories) {
              //   return Center(
              //       child: Text(
              //           "It seems we are having trouble connecting to the network-something"));
              // } else {
              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //     content: Text('It looks like we failed to get the data!'),
              //   ));
              //   return BasicListView(data.dataList);
              // }
            }
          },
        ));
  }
}

class BasicListView extends StatelessWidget {
  final List<HnStory> hnStoryList;

  const BasicListView(this.hnStoryList, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: hnStoryList.length,
      itemBuilder: (context, index) {
        return HnStoryListTile(hnStoryList[index]);
      },
    );
  }
}

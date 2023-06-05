import 'package:cybersec_news/hackernews_api/hackernews_api.dart';
import 'package:cybersec_news/widgets/HnStoryListTile.dart';
import 'package:flutter/material.dart';

class NewStoriesList extends StatefulWidget {
  const NewStoriesList({Key? key}) : super(key: key);

  @override
  State<NewStoriesList> createState() => _NewStoriesListState();
}

class _NewStoriesListState extends State<NewStoriesList> {
  late Future<List<HnStory>> storyList;

  @override
  void initState() {
    super.initState();
    storyList = getStories(HnNewsType.newStories);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HnStory>>(
      future: storyList,
      builder: (context, AsyncSnapshot<List<HnStory>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.connectionState == ConnectionState.done &&
            (snapshot.hasError || snapshot.data == null)) {
          return SliverToBoxAdapter(child: Text('Something has gone wrong'));
        }
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final dataList = snapshot.data as List<HnStory>;
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return HnStoryListTile(dataList[index]);
              },
              childCount: dataList.length,
            ),
          );
        }

        return SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}

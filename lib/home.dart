import 'package:cybersec_news/hackernews_api/helper/enums.dart';
import 'package:cybersec_news/hackernews_api/model/story.dart';
import 'package:cybersec_news/models/home_story_data.dart';
import 'package:cybersec_news/provider/hn_provider.dart';
import 'package:cybersec_news/story_view_all_screen.dart';
import 'package:cybersec_news/widgets/announcement.dart';
import 'package:cybersec_news/widgets/hn_story_tile.dart';
import 'package:cybersec_news/widgets/top_stories_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  int selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: NavigationBar(
          destinations: [
            NavigationDestination(
                icon: FaIcon(
                  FontAwesomeIcons.globe,
                ),
                label: 'Stories'),
            NavigationDestination(
                icon: FaIcon(
                  FontAwesomeIcons.bullhorn,
                ),
                label: 'Announcements')
          ],
          selectedIndex: selectedTabIndex,
          onDestinationSelected: (idx) {
            setState(() {
              selectedTabIndex = idx;
            });
            Provider.of<HnProvider>(context, listen: false).softQuery();
          },
        ),
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.white,
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () => _key.currentState!.openDrawer(),
            icon: Icon(
              Icons.menu_rounded,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.bookmark_outline,
                size: 30,
                color: Colors.black,
              ),
              onPressed: () {},
            )
          ],
        ),
        body: const [MainBody(), Announcements()][selectedTabIndex]);
  }
}

class MainBody extends StatefulWidget {
  const MainBody({Key? key}) : super(key: key);

  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<HnProvider>(context).homeState.stream,
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
            final data = snapshot.data!.data as HomeStoryData;
            if ((data.carouselTopStories.isEmpty) ||
                (data.newStories.isEmpty)) {
              return Center(child: CircularProgressIndicator());
            } else {
              final List<HnStory> carouselData =
                  (snapshot.data!.data as HomeStoryData).carouselTopStories;
              final List<HnStory> newStoryData =
                  (snapshot.data!.data as HomeStoryData).newStories;
              //TODO: Stack + little progress indicator -- check passing down variable for state
              return BodyContent(
                  carouselData: carouselData, newStoryData: newStoryData);
            }
          case StoryQueryState.querying:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case StoryQueryState.done:
            final List<HnStory> carouselData =
                (snapshot.data!.data as HomeStoryData).carouselTopStories;
            debugPrint(
                "H#08: ==> ${(snapshot.data!.data as HomeStoryData).carouselTopStories}");
            debugPrint(carouselData.toString());
            final List<HnStory> newStoryData =
                (snapshot.data!.data as HomeStoryData).newStories;
            return BodyContent(
                carouselData: carouselData, newStoryData: newStoryData);
          case StoryQueryState.error:
            final data = snapshot.data!.data as HomeStoryData;
            if ((data.carouselTopStories.isEmpty) ||
                (data.newStories.isEmpty)) {
              return Center(
                  child: Text(
                      "It seems we are having trouble connecting to the network-something"));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('It looks like we failed to get the data!'),
              ));
              return BodyContent(
                  carouselData: data.carouselTopStories,
                  newStoryData: data.newStories);
            }
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class BodyContent extends StatelessWidget {
  final List<HnStory> newStoryData;
  final List<HnStory> carouselData;

  const BodyContent(
      {required this.carouselData, required this.newStoryData, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<HnProvider>(context, listen: false).hardQuery();
        },
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.04),
                padding: EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Stories',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                    TextButton(
                      child: Text(
                        'View all',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                StoryViewAllScreen(HnNewsType.topStories)));
                      },
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: TopStoriesCarousel(carouselData),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.04),
                padding: EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'New Stories',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                    TextButton(
                      child: Text(
                        'View all',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                StoryViewAllScreen(HnNewsType.newStories)));
                      },
                    )
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return HnStoryListTile(newStoryData[index]);
                },
                childCount: newStoryData.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}

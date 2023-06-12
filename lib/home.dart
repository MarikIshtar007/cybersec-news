import 'package:cybersec_news/hackernews_api/model/story.dart';
import 'package:cybersec_news/models/HomeStoryData.dart';
import 'package:cybersec_news/provider/hn_provider.dart';
import 'package:cybersec_news/top_stories_carousel.dart';
import 'package:cybersec_news/widgets/announcement.dart';
import 'package:cybersec_news/widgets/hn_story_tile.dart';
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
          onDestinationSelected: (idx) => setState(() {
            selectedTabIndex = idx;
          }),
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

class _MainBodyState extends State<MainBody> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<HnProvider>(context).homeStories.stream,
      builder: (context, AsyncSnapshot<StoryStateWrapper> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went terribly wrong. '));
        }
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.state == StoryQueryState.querying) {
          return Center(child: CircularProgressIndicator());
        } else {
          final List<HnStory> carouselData =
              (snapshot.data!.data as HomeStoryData).carouselTopStories;
          final List<HnStory> newStoryData =
              (snapshot.data!.data as HomeStoryData).newStories;
          return Container(
            alignment: Alignment.topCenter,
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
                          onPressed: () {},
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
                          onPressed: () {},
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
          );
        }
      },
    );
  }
}

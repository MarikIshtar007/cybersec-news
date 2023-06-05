import 'package:cybersec_news/new_stories_list.dart';
import 'package:cybersec_news/top_stories_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  int selectedTabIndex = 0;
  static const List<Widget> _tabOptions = [
    Text('Index 0: Stories'),
    Text('Index 1: Announcements'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedIconTheme: IconThemeData(
          color: Colors.blue,
        ),
        selectedLabelStyle: TextStyle(
          color: Colors.blue,
        ),
        unselectedLabelStyle: TextStyle(
          color: Colors.grey.shade200,
        ),
        unselectedIconTheme: IconThemeData(
          color: Colors.grey.shade400,
        ),
        currentIndex: 0,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.globe,
              ),
              label: 'Stories'),
          BottomNavigationBarItem(
              icon: FaIcon(
                FontAwesomeIcons.bullhorn,
              ),
              label: 'Announcements')
        ],
      ),
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
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
      body: Container(
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
              child: TopStoriesCarousel(),
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
            NewStoriesList()
          ],
        ),
      ),
    );
  }
}

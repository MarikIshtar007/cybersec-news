import 'package:carousel_slider/carousel_slider.dart';
import 'package:cybersec_news/hackernews_api/hackernews_api.dart';
import 'package:flutter/material.dart';

class TopStoriesCarousel extends StatefulWidget {
  const TopStoriesCarousel({Key? key}) : super(key: key);

  @override
  State<TopStoriesCarousel> createState() => _TopStoriesCarouselState();
}

class _TopStoriesCarouselState extends State<TopStoriesCarousel> {
  late Future<List<HnStory>> storyList;
  final CarouselController controller = CarouselController();
  @override
  void initState() {
    super.initState();
    storyList = getCarouselTopStories();
  }

  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder<List<HnStory>>(
        future: storyList,
        builder: (context, AsyncSnapshot<List<HnStory>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.done &&
              (snapshot.hasError || snapshot.data == null)) {
            return Text('Something has gone wrong');
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            final List<HnStory> data = snapshot.data as List<HnStory> ?? [];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 10,
                  child: CarouselSlider.builder(
                      carouselController: controller,
                      itemCount: data.length,
                      itemBuilder: (ctx, idx, _) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  data[idx].title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                          viewportFraction: 0.8,
                          aspectRatio: 2.0,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          enableInfiniteScroll: true,
                          autoPlayCurve: Curves.easeInOut,
                          onPageChanged: (idx, reason) {
                            setState(() {
                              _current = idx;
                            });
                          })),
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: data
                        .asMap()
                        .entries
                        .map((e) => GestureDetector(
                              onTap: () => controller.animateToPage(e.key),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 150),
                                width: _current == e.key ? 16.0 : 7.0,
                                height: 7.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 4.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: _current == e.key
                                      ? Colors.blue
                                      : Colors.grey.withOpacity(0.2),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                )
              ],
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}

import 'package:animations/animations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cybersec_news/hackernews_api/hackernews_api.dart';
import 'package:cybersec_news/hackernews_api/helper/constants.dart';
import 'package:cybersec_news/widgets/story_detail_open_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TopStoriesCarousel extends StatefulWidget {
  final List<HnStory> carouselData;

  const TopStoriesCarousel(this.carouselData, {Key? key}) : super(key: key);

  @override
  State<TopStoriesCarousel> createState() => _TopStoriesCarouselState();
}

class _TopStoriesCarouselState extends State<TopStoriesCarousel> {
  late Future<List<HnStory>> storyList;
  final CarouselController controller = CarouselController();

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 10,
            child: CarouselSlider.builder(
                carouselController: controller,
                itemCount: widget.carouselData.length,
                itemBuilder: (ctx, idx, _) {
                  return OpenContainer(
                    openBuilder: (context, _) {
                      return StoryDetailOpenWidget(widget.carouselData[idx]);
                    },
                    closedBuilder: (context, action) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: kHorizontalSpacingMargin,
                              vertical: kVerticalSmallSpaceMargin * 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 6,
                                child: Text(
                                  widget.carouselData[idx].title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const VerticalDivider(
                                indent: 10,
                                endIndent: 10,
                                color: Colors.grey,
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0, vertical: 16.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          const FaIcon(
                                            FontAwesomeIcons.at,
                                            size: 20,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Flexible(
                                            child: Text(
                                              widget.carouselData[idx].by,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                            size: 20,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            kStoryTileFormatter.format(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    widget.carouselData[idx]
                                                            .time *
                                                        1000)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          const FaIcon(
                                            FontAwesomeIcons.comments,
                                            size: 20,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(widget
                                              .carouselData[idx].kids.length
                                              .toString())
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                options: CarouselOptions(
                    autoPlayInterval: Duration(seconds: 7),
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
              children: widget.carouselData
                  .asMap()
                  .entries
                  .map((e) => GestureDetector(
                        onTap: () => controller.animateToPage(e.key),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 150),
                          width: _current == e.key ? 16.0 : 7.0,
                          height: 7.0,
                          margin: const EdgeInsets.symmetric(
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
      ),
    );
  }
}

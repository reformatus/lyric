import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/ui/base/home/parts/promo/news_carousel.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final ScrollController linksListController;

  @override
  void initState() {
    linksListController = ScrollController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sófár DalApp')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Theme.of(context).colorScheme.onPrimary,
            child: Column(
              children: [
                NewsCarousel(),
                SizedBox(
                  height: 30,
                  child: FadingEdgeScrollView.fromScrollView(
                    child: ListView(
                      controller: linksListController,
                      scrollDirection: Axis.horizontal,
                      children: [
                        FilledButton.tonal(onPressed: () {}, child: Text('hi')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

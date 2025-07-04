import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/main.dart';
import 'package:lyric/services/home/promo/rss.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsCarousel extends ConsumerWidget {
  const NewsCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final news = ref.watch(getNewsProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      child: news.when(
        data: (newsItems) {
          // Hide the carousel if there are no news items
          if (newsItems.isEmpty) {
            return const SizedBox.shrink(key: ValueKey('empty'));
          }

          return _buildCarousel(
            context,
            key: const ValueKey('news'),
            newsItems: newsItems,
          );
        },
        loading: () => _buildLoadingCarousel(key: const ValueKey('loading')),
        error: (_, _) => const SizedBox.shrink(key: ValueKey('error')),
      ),
    );
  }

  Widget _buildLoadingCarousel({Key? key}) {
    final children = List.generate(
      3, // Show 3 loading placeholders
      (_) => const _LoadingCarouselItem(),
    );

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.only(left: 8, top: 8),
          child: const Text(
            'AKTUÁLIS',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          height: 120,
          child: CarouselView(
            itemExtent: 160,
            itemSnapping: globals.isDesktop ? false : true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            shrinkExtent: 100,
            onTap: null, // Disable tap during loading
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildCarousel(
    BuildContext context, {
    Key? key,
    required List<HomepageNewsItem> newsItems,
  }) {
    final children = newsItems
        .map((newsItem) => _NewsCarouselItem(newsItem: newsItem))
        .toList();

    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.only(left: 8, top: 8),
          child: Text(
            'AKTUÁLIS',
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          height: 120,
          child: CarouselView(
            itemExtent: 160,
            itemSnapping: globals.isDesktop ? false : true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            shrinkExtent: 100,
            onTap: (index) async {
              try {
                await launchUrl(newsItems[index].link);
              } catch (_) {}
            },
            children: children,
          ),
        ),
      ],
    );
  }
}

class _NewsCarouselItem extends StatelessWidget {
  final HomepageNewsItem newsItem;

  const _NewsCarouselItem({required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background image
        if (newsItem.backgroundImgUri != null)
          Image.network(
            newsItem.backgroundImgUri!.toString(),
            fit: BoxFit.cover,
            height: 120,
            width: 160,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 100,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.image_not_supported, color: Colors.grey),
            ),
          )
        else
          Container(
            height: 120,
            width: 160,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.article, color: Colors.grey),
          ),
        // Gradient overlay
        Container(
          height: 120,
          width: 160,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black87],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        // Title text
        Positioned(
          bottom: 8,
          left: 9,
          right: 6,
          child: Text(
            newsItem.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            softWrap: true,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _LoadingCarouselItem extends StatelessWidget {
  const _LoadingCarouselItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 150,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

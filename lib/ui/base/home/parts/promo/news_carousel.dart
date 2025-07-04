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

    return news.when(
      data: (newsItems) {
        // Hide the carousel if there are no news items
        if (newsItems.isEmpty) {
          return const SizedBox.shrink();
        }

        return _buildCarousel(newsItems: newsItems);
      },
      loading: () => _buildCarousel(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Widget _buildCarousel({List<HomepageNewsItem>? newsItems}) {
    final List<Widget> children;

    if (newsItems != null) {
      children = newsItems
          .map((newsItem) => _NewsCarouselItem(newsItem: newsItem))
          .toList();
    } else {
      children = List.generate(
        3, // Show 3 loading placeholders
        (_) => const _LoadingCarouselItem(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.only(left: 8),
          child: const Text(
            'AKTUÁLIS',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 100,
          child: CarouselView(
            itemExtent: 150,
            itemSnapping: globals.isDesktop ? false : true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 7),
            shrinkExtent: 100,
            onTap: newsItems != null
                ? (index) async {
                    try {
                      await launchUrl(newsItems[index].link);
                    } catch (e) {
                      // Handle error silently or show a subtle error indication
                    }
                  }
                : null,
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
            height: 100,
            width: 150,
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
            height: 100,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.article, color: Colors.grey),
          ),
        // Gradient overlay
        Container(
          height: 100,
          width: 150,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black54],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        // Title text
        Positioned(
          bottom: 4,
          left: 6,
          right: 6,
          child: Text(
            newsItem.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
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

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xml/xml.dart';

import '../../../data/log/logger.dart';
import '../../../main.dart';

part 'rss.g.dart';

class HomepageNewsItem {
  Uri? backgroundImgUri;
  Uri link;
  String title;

  HomepageNewsItem({
    required this.backgroundImgUri,
    required this.link,
    required this.title,
  });

  factory HomepageNewsItem.fromRssItem(XmlElement item) {
    try {
      final title = item.findElements('title').first.innerText;
      final linkText = item.findElements('link').first.innerText;
      final link = Uri.parse(linkText);

      Uri? backgroundImgUri;
      try {
        final featuredImageElement = item.findElements('featured_image').first;
        backgroundImgUri = Uri.parse(featuredImageElement.innerText);
      } catch (_) {}

      return HomepageNewsItem(
        title: title,
        link: link,
        backgroundImgUri: backgroundImgUri,
      );
    } catch (e, s) {
      log.warning('Invalid RSS news feed item!', e, s);
      rethrow;
    }
  }
}

class HomepageButtonItem {
  Uri link;
  String title;
  IconData icon;

  HomepageButtonItem({
    required this.link,
    required this.title,
    required this.icon,
  });
}

/*
  Inspired by rss_dart
*/
@Riverpod(keepAlive: true)
Future<List<HomepageNewsItem>> getNews(Ref ref) async {
  final response = await globals.dio.get<String>(constants.newsRss);
  if (response.data == null) {
    log.warning("Couldn't get news: No response!");
    return [];
  }
  final feed = XmlDocument.parse(response.data!);
  try {
    final channel = feed.findAllElements('channel').first;
    final items = channel.findAllElements('item');

    final news = items
        .map((item) => HomepageNewsItem.fromRssItem(item))
        .toList();
    return news;
  } catch (e, s) {
    log.warning("Couldn't get news: Invalid RSS feed!", e, s);
    return [];
  }
}

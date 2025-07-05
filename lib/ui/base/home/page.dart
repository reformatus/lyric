import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/ui/base/home/parts/banks/bank_chooser.dart';
import 'package:lyric/ui/base/home/parts/promo/news_carousel.dart';
import 'package:lyric/ui/base/home/parts/promo/buttons_section.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sófár DalApp')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Theme.of(context).colorScheme.onPrimary,
            child: Column(children: [NewsCarousel(), ButtonsSection()]),
          ),
          Expanded(child: BankChooser()),
        ],
      ),
    );
  }
}

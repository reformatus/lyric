import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/ui/base/home/parts/banks/bank_chooser.dart';
import 'package:lyric/ui/base/home/parts/preferences/dialog.dart';
import 'package:lyric/ui/base/home/parts/promo/news_carousel.dart';
import 'package:lyric/ui/base/home/parts/promo/buttons_section.dart';

import '../../common/log/button.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sófár DalApp'),
        actions: [
          LogButton(),
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => PreferencesDialog(),
            ),
            icon: Icon(Icons.settings_outlined),
            tooltip: 'Beállítások',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Theme.of(context).colorScheme.onPrimary,
            elevation: 3,
            child: AnimatedSize(
              duration: Durations.long1,
              child: Column(children: [NewsCarousel(), ButtonsSection()]),
            ),
          ),
          SizedBox(height: 8),
          Expanded(child: BankChooser()),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../data/song/song.dart';
import 'sheet/view.dart';

class SongTabView extends StatefulWidget {
  final Song song;

  const SongTabView({required this.song, Key? key}) : super(key: key);

  @override
  State<SongTabView> createState() => _SongTabViewState();
}

class _SongTabViewState extends State<SongTabView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarColor = theme.appBarTheme.backgroundColor;

    final tabBar = TabBar(
      controller: _tabController,
      indicatorColor: theme.colorScheme.secondary,
      tabs: const [Tab(text: 'Kotta'), Tab(text: 'Szöveg')],
      labelPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    );

    return OrientationBuilder(
      builder: (context, orientation) {
        final isLandscape = orientation == Orientation.landscape;

        return Flex(
          direction: isLandscape ? Axis.horizontal : Axis.vertical,
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Sheet music tab
                  Center(child: SheetView(widget.song)),

                  // Lyrics tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(widget.song.lyrics, style: theme.textTheme.bodyLarge),
                  ),
                ],
              ),
            ),
            Material(color: appBarColor, child: RotatedBox(quarterTurns: isLandscape ? 1 : 0, child: tabBar)),
          ],
        );
      },
    );
  }
}

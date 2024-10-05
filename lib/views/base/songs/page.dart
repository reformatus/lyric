import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/data/bank/bank.dart';
import 'package:lyric/views/base/songs/filter/execute.dart';
import 'package:lyric/views/base/songs/filter/widgets/filters.dart';
import 'package:lyric/views/base/songs/songTile.dart';

import '../../../data/song/song.dart';

class SongsPage extends ConsumerStatefulWidget {
  const SongsPage({super.key});

  @override
  ConsumerState<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends ConsumerState<SongsPage> {
  @override
  void initState() {
    super.initState();
    _overlayPortalController = OverlayPortalController();
  }

  late OverlayPortalController _overlayPortalController;
  final _link = LayerLink();

  @override
  Widget build(BuildContext context) {
    final songs = ref.watch(filteredSongListProvider);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: TextField(
              autocorrect: false,
              decoration: InputDecoration(
                hintText: 'Keresés',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: CompositedTransformTarget(
                  link: _link,
                  child: OverlayPortal(
                    controller: _overlayPortalController,
                    overlayChildBuilder: (context) =>
                        CompositedTransformFollower(
                      link: _link,
                      followerAnchor: Alignment.topRight,
                      targetAnchor: Alignment.bottomRight,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          width: 300,
                          child: Card(
                            elevation: 10,
                            clipBehavior: Clip.antiAlias,
                            child: SingleChildScrollView(
                              child: Text("TBD"),
                            ),
                          ),
                        ),
                      ),
                    ),
                    child: IconButton(
                      tooltip: 'Miben keressen',
                      icon: _overlayPortalController.isShowing
                          ? const Icon(Icons.close)
                          : const Icon(Icons.check_box_outlined),
                      onPressed: () {
                        _overlayPortalController.toggle();
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(maxHeight: constraints.maxHeight / 2),
                    child: FadingEdgeScrollView.fromSingleChildScrollView(
                      // todo make stack. if scrolled, show a close button at top right
                      child: SingleChildScrollView(
                        controller: ScrollController(),
                        child: ExpansionTile(
                          title: const ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(Icons.filter_list),
                              title: Text('Szűrők')),
                          children: [
                            FiltersColumn(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: switch (songs) {
                    AsyncLoading() =>
                      const Center(child: CircularProgressIndicator()),
                    AsyncError(:final error) => Center(
                        child: Card(
                          // todo factor out to general error widget
                          margin: const EdgeInsets.all(8),
                          color: Colors.red,
                          child: ListTile(
                            title: const Text('Hiba történt!'),
                            subtitle: Text(error.toString()),
                            leading: const Icon(Icons.error),
                          ),
                        ),
                      ),
                    AsyncValue(:final value) => ListView.separated(
                        itemBuilder: (BuildContext context, int i) {
                          return LSongTile(value!.elementAt(i));
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 0),
                        itemCount: value?.length ?? 0),
                  },
                )
              ],
            );
          }),
        ),
        GestureDetector(
          // When showing the overlay, the user can tap anywhere to close it
          onTap: () {
            if (_overlayPortalController.isShowing) {
              _overlayPortalController.toggle();
              setState(() {});
            }
          },
          behavior: _overlayPortalController.isShowing
              ? HitTestBehavior.opaque
              : HitTestBehavior.deferToChild,
        )
      ],
    );
  }
}

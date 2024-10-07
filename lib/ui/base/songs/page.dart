import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lyric/services/songs/filter.dart';
import 'package:lyric/ui/base/songs/filter/state.dart';
import 'package:lyric/ui/base/songs/filter/widgets/filters.dart';
import 'package:lyric/ui/base/songs/song_tile.dart';

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
    _filterScrollController = ScrollController();
    _filterExpansionTileController = ExpansionTileController();
    _filterScrollController.addListener(() {
      if (_filterScrollController.offset > 0) {
        if (!filtersScrolled) {
          setState(() {
            filtersScrolled = true;
          });
        }
      } else {
        if (filtersScrolled) {
          setState(() {
            filtersScrolled = false;
          });
        }
      }
    });
  }

  bool filtersScrolled = false;

  late OverlayPortalController _overlayPortalController;
  late ScrollController _filterScrollController;
  late ExpansionTileController _filterExpansionTileController;
  final _link = LayerLink();

  @override
  Widget build(BuildContext context) {
    final songs = ref.watch(filteredSongListProvider);
    final filterState = ref.watch(filterStateProvider);

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
                    overlayChildBuilder: (context) => CompositedTransformFollower(
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
                    constraints: BoxConstraints(maxHeight: constraints.maxHeight / 2),
                    child: Stack(
                      children: [
                        FadingEdgeScrollView.fromSingleChildScrollView(
                          child: SingleChildScrollView(
                            controller: _filterScrollController,
                            child: Theme(
                              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                controller: _filterExpansionTileController,
                                leading: const Icon(Icons.filter_list),
                                title: Text('Szűrők'),
                                children: [
                                  FiltersColumn(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (filtersScrolled)
                          Positioned(
                            right: 12,
                            top: 6,
                            child: IconButton.filledTonal(
                              icon: Icon(Icons.expand_less),
                              onPressed: () {
                                _filterScrollController.jumpTo(0);
                                _filterExpansionTileController.collapse();
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: switch (songs) {
                    AsyncLoading() => const Center(child: CircularProgressIndicator()),
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
          behavior:
              _overlayPortalController.isShowing ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
        )
      ],
    );
  }
}

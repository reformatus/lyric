import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/bank/banks.dart';
import 'widgets/filter/types/bank/state.dart';
import '../../../data/bank/bank.dart';
import '../../common/centered_hint.dart';

import '../../../main.dart';
import '../../../services/songs/filter.dart';
import '../../common/error/card.dart';
import 'widgets/filter/types/key/state.dart';
import 'widgets/filter/types/multiselect-tags/state.dart';
import 'widgets/filter/types/search/search_field_selector.dart';
import 'widgets/filter/types/search/state.dart';
import 'widgets/filter/filters_column.dart';
import 'widgets/song_tile.dart';

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
    _filterExpansionScrollController = ScrollController();
    _filterSidebarScrollController = ScrollController();
    _filterExpansionTileController = ExpansibleController();
    _searchFieldController = TextEditingController(
      text: ref.read(searchStringStateProvider),
    );
    _searchFieldController.addListener(() {
      ref
          .read(searchStringStateProvider.notifier)
          .set(_searchFieldController.text);
    });

    _filterExpansionScrollController.addListener(() {
      if (_filterExpansionScrollController.offset > 0) {
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
  late ScrollController _filterExpansionScrollController;
  late ScrollController _filterSidebarScrollController;
  late ExpansibleController _filterExpansionTileController;
  late TextEditingController _searchFieldController;
  final _link = LayerLink();

  bool get _areAllFiltersEmpty {
    final filterState = ref.read(multiselectTagsFilterStateProvider);
    final keyFilterState = ref.read(keyFilterStateProvider);
    final banksFilterState = ref.read(banksFilterStateProvider);
    return filterState.isEmpty &&
        keyFilterState.isEmpty &&
        banksFilterState.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final banks = ref.watch(watchAllBanksProvider);
    final songResults = ref.watch(filteredSongsProvider);
    final filterState = ref.watch(multiselectTagsFilterStateProvider);
    final keyFilterState = ref.watch(keyFilterStateProvider);
    final banksFilterState = ref.watch(banksFilterStateProvider);
    final searchString = ref.watch(searchStringStateProvider);

    // TODO refactor: move search to appbar
    return Scaffold(
      body: switch (banks) {
        AsyncLoading() => Center(child: CircularProgressIndicator()),
        AsyncError(:final error, :final stackTrace) => Center(
          child: LErrorCard(
            type: LErrorType.error,
            title: 'Nem sikerült betölteni a daltárakat!',
            icon: Icons.library_music,
            message: error.toString(),
            stack: stackTrace.toString(),
          ),
        ),
        AsyncValue<List<Bank>>(value: final banks!) => Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 5,
                                child: songResults.isLoading
                                    ? LinearProgressIndicator()
                                    : null,
                              ),
                              // Search bar
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: TextField(
                                  controller: _searchFieldController,
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                    hintText: 'Keresés (min. 3 betű)',
                                    prefixIcon:
                                        _searchFieldController.text.isEmpty
                                        ? Icon(Icons.search)
                                        : IconButton(
                                            icon: Icon(Icons.clear),
                                            onPressed: () =>
                                                _searchFieldController.clear(),
                                          ),
                                    suffixIcon: CompositedTransformTarget(
                                      link: _link,
                                      child: OverlayPortal(
                                        controller: _overlayPortalController,
                                        overlayChildBuilder: (context) =>
                                            CompositedTransformFollower(
                                              link: _link,
                                              followerAnchor:
                                                  Alignment.topRight,
                                              targetAnchor:
                                                  Alignment.bottomRight,
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: SizedBox(
                                                  width: 300,
                                                  child: Card(
                                                    elevation: 10,
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    child: SingleChildScrollView(
                                                      child:
                                                          SearchFieldSelectorColumn(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        child: IconButton(
                                          tooltip: 'Miben keressen',
                                          icon:
                                              _overlayPortalController.isShowing
                                              ? const Icon(Icons.close)
                                              : const Icon(
                                                  Icons.check_box_outlined,
                                                ),
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
                            ],
                          ),
                          // Filters expansion tile on small screens
                          if (constraints.maxWidth < constants.tabletFromWidth)
                            Card(
                              clipBehavior: Clip.antiAlias,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: constraints.maxHeight / 2,
                                ),
                                child: Stack(
                                  children: [
                                    FadingEdgeScrollView.fromSingleChildScrollView(
                                      child: SingleChildScrollView(
                                        controller:
                                            _filterExpansionScrollController,
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                            dividerColor: Colors.transparent,
                                          ),
                                          child: ExpansionTile(
                                            expansionAnimationStyle: AnimationStyle(
                                              duration: Durations.medium1,
                                              curve: Curves
                                                  .easeInOutCubicEmphasized,
                                              //reverseDuration: Durations.medium1,
                                              //reverseCurve: Curves.easeInOutCubicEmphasized,
                                            ),
                                            collapsedBackgroundColor:
                                                _areAllFiltersEmpty
                                                ? null
                                                : Theme.of(context)
                                                      .colorScheme
                                                      .secondaryContainer,
                                            collapsedIconColor:
                                                _areAllFiltersEmpty
                                                ? null
                                                : Theme.of(context)
                                                      .colorScheme
                                                      .onSecondaryContainer,
                                            controller:
                                                _filterExpansionTileController,
                                            leading: const Icon(
                                              Icons.filter_list,
                                            ),
                                            title: FiltersTitle(
                                              banks: banks,
                                              filterState: filterState,
                                              keyFilterState: keyFilterState,
                                              banksFilterState:
                                                  banksFilterState,
                                            ),
                                            children: [FiltersColumn()],
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
                                            _filterExpansionScrollController
                                                .jumpTo(0);
                                            _filterExpansionTileController
                                                .collapse();
                                          },
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          Expanded(
                            // Songs list
                            child: switch (songResults) {
                              AsyncError(:final error, :final stackTrace) =>
                                Center(
                                  child: LErrorCard(
                                    type: LErrorType.error,
                                    title: 'Hová lettek a dalok? :(',
                                    message: error.toString(),
                                    icon: Icons.error,
                                    stack: stackTrace.toString(),
                                  ),
                                ),
                              AsyncValue(:final value) =>
                                value == null
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : searchString.isNotEmpty &&
                                          searchString.length < 3
                                    ? CenteredHint(
                                        'Írj be legalább három betűt a kereséshez.',
                                        iconData: Icons.search,
                                      )
                                    : value.isEmpty
                                    ? CenteredHint(
                                        'Nincs találat :(',
                                        iconData: Icons.search_off,
                                      )
                                    : ListView.builder(
                                        itemBuilder:
                                            (BuildContext context, int i) {
                                              return LSongResultTile(
                                                value.elementAt(i),
                                                banksFilterState.length == 1
                                                    ? null
                                                    : banks.firstWhere(
                                                        (b) =>
                                                            b.uuid ==
                                                            value
                                                                .elementAt(i)
                                                                .song
                                                                .sourceBank,
                                                      ),
                                              );
                                            },
                                        itemCount: value.length,
                                      ),
                            },
                          ),
                        ],
                      ),
                    ),
                    // Filters column in wide view
                    if (constraints.maxWidth >= constants.tabletFromWidth)
                      SizedBox(
                        width: (constraints.maxWidth / 3).clamp(
                          380,
                          double.infinity,
                        ),
                        child: Scaffold(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surface,
                          appBar: AppBar(
                            title: FiltersTitle(
                              banks: banks,
                              filterState: filterState,
                              keyFilterState: keyFilterState,
                              banksFilterState: banksFilterState,
                            ),
                            automaticallyImplyLeading: false,
                            backgroundColor: _areAllFiltersEmpty
                                ? Theme.of(context).colorScheme.surface
                                : Theme.of(
                                    context,
                                  ).colorScheme.secondaryContainer,
                          ),
                          body: FadingEdgeScrollView.fromSingleChildScrollView(
                            child: SingleChildScrollView(
                              controller: _filterSidebarScrollController,
                              child: FiltersColumn(),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
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
            ),
          ],
        ),
      },
    );
  }
}

class FiltersTitle extends ConsumerWidget {
  const FiltersTitle({
    super.key,
    required this.banks,
    required this.filterState,
    required this.keyFilterState,
    required this.banksFilterState,
  });

  final List<Bank> banks;
  final Map<String, List<String>> filterState;
  final KeyFilters keyFilterState;
  final Set<String> banksFilterState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedSize(
      duration: Durations.medium1,
      curve: Curves.easeInOutCubicEmphasized,
      child: Row(
        children: [
          Expanded(
            child: Text(
              (filterState.isEmpty && keyFilterState.isEmpty)
                  ? 'Szűrők'
                  : ([
                      if (keyFilterState.isNotEmpty)
                        [
                          if (keyFilterState.keys.isNotEmpty)
                            keyFilterState.keys
                                .map((e) => e.toString())
                                .join(' vagy '),
                          if (keyFilterState.pitches.isNotEmpty ||
                              keyFilterState.modes.isNotEmpty)
                            [
                              if (keyFilterState.pitches.isNotEmpty)
                                'alaphangja ${keyFilterState.pitches.join(' vagy ')}',
                              if (keyFilterState.modes.isNotEmpty)
                                'hangsora ${keyFilterState.modes.join(' vagy ')}',
                            ].join(' és '),
                        ].join(', vagy '),
                      if (filterState.isNotEmpty)
                        filterState.values
                            .map((e) => e.join(' vagy '))
                            .join(', és '),
                    ].join(', valamint ')),
              style: TextStyle(
                color: (filterState.isEmpty && keyFilterState.isEmpty)
                    ? null
                    : Theme.of(context).colorScheme.onSecondaryContainer,
                fontSize: (filterState.isEmpty && keyFilterState.isEmpty)
                    ? null
                    : Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
              softWrap: true,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ...banksFilterState
              .map((i) => banks.firstWhere((b) => b.uuid == i))
              .map(
                (b) => b.tinyLogo != null
                    ? Tooltip(
                        message: b.name,
                        child: SizedBox.square(
                          dimension: 30,
                          child: Image.memory(b.tinyLogo!),
                        ),
                      )
                    : ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 50),
                        child: Text(
                          b.name,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                        ),
                      ),
              ),
          if (banksFilterState.isNotEmpty) SizedBox(width: 10),
          if (filterState.isNotEmpty ||
              keyFilterState.isNotEmpty ||
              banksFilterState.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                // TODO move filter states to sealed superclass and iterate trough reset (??) || Or at least move this to a service.
                ref
                    .read(multiselectTagsFilterStateProvider.notifier)
                    .resetAllFilters();
                ref.read(keyFilterStateProvider.notifier).reset();
                ref.read(banksFilterStateProvider.notifier).reset();
              },
            ),
        ],
      ),
    );
  }
}

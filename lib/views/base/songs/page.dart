import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:lyric/data/bank/bank.dart';
import 'package:lyric/views/base/songs/songTile.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({super.key});

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  @override
  void initState() {
    super.initState();
    _overlayPortalController = OverlayPortalController();
  }

  late OverlayPortalController _overlayPortalController;
  final _link = LayerLink();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          child: Column(
                            children: [
                              LCheckboxTile(
                                label: 'Cím',
                                value: true,
                                onTap: (_) {},
                              ),
                              LCheckboxTile(
                                label: 'Cím (eredeti)',
                                value: true,
                                onTap: (_) {},
                              ),
                              LCheckboxTile(
                                label: 'Kezdősor',
                                value: true,
                                onTap: (_) {},
                              ),
                              LCheckboxTile(
                                label: 'Dalszerző',
                                value: true,
                                onTap: (_) {},
                              ),
                              LCheckboxTile(
                                label: 'Szövegíró',
                                value: true,
                                onTap: (_) {},
                              ),
                              LCheckboxTile(
                                label: 'Fordította',
                                value: true,
                                onTap: (_) {},
                              ),
                              LCheckboxTile(
                                label: 'Igeszakasz',
                                value: true,
                                onTap: (_) {},
                              ),
                              LCheckboxTile(
                                label: 'Református Énekeskönyv',
                                value: true,
                                onTap: (_) {},
                              ),
                            ],
                          ),
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
                  child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: ExpansionTile(
                      title: const ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.filter_list),
                          title: Text('Szűrők')),
                      children: [
                        Column(
                          children: [
                            LFilterCategoryTile(
                              icon: Icons.translate,
                              title: 'Nyelv',
                              filterChildren: [
                                'magyar',
                                'angol',
                                'német',
                                'francia',
                                'héber',
                                'ír',
                                'cigány',
                                'egyéb',
                              ].map((e) {
                                return LFilterChip(
                                    label: e,
                                    onSelected: (_) {},
                                    selected: false);
                              }).toList(),
                            ),
                            LFilterCategoryTile(
                              icon: Icons.speed,
                              title: 'Tempó',
                              filterChildren: [
                                'lassú',
                                'közepes',
                                'gyors',
                                'változó',
                              ].map((e) {
                                return LFilterChip(
                                    label: e,
                                    onSelected: (_) {},
                                    selected: false);
                              }).toList(),
                            ),
                            LFilterCategoryTile(
                                icon: Icons.height,
                                title: 'Hangterjedelem',
                                filterChildren: [
                                  'egy oktáv',
                                  'másfél oktáv',
                                  'két oktáv',
                                ].map((e) {
                                  return LFilterChip(
                                      label: e,
                                      onSelected: (_) {},
                                      selected: false);
                                }).toList()),
                            ListTile(
                              contentPadding: const EdgeInsets.only(left: 15),
                              leading: const Icon(Icons.music_note),
                              title: const Text('Hangnem'),
                              subtitle: Column(
                                children: [
                                  FadingEdgeScrollView
                                      .fromSingleChildScrollView(
                                    child: SingleChildScrollView(
                                      controller: ScrollController(),
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          'C',
                                          'Cisz/Desz',
                                          'D',
                                          'Disz/Esz',
                                          'E',
                                          'F',
                                          'Fisz/Gesz',
                                          'G',
                                          'Gisz/Asz',
                                          'A',
                                          'B',
                                        ].map((e) {
                                          return LFilterChip(
                                              label: e,
                                              onSelected: (_) {},
                                              selected: false);
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  FadingEdgeScrollView
                                      .fromSingleChildScrollView(
                                    child: SingleChildScrollView(
                                      controller: ScrollController(),
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          'dúr',
                                          'moll',
                                          'dór',
                                          'fríg',
                                          'líd',
                                          'mixolíd',
                                          'lokriszi',
                                        ].map((e) {
                                          return LFilterChip(
                                              label: e,
                                              onSelected: (_) {},
                                              selected: false);
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            LFilterCategoryTile(
                              icon: Icons.style,
                              title: 'Stílus / műfaj',
                              filterChildren: [
                                'angolszász',
                                'himnusz',
                                'folk - magyar',
                                'folk - ír',
                                'folk - cigány',
                                'spirituálé/gospel',
                                'meditatív',
                                'gyerekdal',
                                'egyéb',
                              ].map((e) {
                                return LFilterChip(
                                    label: e,
                                    onSelected: (_) {},
                                    selected: false);
                              }).toList(),
                            ),
                            const LFilterCategoryTile(
                                icon: Icons.label,
                                title: 'Tartalomcímkék',
                                filterChildren: [Text('TBD')]),
                            LFilterCategoryTile(
                              icon: Icons.celebration,
                              title: 'Ünnep',
                              filterChildren: [
                                'böjt',
                                'húsvét',
                                'pünkösd',
                                'reformáció',
                                'advent',
                                'karácsony',
                                'egyéb',
                              ].map((e) {
                                return LFilterChip(
                                    label: e,
                                    onSelected: (_) {},
                                    selected: false);
                              }).toList(),
                            ),
                            const LFilterCategoryTile(
                                icon: Icons.calendar_month,
                                title: 'Sófár',
                                filterChildren: [Text('TBD')]),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
                child: ListView.separated(
                    itemBuilder: (BuildContext context, int i) {
                      return LSongTile(allSongs.elementAt(i));
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 0),
                    itemCount: allSongs.length))
          ],
        );
      }),
    );
  }
}

class LFilterCategoryTile extends StatelessWidget {
  const LFilterCategoryTile({
    required this.icon,
    required this.title,
    required this.filterChildren,
    super.key,
  });

  final List<Widget> filterChildren;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 15),
      leading: Icon(icon),
      title: Text(title),
      subtitle: FadingEdgeScrollView.fromSingleChildScrollView(
        child: SingleChildScrollView(
          controller: ScrollController(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filterChildren,
          ),
        ),
      ),
    );
  }
}

class LFilterChip extends StatelessWidget {
  const LFilterChip({
    required this.label,
    required this.onSelected,
    required this.selected,
    super.key,
  });

  final String label;
  final ValueChanged<bool?> onSelected;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: FilterChip.elevated(
        label: Text(label),
        selected: selected,
        onSelected: onSelected,
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }
}

class LCheckboxTile extends StatelessWidget {
  const LCheckboxTile({
    required this.label,
    required this.onTap,
    required this.value,
    super.key,
  });

  final String label;
  final ValueChanged<bool?> onTap;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        leading: Checkbox(value: value, onChanged: onTap),
        title: Text(label),
        onTap: () {},
      ),
    );
  }
}

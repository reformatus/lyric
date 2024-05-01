import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BankPage extends StatefulWidget {
  const BankPage({super.key});

  @override
  State<BankPage> createState() => _BankPageState();
}

class _BankPageState extends State<BankPage> {
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
                                LFilterChip(
                                    label: 'magyar',
                                    onSelected: (_) {},
                                    selected: false),
                                LFilterChip(
                                    label: 'angol',
                                    onSelected: (_) {},
                                    selected: false),
                                LFilterChip(
                                    label: 'német',
                                    onSelected: (_) {},
                                    selected: false),
                                LFilterChip(
                                    label: 'francia',
                                    onSelected: (_) {},
                                    selected: false),
                                LFilterChip(
                                    label: 'héber',
                                    onSelected: (_) {},
                                    selected: false),
                                LFilterChip(
                                    label: 'ír',
                                    onSelected: (_) {},
                                    selected: false),
                                LFilterChip(
                                    label: 'cigány',
                                    onSelected: (_) {},
                                    selected: false),
                                LFilterChip(
                                    label: 'egyéb',
                                    onSelected: (_) {},
                                    selected: false),
                              ],
                            ),
                            LFilterCategoryTile(
                              icon: Icons.speed,
                              title: 'Tempó',
                              filterChildren: [
                                LFilterChip(
                                    label: 'lassú',
                                    onSelected: (_) {},
                                    selected: false),
                                LFilterChip(
                                    label: 'közepes',
                                    onSelected: (_) {},
                                    selected: false),
                                LFilterChip(
                                    label: 'gyors',
                                    onSelected: (_) {},
                                    selected: false),
                                LFilterChip(
                                    label: 'változó',
                                    onSelected: (_) {},
                                    selected: false),
                              ],
                            ),
                            LFilterCategoryTile(
                                icon: Icons.height,
                                title: 'Hangterjedelem',
                                filterChildren: [
                                  LFilterChip(
                                      label: 'egy oktáv',
                                      onSelected: (_) {},
                                      selected: false),
                                  LFilterChip(
                                      label: 'másfél oktáv',
                                      onSelected: (_) {},
                                      selected: false),
                                  LFilterChip(
                                      label: 'két oktáv',
                                      onSelected: (_) {},
                                      selected: false),
                                ]),
                            const LFilterCategoryTile(
                                icon: Icons.music_note,
                                title: 'Hangnem',
                                filterChildren: [Text('TBD')]),
                            LFilterCategoryTile(
                              icon: Icons.style,
                              title: 'Stílus / műfaj',
                              filterChildren: [
                                LFilterChip(
                                    label: 'angolszász',
                                    onSelected: (_) {},
                                    selected: false),
                                LFilterChip(
                                    label: 'himnusz',
                                    onSelected: (_) {},
                                    selected: false),
                                LFilterChip(
                                    label: 'folk - magyar',
                                    onSelected: (_) {},
                                    selected: false),
                                LFilterChip(
                                    label: 'folk - ír',
                                    onSelected: (_) {},
                                    selected: false),
                                LFilterChip(
                                    label: 'folk - cigány',
                                    onSelected: (_) {},
                                    selected: false),
                                LFilterChip(
                                    label: 'spirituálé/gospel',
                                    onSelected: (_) {},
                                    selected: false),
                                LFilterChip(
                                    label: 'meditatív',
                                    onSelected: (_) {},
                                    selected: false),
                                LFilterChip(
                                    label: 'gyerekdal',
                                    onSelected: (_) {},
                                    selected: false),
                                LFilterChip(
                                    label: 'egyéb',
                                    onSelected: (_) {},
                                    selected: false),
                              ],
                            ),
                            const LFilterCategoryTile(
                                icon: Icons.label,
                                title: 'Tartalomcímkék',
                                filterChildren: [Text('TBD')]),
                            LFilterCategoryTile(
                              icon: Icons.celebration,
                              title: 'Ünnep',
                              filterChildren: [
                                LFilterChip(
                                    label: 'böjt',
                                    onSelected: (_) {},
                                    selected: false),
                                LFilterChip(
                                    label: 'húsvét',
                                    onSelected: (_) {},
                                    selected: false),
                                LFilterChip(
                                    label: 'pünkösd',
                                    onSelected: (_) {},
                                    selected: false),
                                LFilterChip(
                                    label: 'reformáció',
                                    onSelected: (_) {},
                                    selected: false),
                                LFilterChip(
                                    label: 'advent',
                                    onSelected: (_) {},
                                    selected: false),
                                LFilterChip(
                                    label: 'karácsony',
                                    onSelected: (_) {},
                                    selected: false),
                                LFilterChip(
                                    label: 'egyéb',
                                    onSelected: (_) {},
                                    selected: false),
                              ],
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
            const Expanded(flex: 2, child: Placeholder())
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

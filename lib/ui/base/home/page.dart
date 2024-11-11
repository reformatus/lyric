import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sófár Lyric'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              'Üdv!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = (constraints.maxWidth ~/ 300).clamp(1, 4);
                    if (crossAxisCount == 3) crossAxisCount = 2;

                    double minItemHeight = 80.0;
                    double itemWidth = constraints.maxWidth / crossAxisCount;
                    double childAspectRatio = itemWidth / minItemHeight;

                    return GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: childAspectRatio,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: [
                        Tooltip(
                          message: 'Hamarosan...',
                          child: HomePageButton(
                            icon: Icons.library_music,
                            title: 'Daltárak',
                            subtitle: 'Hozzáadás, letiltás',
                            onPressed: null, // Disable button
                          ),
                        ),
                        Tooltip(
                          message: 'Hamarosan...',
                          child: HomePageButton(
                            icon: Icons.settings,
                            title: 'Beállítások',
                            subtitle: 'Téma, nyelv, stb.',
                            onPressed: null, // Disable button
                          ),
                        ),
                        Tooltip(
                          message: 'Hamarosan...',
                          child: HomePageButton(
                            icon: Icons.feedback,
                            title: 'Visszajelzés',
                            subtitle: 'Hibajelentés, javaslat',
                            onPressed: null, // Disable button
                          ),
                        ),
                        HomePageButton(
                          icon: Icons.info_outline,
                          title: 'Névjegy',
                          subtitle: 'Verzió, jogi információk',
                          onPressed: () => showLyricAboutDialog(context), // Keep enabled
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showLyricAboutDialog(BuildContext context) async {
    final packageInfo = await PackageInfo.fromPlatform();
    showAboutDialog(
      // ignore: use_build_context_synchronously // this would only cause a problem if packageInto takes a long time to resolve
      context: context,
      applicationName: 'Sófár Lyric',
      applicationVersion: '${packageInfo.version}+${packageInfo.buildNumber}',
      applicationIcon: Icon(Icons.music_note), // todo replace with app icon
      children: [
        Text('Telepítés forrása: ${packageInfo.installerStore ?? 'ismeretlen'}'),
      ],
    );
  }
}

class HomePageButton extends StatelessWidget {
  const HomePageButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onPressed, // Remove 'required'
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onPressed; // Make onPressed nullable

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Hero(
        tag: title,
        child: ElevatedButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.only(),
            ),
          ),
          onPressed: onPressed, // Accept null to disable button
          child: ListTile(
            visualDensity: VisualDensity.comfortable,
            leading: Icon(icon),
            title: Text(title, softWrap: false, overflow: TextOverflow.fade),
            subtitle: Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}

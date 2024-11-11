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
                child: LayoutBuilder(builder: (context, constraints) {
                  return GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: (constraints.maxWidth ~/ 400).clamp(1, 4),
                    childAspectRatio: 6,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      HomePageButton(
                        icon: Icons.library_music,
                        title: 'Daltárak',
                        subtitle: 'Hozzáadás, letiltás',
                        onPressed: () {},
                      ),
                      HomePageButton(
                        icon: Icons.settings,
                        title: 'Beállítások',
                        subtitle: 'Téma, nyelv, stb.',
                        onPressed: () {},
                      ),
                      HomePageButton(
                        icon: Icons.feedback,
                        title: 'Visszajelzés',
                        subtitle: 'Hibajelentés, javaslat',
                        onPressed: () {},
                      ),
                      HomePageButton(
                        icon: Icons.info_outline,
                        title: 'Névjegy',
                        subtitle: 'Verzió, jogi információk',
                        onPressed: () => showLyricAboutDialog(context),
                      ),
                    ],
                  );
                }),
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
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

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
          onPressed: onPressed,
          child: ListTile(
            visualDensity: VisualDensity.comfortable,
            leading: Icon(icon),
            title: Text(title),
            subtitle: Text(subtitle),
          ),
        ),
      ),
    );
  }
}

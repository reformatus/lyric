import 'package:flutter/material.dart';

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
          Text(
            'Üdv!',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: LayoutBuilder(builder: (context, constraints) {
                return GridView.count(
                  crossAxisCount: constraints.maxWidth ~/ 400,
                  childAspectRatio: 6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    HomePageButton(
                      icon: Icons.settings,
                      title: 'Beálltások',
                      subtitle: 'Téma, nyelv, stb.',
                      onPressed: () {},
                    ),
                    HomePageButton(
                      icon: Icons.info_outline,
                      title: 'Névjegy',
                      subtitle: 'Verzió, jogi információk',
                      onPressed: () {},
                    ),
                    HomePageButton(
                      icon: Icons.settings,
                      title: 'Beálltások',
                      subtitle: 'Téma, nyelv, stb.',
                      onPressed: () {},
                    ),
                    HomePageButton(
                      icon: Icons.info_outline,
                      title: 'Névjegy',
                      subtitle: 'Verzió, jogi információk',
                      onPressed: () {},
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
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
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }
}

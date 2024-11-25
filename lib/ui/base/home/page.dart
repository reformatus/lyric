import 'package:flutter/material.dart';

import 'button.dart';
import 'parts/about.dart';
import 'parts/feedback/send_mail.dart';
import 'parts/new_version_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sófár DalApp Béta'),
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
          NewVersionWidget(),
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
                          message: 'E-mail küldése',
                          child: HomePageButton(
                            icon: Icons.feedback,
                            title: 'Visszajelzés',
                            subtitle: 'Hibajelentés, javaslat küldése',
                            onPressed: launchFeedbackEmail,
                          ),
                        ),
                        HomePageButton(
                          icon: Icons.info_outline,
                          title: 'Névjegy',
                          subtitle: 'Verzió, licencek',
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
}

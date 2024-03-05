import "package:fluent_ui/fluent_ui.dart";

void main() {
  runApp(const LyricApp());
}

class LyricApp extends StatelessWidget {
  const LyricApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      builder: (context, child) => const Placeholder(),
    );
  }
}

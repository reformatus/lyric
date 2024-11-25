import 'package:flutter/material.dart';

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
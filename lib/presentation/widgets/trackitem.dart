import 'package:flutter/material.dart';

/// Representa element de la llist ade pistes
class TrackItem extends StatelessWidget {
  const TrackItem({
    super.key,
    required this.title,
    required this.author,
    required this.duration,
    required this.onSelect,
  });

  final String title;
  final String author;
  final String duration;
  //final Function onSelect; // S'explica el canvi en: https://stackoverflow.com/questions/64484113/the-argument-type-function-cant-be-assigned-to-the-parameter-type-void-funct
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: ListTile(
        title: Text(title),
        subtitle: Text(author),
        trailing: Text(duration),
      ),
    );
  }
}

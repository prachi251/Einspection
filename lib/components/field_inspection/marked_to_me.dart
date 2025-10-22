import 'package:flutter/material.dart';

class MarkedToMeField extends StatelessWidget {
  final int statusIndex;

  const MarkedToMeField({super.key, required this.statusIndex});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Field → Marked to Me → Status: $statusIndex'),
    );
  }
}

import 'package:flutter/material.dart';

class ForwardedToMeGeneral extends StatelessWidget {
  final int statusIndex;

  const ForwardedToMeGeneral({super.key, required this.statusIndex});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('General → Forwarded to Me → Status: $statusIndex'),
    );
  }
}

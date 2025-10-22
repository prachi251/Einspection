import 'package:flutter/material.dart';

class ForwardedToMeField extends StatelessWidget {
  final int statusIndex;

  const ForwardedToMeField({super.key, required this.statusIndex});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Field → Forwarded to Me → Status: $statusIndex'),
    );
  }
}

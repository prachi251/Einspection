import 'package:flutter/material.dart';

class IssuedByMeField extends StatelessWidget {
  final int statusIndex;

  const IssuedByMeField({super.key, required this.statusIndex});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Field → Issued by Me → Status: $statusIndex'),
    );
  }
}

import 'package:flutter/material.dart';

class MarkedToMeMOM extends StatelessWidget {
  final int statusIndex;

  const MarkedToMeMOM({super.key, required this.statusIndex});

  @override
  Widget build(BuildContext context) {
    // You can use statusIndex here to conditionally show content
    return Center(child: Text('Marked to Me - Status $statusIndex'));
  }
}
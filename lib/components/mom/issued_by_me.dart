import 'package:flutter/material.dart';

class IssuedByMeMOM extends StatelessWidget {
  final int statusIndex;

  const IssuedByMeMOM({super.key, required this.statusIndex});

  @override
  Widget build(BuildContext context) {
    // You can use statusIndex here to conditionally show content
    return Center(child: Text('Issued by Me - Status $statusIndex'));
  }
}

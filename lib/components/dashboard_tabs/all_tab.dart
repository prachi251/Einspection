// Entry: lib/components/dashboard_tabs/all_tab.dart
import 'package:flutter/material.dart';

class AllTab extends StatelessWidget {
  const AllTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'All Dashboard Items',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

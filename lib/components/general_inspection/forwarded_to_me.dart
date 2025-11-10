import 'package:flutter/material.dart';

class ForwardedToMeGeneral extends StatelessWidget {
  final int statusIndex;
  final String searchQuery;
  final Map<String, dynamic> appliedFilters;

  // const ForwardedToMeGeneral({super.key, required this.statusIndex,this.appliedFilters = const {},});
const ForwardedToMeGeneral({
    Key? key,
    required this.statusIndex,
     this.searchQuery = '',
    this.appliedFilters = const {},
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('General → Forwarded to Me → Status: $statusIndex'),
    );
  }
}

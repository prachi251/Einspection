// import 'package:flutter/material.dart';

// class MarkedToMeField extends StatelessWidget {
//   final int statusIndex;
//   final String searchQuery;
//   final Map<String, dynamic> appliedFilters;

//   const MarkedToMeField({
//     Key? key,
//     required this.statusIndex,
//      this.searchQuery = '',
//     this.appliedFilters = const {},
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Field → Marked to Me → Status: $statusIndex'),
//     );
//   }
// }



import 'package:flutter/material.dart';

class MarkedToMeField extends StatelessWidget {
  final int statusIndex;
  final ScrollController? scrollController;

  const MarkedToMeField({
    Key? key,
    required this.statusIndex,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: EdgeInsets.all(16),
      children: [
        SizedBox(height: 100),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                'Field Inspection - Marked to Me',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Status Filter: ${_getStatusLabel(statusIndex)}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 500), // For scroll functionality
      ],
    );
  }

  String _getStatusLabel(int index) {
    const labels = ['Draft', 'Pending', 'Partly Completed', 'Complied', 'Rejected'];
    return index < labels.length ? labels[index] : 'Unknown';
  }
}







// lib/components/common/compliance_widget.dart
import 'package:flutter/material.dart';

// MOM-specific
import '../mom/marked_to_me.dart';
import '../mom/issued_by_me.dart';

// Field-specific (namespaced)
import '../field_inspection/marked_to_me.dart' as field;
import '../field_inspection/issued_by_me.dart' as field;
import '../field_inspection/forwarded_to_me.dart' as field;

// General-specific (namespaced)
import '../general_inspection/marked_to_me.dart' as general;
import '../general_inspection/issued_by_me.dart' as general;
import '../general_inspection/forwarded_to_me.dart' as general;

class ComplianceWidget extends StatelessWidget {
  final String section; // MOM / Field / General
  final int selectedView; // 0 = Marked, 1 = Issued, 2 = Forwarded
  final int selectedCompliance; // Index for status icons
  final Function(int) onComplianceSelected;

  const ComplianceWidget({
    super.key,
    required this.section,
    required this.selectedView,
    required this.selectedCompliance,
    required this.onComplianceSelected,
  });

  static const List<IconData> statusIcons = [
    Icons.edit_note,         // Draft
    Icons.hourglass_empty,   // Pending
    Icons.work_history,      // Partly Completed
    Icons.check_circle,      // Complied
    Icons.cancel,            // Rejected
  ];

  static const List<String> statusLabels = [
    'Draft',
    'Pending',
    'Partly Completed',
    'Complied', 
    'Rejected'
  ];

  static const List<Color> statusColors = [
    Colors.grey,      // Draft
    Colors.orange,    // Pending
    Colors.amber,     // Partly Completed
    Colors.green,     // Complied
    Colors.red,       // Rejected
  ];

  @override
  Widget build(BuildContext context) {
    print('ComplianceWidget building: section=$section, selectedView=$selectedView, selectedCompliance=$selectedCompliance');
    
    // Status bar with compliance icons
    Widget statusBar = Container(
      height: 80,
      width: double.infinity,
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: statusIcons.asMap().entries.map((entry) {
          int index = entry.key;
          IconData icon = entry.value;
          bool isSelected = selectedCompliance == index;
          Color iconColor = statusColors[index];
          
          return Expanded(
            child: GestureDetector(
              onTap: () {
                print('Status icon $index (${statusLabels[index]}) tapped');
                onComplianceSelected(index);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: isSelected ? iconColor.withOpacity(0.15) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: isSelected ? Border.all(color: iconColor, width: 2) : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: isSelected ? iconColor : Colors.grey[600],
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      statusLabels[index],
                      style: TextStyle(
                        fontSize: 9,
                        color: isSelected ? iconColor : Colors.grey[600],
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );

    // Main widget rendering based on section and selected view
    Widget child;

    try {
      switch (section) {
        case 'MOM':
          if (selectedView == 0) {
            child = MarkedToMeMOM(statusIndex: selectedCompliance);
          } else {
            child = IssuedByMeMOM(statusIndex: selectedCompliance);
          }
          break;

        case 'Field':
          if (selectedView == 0) {
            child = field.MarkedToMeField(statusIndex: selectedCompliance);
          } else if (selectedView == 1) {
            child = field.IssuedByMeField(statusIndex: selectedCompliance);
          } else {
            child = field.ForwardedToMeField(statusIndex: selectedCompliance);
          }
          break;

        case 'General':
          if (selectedView == 0) {
            child = general.MarkedToMeGeneral(statusIndex: selectedCompliance);
          } else if (selectedView == 1) {
            child = general.IssuedByMeGeneral(statusIndex: selectedCompliance);
          } else {
            child = general.ForwardedToMeGeneral(statusIndex: selectedCompliance);
          }
          break;

        default:
          child = Container(
            color: Colors.red[100],
            child: Center(
              child: Text('Unknown section: $section'),
            ),
          );
      }
    } catch (e) {
      print('Error creating child widget: $e');
      child = Container(
        color: Colors.red[100],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('Error loading content: $e'),
              const SizedBox(height: 8),
              Text('Section: $section, View: $selectedView'),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        statusBar,
        Expanded(
          child: Container(
            width: double.infinity,
            child: child,
          ),
        ),
      ],
    );
  }
}

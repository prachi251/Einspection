// lib/components/dashboard_tabs/field_inspection_tab.dart
import 'package:flutter/material.dart';
import '../common/compliance_widget.dart';
import '../field_inspection/marked_to_me.dart';
import '../field_inspection/issued_by_me.dart';
import '../field_inspection/forwarded_to_me.dart';

class FieldInspectionTab extends StatefulWidget {
  const FieldInspectionTab({super.key});

  @override
  State<FieldInspectionTab> createState() => _FieldInspectionTabState();
}

class _FieldInspectionTabState extends State<FieldInspectionTab> {
  int selectedView = 0; // 0 = Marked, 1 = Issued, 2 = Forwarded
  int selectedCompliance = 0;

  Widget getSelectedWidget() {
    switch (selectedView) {
      case 0:
        return MarkedToMeField(statusIndex: selectedCompliance);
      case 1:
        return IssuedByMeField(statusIndex: selectedCompliance);
      case 2:
        return ForwardedToMeField(statusIndex: selectedCompliance);
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Action Selection Row with Icons
        Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.inbox,
                label: 'Marked to me',
                isSelected: selectedView == 0,
                onTap: () => setState(() => selectedView = 0),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[300],
              ),
              _buildActionButton(
                icon: Icons.send,
                label: 'Issued by me',
                isSelected: selectedView == 1,
                onTap: () => setState(() => selectedView = 1),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[300],
              ),
              _buildActionButton(
                icon: Icons.forward,
                label: 'Forwarded to me',
                isSelected: selectedView == 2,
                onTap: () => setState(() => selectedView = 2),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 8),

        // Compliance Widget with Status Icons
        Expanded(
          child: ComplianceWidget(
            section: 'Field',
            selectedView: selectedView,
            selectedCompliance: selectedCompliance,
            onComplianceSelected: (index) {
              setState(() => selectedCompliance = index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[800] : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.blue[800],
                size: 20,
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.blue[800],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// lib/components/dashboard_tabs/mom_tab.dart
import 'package:flutter/material.dart';
import '../common/compliance_widget.dart';
import '../mom/marked_to_me.dart';
import '../mom/issued_by_me.dart';

class MOMTab extends StatefulWidget {
  const MOMTab({super.key});

  @override
  State<MOMTab> createState() => _MOMTabState();
}

class _MOMTabState extends State<MOMTab> {
  int selectedView = 0; // 0 = MarkedToMe, 1 = IssuedByMe
  int selectedCompliance = 0;

  Widget getSelectedWidget() {
    if (selectedView == 0) {
      return MarkedToMeMOM(statusIndex: selectedCompliance);
    } else {
      return IssuedByMeMOM(statusIndex: selectedCompliance);
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
            ],
          ),
        ),
        
        SizedBox(height: 8),

        // Compliance Widget with Status Icons
        Expanded(
          child: ComplianceWidget(
            section: 'MOM',
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.blue[800],
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.blue[800],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
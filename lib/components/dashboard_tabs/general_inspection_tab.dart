import 'package:flutter/material.dart';
import '../common/compliance_widget.dart';
import '../general_inspection/marked_to_me.dart';
import '../general_inspection/issued_by_me.dart';
import '../general_inspection/forwarded_to_me.dart';

class GeneralInspectionTab extends StatefulWidget {
  final Function(int)? onSubTabChanged;
  final int? markedToMeCount;
  final int? issuedByMeCount;
  final int? forwardedToMeCount;
  
  const GeneralInspectionTab({
    Key? key, 
    this.onSubTabChanged,
    this.markedToMeCount,
    this.issuedByMeCount,
    this.forwardedToMeCount,
  }) : super(key: key);
  
  @override
  State<GeneralInspectionTab> createState() => _GeneralInspectionTabState();
}

class _GeneralInspectionTabState extends State<GeneralInspectionTab> {
  int selectedView = 0; // 0 = Marked to me, 1 = Issued by me, 2 = Forwarded to me
  int selectedCompliance = 0;

  @override
  void initState() {
    super.initState();
    // Notify dashboard about initial selection (Marked to me = 0)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSubTabChanged?.call(0);
    });
  }

  void _selectView(int index) {
    setState(() {
      selectedView = index;
    });
    
    // Notify the dashboard about the sub-tab change
    widget.onSubTabChanged?.call(index);
    
    print('General inspection view changed to: $index');
  }

  Widget getSelectedWidget() {
    switch (selectedView) {
      case 0:
        return MarkedToMeGeneral(statusIndex: selectedCompliance);
      case 1:
        return IssuedByMeGeneral(statusIndex: selectedCompliance);
      case 2:
        return ForwardedToMeGeneral(statusIndex: selectedCompliance);
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
                count: widget.markedToMeCount,
                isSelected: selectedView == 0,
                onTap: () => _selectView(0),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[300],
              ),
              _buildActionButton(
                icon: Icons.send,
                label: 'Issued by me',
                count: widget.issuedByMeCount,
                isSelected: selectedView == 1,
                onTap: () => _selectView(1),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[300],
              ),
              _buildActionButton(
                icon: Icons.forward,
                label: 'Forwarded to me',
                count: widget.forwardedToMeCount,
                isSelected: selectedView == 2,
                onTap: () => _selectView(2),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 8),

        // Compliance Widget with Status Icons
        Expanded(
          child: ComplianceWidget(
            section: 'General',
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
    required int? count,
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
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    icon,
                    color: isSelected ? Colors.white : Colors.blue[800],
                    size: 20,
                  ),
                  // Count badge - only show if count is provided and > 0
                  if (count != null && count > 0)
                    Positioned(
                      right: -8,
                      top: -8,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          count.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
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
// lib/components/dashboard_tabs/filter_button.dart
import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterButton({Key? key, required this.onFiltersApplied}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _showFilterDialog(context),
      icon: Icon(Icons.filter_list),
      tooltip: 'Filters',
      style: IconButton.styleFrom(
        backgroundColor: Colors.blue[100],
        foregroundColor: Colors.blue[800],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterDialog(onFiltersApplied: onFiltersApplied);
      },
    );
  }
}

class FilterDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterDialog({Key? key, required this.onFiltersApplied}) : super(key: key);

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  DateTimeRange? _selectedDateRange;
  String? _selectedMeetingType;
  String? _selectedInspectionType;
  String? _selectedZone;
  String? _selectedDivision;
  String? _selectedLocation;

  final List<String> _meetingTypes = [
    'Safety Meeting',
    'Review Meeting', 
    'Progress Meeting',
    'Emergency Meeting',
    'Maintenance Meeting'
  ];
  
  final List<String> _inspectionTypes = [
    'Track Inspection',
    'Signal Inspection', 
    'Bridge Inspection',
    'Station Inspection',
    'Rolling Stock Inspection'
  ];
  
  final List<String> _zones = [
    'Northern Railway',
    'Southern Railway', 
    'Eastern Railway',
    'Western Railway',
    'Central Railway',
    'North Eastern Railway'
  ];
  
  final List<String> _divisions = [
    'Delhi Division',
    'Mumbai Division',
    'Chennai Division', 
    'Kolkata Division',
    'Nagpur Division',
    'Pune Division'
  ];
  
  final List<String> _locations = [
    'New Delhi',
    'Mumbai Central',
    'Chennai Central',
    'Howrah',
    'Nagpur Junction',
    'Pune Junction'
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.filter_list, color: Colors.blue[800]),
          SizedBox(width: 8),
          Text('Filter Options'),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Range Filter
              _buildDateRangeSection(),
              SizedBox(height: 16),
              
              // Type of Meeting Filter
              _buildDropdownSection(
                'Type of Meeting',
                Icons.meeting_room,
                _selectedMeetingType,
                _meetingTypes,
                (value) => setState(() => _selectedMeetingType = value),
              ),
              SizedBox(height: 16),
              
              // Type of Field Inspection Filter
              _buildDropdownSection(
                'Type of Field Inspection',
                Icons.search,
                _selectedInspectionType,
                _inspectionTypes,
                (value) => setState(() => _selectedInspectionType = value),
              ),
              SizedBox(height: 16),
              
              // Zone Filter
              _buildDropdownSection(
                'Zone',
                Icons.location_on,
                _selectedZone,
                _zones,
                (value) => setState(() => _selectedZone = value),
              ),
              SizedBox(height: 16),
              
              // Division Filter
              _buildDropdownSection(
                'Division',
                Icons.corporate_fare,
                _selectedDivision,
                _divisions,
                (value) => setState(() => _selectedDivision = value),
              ),
              SizedBox(height: 16),
              
              // Location Filter
              _buildDropdownSection(
                'Location',
                Icons.place,
                _selectedLocation,
                _locations,
                (value) => setState(() => _selectedLocation = value),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _clearAllFilters,
          child: Text('Clear All'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _applyFilters,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[800],
          ),
          child: Text('Apply Filters'),
        ),
      ],
    );
  }

  Widget _buildDateRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.date_range, color: Colors.blue[800]),
            SizedBox(width: 8),
            Text(
              'Date Range',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _selectDateRange,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[100],
              foregroundColor: Colors.black87,
              elevation: 0,
            ),
            child: Text(
              _selectedDateRange != null 
                ? '${_selectedDateRange!.start.toString().split(' ')[0]} - ${_selectedDateRange!.end.toString().split(' ')[0]}'
                : 'Select Date Range',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownSection(
    String title,
    IconData icon,
    String? selectedValue,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blue[800]),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedValue,
          hint: Text('Select $title'),
          isExpanded: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Future<void> _selectDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(Duration(days: 365)),
      initialDateRange: _selectedDateRange,
    );
    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  void _clearAllFilters() {
    setState(() {
      _selectedDateRange = null;
      _selectedMeetingType = null;
      _selectedInspectionType = null;
      _selectedZone = null;
      _selectedDivision = null;
      _selectedLocation = null;
    });
  }

  void _applyFilters() {
    Map<String, dynamic> filters = {
      'dateRange': _selectedDateRange,
      'meetingType': _selectedMeetingType,
      'inspectionType': _selectedInspectionType,
      'zone': _selectedZone,
      'division': _selectedDivision,
      'location': _selectedLocation,
    };

    // Call the callback function
    widget.onFiltersApplied(filters);
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Filters applied successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    
    // Close dialog
    Navigator.of(context).pop();
    
    // Debug print
    print('Filters Applied:');
    print('Date Range: $_selectedDateRange');
    print('Meeting Type: $_selectedMeetingType');
    print('Inspection Type: $_selectedInspectionType');
    print('Zone: $_selectedZone');
    print('Division: $_selectedDivision');
    print('Location: $_selectedLocation');
  }
}

import 'package:flutter/material.dart';

class compliance_screen extends StatefulWidget {
  const compliance_screen({super.key});

  @override
  State<compliance_screen> createState() => _CompliancesScreenState();
}

class _CompliancesScreenState extends State<compliance_screen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTab = 'All';
  bool _showFilter = false;
  DateTimeRange? _selectedDateRange;
  String? _selectedRailway;
  String? _selectedDivision;
  String? _selectedOfficer;

  // Sample compliance data
  final List<Map<String, dynamic>> _complianceData = [
    {
      'id': '1',
      'title': 'Safety Protocol Compliance',
      'description': 'Implementation of new safety protocols in Zone A',
      'status': 'Pending',
      'officer': 'John Doe',
      'division': 'Safety Division',
      'railway': 'Northern Railway',
      'dateIssued': '2024-01-15',
      'dueDate': '2024-02-15',
      'priority': 'High',
    },
    {
      'id': '2',
      'title': 'Equipment Maintenance Compliance',
      'description': 'Regular maintenance check compliance for Track Section 12',
      'status': 'Complied',
      'officer': 'Sarah Wilson',
      'division': 'Engineering Division',
      'railway': 'Northern Railway',
      'dateIssued': '2024-01-10',
      'dueDate': '2024-01-25',
      'priority': 'Medium',
    },
    {
      'id': '3',
      'title': 'Documentation Compliance',
      'description': 'Proper documentation of inspection reports',
      'status': 'Rejected',
      'officer': 'Mike Johnson',
      'division': 'Operations Division',
      'railway': 'Central Railway',
      'dateIssued': '2024-01-20',
      'dueDate': '2024-02-05',
      'priority': 'Low',
    },
    {
      'id': '4',
      'title': 'Training Compliance',
      'description': 'Staff training compliance for new procedures',
      'status': 'Reverted',
      'officer': 'Lisa Anderson',
      'division': 'HR Division',
      'railway': 'Southern Railway',
      'dateIssued': '2024-01-08',
      'dueDate': '2024-01-30',
      'priority': 'High',
    },
    {
      'id': '5',
      'title': 'Environmental Compliance',
      'description': 'Environmental impact assessment compliance',
      'status': 'Forwarded by Me',
      'officer': 'David Brown',
      'division': 'Environmental Division',
      'railway': 'Eastern Railway',
      'dateIssued': '2024-01-12',
      'dueDate': '2024-02-10',
      'priority': 'Medium',
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  List<Map<String, dynamic>> _getFilteredData() {
    List<Map<String, dynamic>> baseData;

    switch (_selectedTab) {
      case 'Pending':
        baseData = _complianceData.where((item) => item['status'] == 'Pending').toList();
        break;
      case 'Complied':
        baseData = _complianceData.where((item) => item['status'] == 'Complied').toList();
        break;
      case 'Rejected':
        baseData = _complianceData.where((item) => item['status'] == 'Rejected').toList();
        break;
      case 'Reverted':
        baseData = _complianceData.where((item) => item['status'] == 'Reverted').toList();
        break;
      case 'Forwarded by Me':
        baseData = _complianceData.where((item) => item['status'] == 'Forwarded by Me').toList();
        break;
      default:
        baseData = List.from(_complianceData);
    }

    // Apply railway filter
    if (_selectedRailway != null) {
      baseData = baseData.where((item) => item['railway'] == _selectedRailway).toList();
    }

    // Apply division filter
    if (_selectedDivision != null) {
      baseData = baseData.where((item) => item['division'] == _selectedDivision).toList();
    }

    // Apply officer filter
    if (_selectedOfficer != null) {
      baseData = baseData.where((item) => item['officer'] == _selectedOfficer).toList();
    }

    // Apply date range filter
    if (_selectedDateRange != null) {
      baseData = baseData.where((item) {
        try {
          DateTime itemDate = DateTime.parse(item['dateIssued']);
          return itemDate.isAfter(_selectedDateRange!.start.subtract(const Duration(days: 1))) &&
                 itemDate.isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
        } catch (e) {
          return false;
        }
      }).toList();
    }

    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) return baseData;

    return baseData.where((item) {
      return item.values.any((value) =>
          value.toString().toLowerCase().contains(query));
    }).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Complied':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Rejected':
        return Colors.red;
      case 'Reverted':
        return Colors.purple;
      case 'Forwarded by Me':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _handleAction(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action clicked'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _selectedRailway = null;
      _selectedDivision = null;
      _selectedOfficer = null;
      _selectedDateRange = null;
    });
  }

  void _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(2030, 12, 31),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            primaryColor: const Color(0xFF1A237E),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1A237E),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
      _handleAction('Date Range Selected: ${picked.start.toString().split(' ')[0]} to ${picked.end.toString().split(' ')[0]}');
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filter Options'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Filter by:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    _buildFilterSection('Railway/Organization', [
                      'Northern Railway',
                      'Southern Railway',
                      'Eastern Railway',
                      'Western Railway',
                      'Central Railway',
                    ], _selectedRailway, (value) {
                      setDialogState(() {
                        _selectedRailway = _selectedRailway == value ? null : value;
                      });
                    }),
                    const SizedBox(height: 16),
                    _buildFilterSection('Division/Unit', [
                      'Safety Division',
                      'Engineering Division',
                      'Operations Division',
                      'HR Division',
                      'Environmental Division',
                    ], _selectedDivision, (value) {
                      setDialogState(() {
                        _selectedDivision = _selectedDivision == value ? null : value;
                      });
                    }),
                    const SizedBox(height: 16),
                    _buildFilterSection('Inspection Officer', [
                      'John Doe',
                      'Sarah Wilson',
                      'Mike Johnson',
                      'Lisa Anderson',
                      'David Brown',
                    ], _selectedOfficer, (value) {
                      setDialogState(() {
                        _selectedOfficer = _selectedOfficer == value ? null : value;
                      });
                    }),
                    const SizedBox(height: 16),
                    _buildDateRangeSection(),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _clearAllFilters();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Clear All'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.of(context).pop();
                    _handleAction('Filter Applied');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Apply Filter'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDateRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date Range',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _showDateRangePicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Color(0xFF1A237E),
                ),
                const SizedBox(width: 8),
                Text(
                  _selectedDateRange == null
                      ? 'Select Date Range'
                      : '${_selectedDateRange!.start.toString().split(' ')[0]} to ${_selectedDateRange!.end.toString().split(' ')[0]}',
                  style: const TextStyle(
                    color: Color(0xFF1A237E),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection(String title, List<String> options, String? selectedValue, Function(String) onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: options.map((option) {
            bool isSelected = selectedValue == option;
            return GestureDetector(
              onTap: () => onTap(option),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1A237E) : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF1A237E) : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF1A237E),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Compliances',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1A237E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildTabBar(),
          Expanded(child: _buildComplianceList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search compliances...',
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 50,
      color: Colors.white,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildTabItem('All'),
          _buildTabItem('Pending'),
          _buildTabItem('Complied'),
          _buildTabItem('Rejected'),
          _buildTabItem('Reverted'),
          _buildTabItem('Forwarded by Me'),
          _buildFilterButton(),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title) {
    bool isSelected = _selectedTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A237E) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF1A237E),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    bool hasActiveFilters = _selectedRailway != null || 
                           _selectedDivision != null || 
                           _selectedOfficer != null || 
                           _selectedDateRange != null;
    
    return GestureDetector(
      onTap: _showFilterDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: hasActiveFilters ? const Color(0xFF1A237E) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF1A237E), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_list, 
              color: hasActiveFilters ? Colors.white : const Color(0xFF1A237E), 
              size: 16
            ),
            const SizedBox(width: 4),
            Text(
              'Filter',
              style: TextStyle(
                color: hasActiveFilters ? Colors.white : const Color(0xFF1A237E),
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplianceList() {
    List<Map<String, dynamic>> filteredData = _getFilteredData();

    if (filteredData.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No compliances found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        final item = filteredData[index];
        return _buildComplianceItem(item);
      },
    );
  }

  Widget _buildComplianceItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(item['priority']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item['priority'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _getPriorityColor(item['priority']),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item['description'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.person,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  item['officer'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.business,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    item['division'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.train,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  item['railway'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(item['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    item['status'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _getStatusColor(item['status']),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 4),
                Text(
                  'Issued: ${item['dateIssued']}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.schedule,
                  size: 14,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 4),
                Text(
                  'Due: ${item['dueDate']}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
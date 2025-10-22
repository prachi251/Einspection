import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class IssuedByMeGeneral extends StatefulWidget {
  final int statusIndex;

  const IssuedByMeGeneral({Key? key, required this.statusIndex}) : super(key: key);

  @override
  _IssuedByMeGeneralState createState() => _IssuedByMeGeneralState();
}

class _IssuedByMeGeneralState extends State<IssuedByMeGeneral> {
  // Data variables
  List<dynamic> allInspectionData = []; // Store all data
  List<dynamic> filteredInspectionData = []; // Store filtered data
  bool isLoading = true;
  int? userId; // Dynamic user ID - will be set in initState
  String searchQuery = '';
  TextEditingController searchController = TextEditingController();

  // Status mapping based on the updated compliance widget
  static const List<String> statusLabels = [
    'draft',           // Index 0
    'pending',         // Index 1
    'partly_complied', // Index 2
    'complied',        // Index 3
    'rejected'         // Index 4
  ];

  @override
  @override
@override
void initState() {
  super.initState();
  _loadUserIdAndFetch();
}

Future<void> _loadUserIdAndFetch() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    userId = prefs.getInt('user_id');
  });
  
  print('📋 IssuedByMe - Retrieved user_id: $userId');
  
  if (userId != null) {
    fetchGeneralInspectionIssuedByMe();
  } else {
    showSnackBar('User ID not found. Please login again.');
    setState(() {
      isLoading = false;
    });
  }
}


  Future<void> fetchGeneralInspectionIssuedByMe() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/field-inspections/?user_id=$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success']) {
          setState(() {
            allInspectionData = responseData['data']['inspections'];
            _filterDataByStatus(); // Filter based on current status index
          });
        } else {
          showSnackBar('Error: ${responseData['message']}');
        }
      } else {
        showSnackBar('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      showSnackBar('Network error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterDataByStatus() {
    if (allInspectionData.isEmpty) {
      setState(() {
        filteredInspectionData = [];
      });
      return;
    }

    // If statusIndex is -1 or not set, show all data (when "Issued By Me" is clicked)
    if (widget.statusIndex < 0 || widget.statusIndex >= statusLabels.length) {
      setState(() {
        filteredInspectionData = allInspectionData;
      });
      return;
    }

    String targetStatus = statusLabels[widget.statusIndex];

    setState(() {
      filteredInspectionData = allInspectionData.where((inspection) {
        final statusCategory = inspection['status_category']?.toLowerCase() ??
            inspection['status']?.toLowerCase() ??
            '';
        return statusCategory == targetStatus;
      }).toList();
    });

    print('Filtered data for status: $targetStatus, Count: ${filteredInspectionData.length}');
  }

  List<dynamic> getSearchFilteredData() {
    if (searchQuery.isEmpty) {
      return filteredInspectionData;
    }

    return filteredInspectionData.where((inspection) {
      final title = inspection['inspection_title']?.toLowerCase() ?? '';
      final noteNo = inspection['inspection_note_no']?.toLowerCase() ?? '';
      final officerName = inspection['officer_name']?.toLowerCase() ?? '';
      final stationName = inspection['station_name']?.toLowerCase() ?? '';
      final query = searchQuery.toLowerCase();

      return title.contains(query) ||
          noteNo.contains(query) ||
          officerName.contains(query) ||
          stationName.contains(query);
    }).toList();
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _getStatusDisplayName(int statusIndex) {
    if (statusIndex < 0 || statusIndex >= statusLabels.length) {
      return 'All'; // Show "All" when no specific status is selected
    }

    const displayNames = [
      'Draft',
      'Pending',
      'Partly Completed',
      'Complied',
      'Rejected'
    ];
    return displayNames[statusIndex];
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'draft':
        return Colors.grey[600]!;
      case 'pending':
        return Colors.orange[600]!;
      case 'partly_complied':
        return Colors.amber[600]!;
      case 'complied':
        return Colors.green[600]!;
      case 'rejected':
        return Colors.red[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  Widget _buildInspectionCard(dynamic inspection) {
    final startDate = inspection['start_date'] ?? '';
    final formattedDate =
        startDate.isNotEmpty ? DateTime.parse(startDate).toString().split(' ')[0] : 'N/A';

    final statusCategory = inspection['status_category'] ?? inspection['status'] ?? 'unknown';
    final statusFlag = inspection['status_flag'] ?? 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with inspection number and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Inspection #${inspection['inspection_no']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
                // Status indicator with fixed height (prevents 1px jiggle)
                Container(
                  height: 28,
                  constraints: const BoxConstraints(minWidth: 80),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _getStatusColor(statusCategory),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusCategory.toUpperCase().replaceAll('_', ' '),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Inspection Note Number and Status Flag
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (inspection['inspection_note_no'] != null &&
                    inspection['inspection_note_no'].isNotEmpty)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Text(
                        'Note: ${inspection['inspection_note_no']}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.indigo[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.indigo[200]!),
                  ),
                  child: Text(
                    'Flag: $statusFlag',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.indigo[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Title
            Text(
              inspection['inspection_title'] ?? 'No title available',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 16),

            // Date Information
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Start Date: $formattedDate',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const Spacer(),
                if (inspection['target_date'] != null && inspection['target_date'].isNotEmpty)
                  Row(
                    children: [
                      Icon(Icons.flag, size: 16, color: Colors.orange[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Target: ${DateTime.parse(inspection['target_date']).toString().split(' ')[0]}',
                        style: TextStyle(fontSize: 14, color: Colors.orange[700]),
                      ),
                    ],
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Officer Information
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Officer: ${inspection['officer_name'] ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (inspection['station_name'] != null &&
                      inspection['station_name'].isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Station: ${inspection['station_name']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Type indicators (if available)
            if (inspection['item_type_readable'] != null ||
                inspection['insp_type_readable'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    if (inspection['item_type_readable'] != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.green[200]!),
                        ),
                        child: Text(
                          inspection['item_type_readable'].toString().toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (inspection['item_type_readable'] != null &&
                        inspection['insp_type_readable'] != null)
                      const SizedBox(width: 8),
                    if (inspection['insp_type_readable'] != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.purple[50],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.purple[200]!),
                        ),
                        child: Text(
                          inspection['insp_type_readable'].toString().toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.purple[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchFilteredData = getSearchFilteredData();
    final currentStatusName = _getStatusDisplayName(widget.statusIndex);

    return Column(
      children: [
        // Header Section - Compact without search
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Status Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.statusIndex >= 0 && widget.statusIndex < statusLabels.length
                      ? _getStatusColor(statusLabels[widget.statusIndex]).withOpacity(0.1)
                      : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  widget.statusIndex >= 0 && widget.statusIndex < statusLabels.length
                      ? _getStatusIcon(widget.statusIndex)
                      : Icons.list_alt,
                  color: widget.statusIndex >= 0 && widget.statusIndex < statusLabels.length
                      ? _getStatusColor(statusLabels[widget.statusIndex])
                      : Colors.blue[700],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // Status Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$currentStatusName Inspections',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${searchFilteredData.length} ${currentStatusName == 'All' ? 'total' : 'of ${allInspectionData.length} total'} inspections',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Body
        Expanded(
          child: RefreshIndicator(
            onRefresh: fetchGeneralInspectionIssuedByMe,
            // Use a scrollable even when empty to avoid RenderFlex overflow and support pull-to-refresh
            child: searchFilteredData.isEmpty
                ? CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.inbox_outlined, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text(
                                'No $currentStatusName inspections available',
                                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: fetchGeneralInspectionIssuedByMe,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Refresh'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[700],
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: searchFilteredData.length,
                    itemBuilder: (context, index) {
                      final inspection = searchFilteredData[index];
                      return _buildInspectionCard(inspection);
                    },
                  ),
          ),
        ),
      ],
    );
  }

  IconData _getStatusIcon(int statusIndex) {
    const statusIcons = [
      Icons.edit_note,         // Draft
      Icons.hourglass_empty,   // Pending
      Icons.work_history,      // Partly Completed
      Icons.check_circle,      // Complied
      Icons.cancel,            // Rejected
    ];
    return statusIcons[statusIndex];
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

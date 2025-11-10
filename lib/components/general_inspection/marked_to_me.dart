import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MarkedToMeGeneral extends StatefulWidget {
  final int statusIndex;

  const MarkedToMeGeneral({Key? key, required this.statusIndex}) : super(key: key);

  @override
  _MarkedToMeGeneralState createState() => _MarkedToMeGeneralState();
}

class _MarkedToMeGeneralState extends State<MarkedToMeGeneral> {
  // Data variables
  List<dynamic> allInspectionData = [];
  List<dynamic> filteredInspectionData = [];
  bool isLoading = true;
  int? userId;
  Map<String, int> statusCounts = {};

  // Status mapping
  static const List<int> statusFlags = [0, 1, 2, 3, 4];
  static const List<String> statusLabels = [
    'draft',
    'pending', 
    'partially_completed',
    'complied',
    'rejected'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserIdAndFetch();
  }

  // 🔥 ADD THIS METHOD - It detects when statusIndex changes
  @override
  void didUpdateWidget(MarkedToMeGeneral oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // If statusIndex changed, fetch new data
    if (oldWidget.statusIndex != widget.statusIndex) {
      print('🔄 Status index changed from ${oldWidget.statusIndex} to ${widget.statusIndex}');
      fetchMarkedToMeInspections();
    }
  }

  Future<void> _loadUserIdAndFetch() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('user_id');
    });
    
    print('📋 MarkedToMe - Retrieved user_id: $userId');
    
    if (userId != null) {
      fetchMarkedToMeInspections();
    } else {
      showSnackBar('User ID not found. Please login again.');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchMarkedToMeInspections() async {
    if (userId == null) {
      print('⚠️ userId is null, cannot fetch');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Build URL with status_flag parameter if specific status is selected
      String url = 'http://localhost:8000/api/marked-to-me/?user_id=$userId';
      
      // Add status_flag filter if a specific status is selected (not "All")
      if (widget.statusIndex >= 0 && widget.statusIndex < statusFlags.length) {
        final statusFlag = statusFlags[widget.statusIndex];
        url += '&status_flag=$statusFlag';
        print('🔍 Fetching with status_flag: $statusFlag');
      } else {
        print('🔍 Fetching all statuses');
      }

      print('🌐 API URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('📡 Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (responseData['success']) {
          setState(() {
            // Store filtered data from API
            filteredInspectionData = responseData['inspections'] ?? [];
            
            // Store status counts if available
            if (responseData.containsKey('status_counts')) {
              statusCounts = Map<String, int>.from(responseData['status_counts']);
            }
            
            // If showing all, store in allInspectionData too
            if (widget.statusIndex < 0 || widget.statusIndex >= statusFlags.length) {
              allInspectionData = filteredInspectionData;
            }
          });
          
          print('✅ Loaded ${filteredInspectionData.length} inspections');
          print('📊 Status Counts: $statusCounts');
        } else {
          showSnackBar('Error: ${responseData['message'] ?? 'Failed to load data'}');
        }
      } else {
        showSnackBar('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error: $e');
      showSnackBar('Network error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  String _getStatusDisplayName(int statusIndex) {
    if (statusIndex < 0 || statusIndex >= statusLabels.length) {
      return 'All';
    }

    const displayNames = [
      'Draft',
      'Pending',
      'Partially Completed',
      'Complied',
      'Rejected'
    ];
    return displayNames[statusIndex];
  }

  Color _getStatusColor(int? statusFlag) {
    switch (statusFlag) {
      case 0:
        return Colors.grey[600]!;
      case 1:
        return Colors.orange[600]!;
      case 2:
        return Colors.amber[600]!;
      case 3:
        return Colors.green[600]!;
      case 4:
        return Colors.red[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  String _getStatusText(int? statusFlag) {
    switch (statusFlag) {
      case 0:
        return 'DRAFT';
      case 1:
        return 'PENDING';
      case 2:
        return 'PARTIAL';
      case 3:
        return 'COMPLIED';
      case 4:
        return 'REJECTED';
      default:
        return 'UNKNOWN';
    }
  }

  Widget _buildInspectionCard(dynamic inspection) {
    final inspectedDate = inspection['inspected_on'] ?? '';
    final formattedInspectedDate = inspectedDate.isNotEmpty 
        ? inspectedDate.split('T')[0]
        : 'N/A';
    
    final markedDate = inspection['marked_on'] ?? '';
    final formattedMarkedDate = markedDate.isNotEmpty 
        ? markedDate.split('T')[0]
        : 'N/A';

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
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Inspection #${inspection['inspection_no']} - Item #${inspection['item_no']}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
                Container(
                  height: 28,
                  constraints: const BoxConstraints(minWidth: 80),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _getStatusColor(statusFlag),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(statusFlag),
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

            // Inspection Note and Marked Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (inspection['inspection_note_no'] != null &&
                    inspection['inspection_note_no'].toString().isNotEmpty)
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
                    'Marked: $formattedMarkedDate',
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

            // Inspection Title
            Text(
              inspection['inspection_title'] ?? 'No title available',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 12),

            // Item Title
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Text(
                inspection['item_title'] ?? 'No item description available',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.amber[800],
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Date Information
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Inspected: $formattedInspectedDate',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const Spacer(),
                if (inspection['target_date'] != null && 
                    inspection['target_date'].toString().isNotEmpty && 
                    inspection['target_date'].toString() != 'null')
                  Row(
                    children: [
                      Icon(Icons.flag, size: 16, color: Colors.orange[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Target: ${inspection['target_date'].toString().split('T')[0]}',
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
                  if (inspection['officer_desig'] != null &&
                      inspection['officer_desig'].toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Designation: ${inspection['officer_desig']}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  if (inspection['station_name'] != null &&
                      inspection['station_name'].toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentStatusName = _getStatusDisplayName(widget.statusIndex);
    final totalCount = statusCounts['total'] ?? 0;

    return Column(
      children: [
        // Header Section
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
                  color: widget.statusIndex >= 0 && widget.statusIndex < statusFlags.length
                      ? _getStatusColor(statusFlags[widget.statusIndex]).withOpacity(0.1)
                      : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  widget.statusIndex >= 0 && widget.statusIndex < statusFlags.length
                      ? _getStatusIcon(widget.statusIndex)
                      : Icons.inbox,
                  color: widget.statusIndex >= 0 && widget.statusIndex < statusFlags.length
                      ? _getStatusColor(statusFlags[widget.statusIndex])
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
                      '$currentStatusName Marked To Me',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${filteredInspectionData.length} ${currentStatusName == 'All' ? 'total' : 'of $totalCount total'} items',
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
            onRefresh: fetchMarkedToMeInspections,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredInspectionData.isEmpty
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
                                    'No $currentStatusName items marked to you',
                                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton.icon(
                                    onPressed: fetchMarkedToMeInspections,
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
                        itemCount: filteredInspectionData.length,
                        itemBuilder: (context, index) {
                          final inspection = filteredInspectionData[index];
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
      Icons.edit_note,
      Icons.hourglass_empty,
      Icons.work_history,
      Icons.check_circle,
      Icons.cancel,
    ];
    return statusIcons[statusIndex];
  }
}
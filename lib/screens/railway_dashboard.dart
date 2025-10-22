

// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import '../components/drawer/hamburger_menu.dart';
// // import '../components/profile/profile_screen.dart';
// // import '../components/dashboard_tabs/filter_button.dart';
// // import '../components/dashboard_tabs/all_tab.dart';
// // import '../components/dashboard_tabs/mom_tab.dart';
// // import '../components/dashboard_tabs/field_inspection_tab.dart';
// // import '../components/dashboard_tabs/general_inspection_tab.dart';
// // import '../constants/colors.dart';

// // class RailwayDashboard extends StatefulWidget {
// //   const RailwayDashboard({super.key});

// //   @override
// //   State<RailwayDashboard> createState() => _RailwayDashboardState();
// // }

// // class _RailwayDashboardState extends State<RailwayDashboard>
// //     with TickerProviderStateMixin {
// //   int selectedTabIndex = 0; // 0: MOM, 1: Field Inspection, 2: General Inspection
// //   Map<String, dynamic> appliedFilters = {};
// //   String searchQuery = '';
  
// //   // Dynamic inspection count
// //   int currentInspectionCount = 0;
  
// //   // Separate data for each inspection type
// //   List<Map<String, dynamic>> allInspections = [];
// //   List<Map<String, dynamic>> momInspections = [];
// //   List<Map<String, dynamic>> fieldInspections = [];
  
// //   // General inspection sub-categories
// //   List<Map<String, dynamic>> issuedByMeInspections = [];
// //   List<Map<String, dynamic>> markedToMeInspections = [];
// //   List<Map<String, dynamic>> forwardedToMeInspections = [];
  
// //   bool isLoading = true;
// //   int userId = 4386; // Get this from shared preferences or authentication

// //   // Track which general inspection sub-tab is selected (for nested tabs in GeneralInspectionTab)
// //   int selectedGeneralTabIndex = 0; // 0: Marked to Me, 1: Issued by Me, 2: Forwarded to Me

// //   final List<Widget> tabViews = const [
// //     MOMTab(),
// //     FieldInspectionTab(),
// //     GeneralInspectionTab(),
// //   ];

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadAllInspectionData();
// //   }

// //   // Load all inspection data from your APIs
// //   Future<void> _loadAllInspectionData() async {
// //     setState(() {
// //       isLoading = true;
// //     });
    
// //     try {
// //       // Load data from all your API endpoints
// //       await Future.wait([
// //         _fetchIssuedByMeInspections(),
// //         _fetchMarkedToMeInspections(), 
// //         _fetchForwardedToMeInspections(),
// //         _fetchFieldInspections(),
// //         _fetchMOMInspections(),
// //       ]);
      
// //       // Combine all inspections for "All" tab
// //       _combineAllInspections();
      
// //       setState(() {
// //         isLoading = false;
// //       });
// //       _updateInspectionCount();
      
// //     } catch (e) {
// //       print('Error loading inspections: $e');
// //       setState(() {
// //         isLoading = false;
// //       });
// //       _showErrorSnackBar('Error loading inspections: $e');
// //     }
// //   }

// //   // Fetch Issued By Me Inspections
// //   Future<void> _fetchIssuedByMeInspections() async {
// //     try {
// //       final response = await http.get(
// //         Uri.parse('https://deveins.indianrailways.gov.in/api/field-inspections/?user_id=$userId'),
// //         headers: {'Content-Type': 'application/json'},
// //       );

// //       if (response.statusCode == 200) {
// //         final responseData = json.decode(response.body);
// //         if (responseData['success']) {
// //           List<dynamic> rawInspections = responseData['data']['inspections'];
// //           setState(() {
// //             // Using mock data for demonstration - replace with actual API data
// //             issuedByMeInspections = List.generate(243, (index) => {
// //               'inspection_id': 'ISS${1000 + index}',
// //               'inspection_title': 'Issued Inspection ${index + 1}',
// //               'inspection_no': 'ISS-2024-${1000 + index}',
// //               'officer_name': 'Officer ${(index % 10) + 1}',
// //               'station_name': 'Station ${(index % 5) + 1}',
// //               'status': ['Pending', 'Completed', 'In Progress'][index % 3],
// //               'start_date': '2024-${((index % 12) + 1).toString().padLeft(2, '0')}-${((index % 28) + 1).toString().padLeft(2, '0')}',
// //               'type': 'issued_by_me',
// //             });
// //           });
// //           print('Issued by me inspections loaded: ${issuedByMeInspections.length}');
// //         }
// //       }
// //     } catch (e) {
// //       print('Error fetching issued by me inspections: $e');
// //     }
// //   }

// //   // Fetch Marked To Me Inspections
// //   Future<void> _fetchMarkedToMeInspections() async {
// //     try {
// //       final response = await http.get(
// //         Uri.parse('http://localhost:8000/api/marked-to-me/?user_id=$userId'),
// //         headers: {'Content-Type': 'application/json'},
// //       );

// //       if (response.statusCode == 200) {
// //         final responseData = json.decode(response.body);
// //         if (responseData['success']) {
// //           List<dynamic> rawInspections = responseData['inspections'] ?? [];
// //           setState(() {
// //             // Using mock data for demonstration - replace with actual API data
// //             markedToMeInspections = List.generate(1995, (index) => {
// //               'inspection_id': 'MRK${2000 + index}',
// //               'inspection_title': 'Marked Inspection ${index + 1}',
// //               'inspection_no': 'MRK-2024-${2000 + index}',
// //               'officer_name': 'Marking Officer ${(index % 15) + 1}',
// //               'station_name': 'Station ${(index % 8) + 1}',
// //               'status': ['Pending', 'Completed', 'In Progress', 'Under Review'][index % 4],
// //               'start_date': '2024-${((index % 12) + 1).toString().padLeft(2, '0')}-${((index % 28) + 1).toString().padLeft(2, '0')}',
// //               'inspected_on': '2024-${((index % 12) + 1).toString().padLeft(2, '0')}-${((index % 28) + 1).toString().padLeft(2, '0')}',
// //               'type': 'marked_to_me',
// //             });
// //           });
// //           print('Marked to me inspections loaded: ${markedToMeInspections.length}');
// //         }
// //       }
// //     } catch (e) {
// //       print('Error fetching marked to me inspections: $e');
// //       // If API fails, set empty list
// //       setState(() {
// //         markedToMeInspections = [];
// //       });
// //     }
// //   }

// //   // Fetch Forwarded To Me Inspections
// //   Future<void> _fetchForwardedToMeInspections() async {
// //     try {
// //       final response = await http.get(
// //         Uri.parse('http://localhost:8000/api/forwarded-to-me/?user_id=$userId'),
// //         headers: {'Content-Type': 'application/json'},
// //       );

// //       if (response.statusCode == 200) {
// //         final responseData = json.decode(response.body);
// //         if (responseData['success']) {
// //           List<dynamic> rawInspections = responseData['inspections'] ?? [];
// //           setState(() {
// //             // Using empty list as per requirement (0 count)
// //             forwardedToMeInspections = [];
// //           });
// //           print('Forwarded to me inspections loaded: ${forwardedToMeInspections.length}');
// //         }
// //       } else {
// //         setState(() {
// //           forwardedToMeInspections = [];
// //         });
// //       }
// //     } catch (e) {
// //       print('Error fetching forwarded to me inspections: $e');
// //       setState(() {
// //         forwardedToMeInspections = [];
// //       });
// //     }
// //   }

// //   // Fetch Field Inspections
// //   Future<void> _fetchFieldInspections() async {
// //     try {
// //       final response = await http.get(
// //         Uri.parse('http://localhost:8000/api/field-inspections-list/?user_id=$userId'),
// //         headers: {'Content-Type': 'application/json'},
// //       );

// //       if (response.statusCode == 200) {
// //         final responseData = json.decode(response.body);
// //         if (responseData['success']) {
// //           List<dynamic> rawInspections = responseData['data']['inspections'] ?? [];
// //           setState(() {
// //             fieldInspections = rawInspections.map((inspection) {
// //               Map<String, dynamic> inspectionMap = Map<String, dynamic>.from(inspection);
// //               inspectionMap['type'] = 'field';
// //               return inspectionMap;
// //             }).toList();
// //           });
// //           print('Field inspections loaded: ${fieldInspections.length}');
// //         }
// //       }
// //     } catch (e) {
// //       print('Error fetching field inspections: $e');
// //     }
// //   }

// //   // Fetch MOM Inspections
// //   Future<void> _fetchMOMInspections() async {
// //     try {
// //       final response = await http.get(
// //         Uri.parse('http://localhost:8000/api/mom-inspections/?user_id=$userId'),
// //         headers: {'Content-Type': 'application/json'},
// //       );

// //       if (response.statusCode == 200) {
// //         final responseData = json.decode(response.body);
// //         if (responseData['success']) {
// //           List<dynamic> rawInspections = responseData['data']['inspections'] ?? [];
// //           setState(() {
// //             momInspections = rawInspections.map((inspection) {
// //               Map<String, dynamic> inspectionMap = Map<String, dynamic>.from(inspection);
// //               inspectionMap['type'] = 'mom';
// //               return inspectionMap;
// //             }).toList();
// //           });
// //           print('MOM inspections loaded: ${momInspections.length}');
// //         }
// //       }
// //     } catch (e) {
// //       print('Error fetching MOM inspections: $e');
// //     }
// //   }

// //   // Combine all inspection types
// //   void _combineAllInspections() {
// //     allInspections = [
// //       ...issuedByMeInspections,
// //       ...markedToMeInspections,
// //       ...forwardedToMeInspections,
// //       ...fieldInspections,
// //       ...momInspections,
// //     ];
// //     print('All inspections combined: ${allInspections.length}');
// //   }

// //   void _updateInspectionCount() {
// //     List<Map<String, dynamic>> filteredInspections = _getFilteredInspections();
// //     setState(() {
// //       currentInspectionCount = filteredInspections.length;
// //     });
// //     print('Updated inspection count: $currentInspectionCount for tab: $selectedTabIndex');
// //   }

// //   List<Map<String, dynamic>> _getFilteredInspections() {
// //     List<Map<String, dynamic>> filtered = [];

// //     // Filter by current main tab
// //     switch (selectedTabIndex) {
// //       case 0: // MOM Tab
// //         filtered = List<Map<String, dynamic>>.from(momInspections);
// //         break;
// //       case 1: // Field Inspection Tab
// //         filtered = List<Map<String, dynamic>>.from(fieldInspections);
// //         break;
// //       case 2: // General Inspection Tab
// //         // For General Inspection, filter by sub-tab
// //         switch (selectedGeneralTabIndex) {
// //           case 0: // Marked to Me
// //             filtered = List<Map<String, dynamic>>.from(markedToMeInspections);
// //             break;
// //           case 1: // Issued by Me
// //             filtered = List<Map<String, dynamic>>.from(issuedByMeInspections);
// //             break;
// //           case 2: // Forwarded to Me
// //             filtered = List<Map<String, dynamic>>.from(forwardedToMeInspections);
// //             break;
// //           default:
// //             filtered = List<Map<String, dynamic>>.from(markedToMeInspections);
// //         }
// //         break;
// //     }

// //     print('Base filtered count: ${filtered.length} for tab: $selectedTabIndex, generalTab: $selectedGeneralTabIndex');

// //     // Apply search filter
// //     if (searchQuery.isNotEmpty) {
// //       filtered = filtered.where((inspection) {
// //         final title = inspection['inspection_title']?.toString().toLowerCase() ?? '';
// //         final inspectionNo = inspection['inspection_no']?.toString().toLowerCase() ?? '';
// //         final officerName = inspection['officer_name']?.toString().toLowerCase() ?? '';
// //         final stationName = inspection['station_name']?.toString().toLowerCase() ?? '';
        
// //         return title.contains(searchQuery.toLowerCase()) ||
// //                inspectionNo.contains(searchQuery.toLowerCase()) ||
// //                officerName.contains(searchQuery.toLowerCase()) ||
// //                stationName.contains(searchQuery.toLowerCase());
// //       }).toList();
// //     }

// //     // Apply additional filters
// //     if (appliedFilters.isNotEmpty) {
// //       // Filter by status
// //       if (appliedFilters['status'] != null && appliedFilters['status'].isNotEmpty) {
// //         filtered = filtered.where((inspection) {
// //           return inspection['status']?.toString().toLowerCase() == 
// //                  appliedFilters['status'].toString().toLowerCase();
// //         }).toList();
// //       }

// //       // Filter by date range
// //       if (appliedFilters['dateFrom'] != null && appliedFilters['dateTo'] != null) {
// //         filtered = filtered.where((inspection) {
// //           try {
// //             String dateField = inspection['start_date'] ?? inspection['inspected_on'] ?? '';
// //             if (dateField.isNotEmpty) {
// //               DateTime inspectionDate = DateTime.parse(dateField);
// //               DateTime fromDate = DateTime.parse(appliedFilters['dateFrom']);
// //               DateTime toDate = DateTime.parse(appliedFilters['dateTo']);
// //               return inspectionDate.isAfter(fromDate.subtract(Duration(days: 1))) &&
// //                      inspectionDate.isBefore(toDate.add(Duration(days: 1)));
// //             }
// //             return false;
// //           } catch (e) {
// //             return false;
// //           }
// //         }).toList();
// //       }

// //       // Filter by officer name
// //       if (appliedFilters['officer'] != null && appliedFilters['officer'].isNotEmpty) {
// //         filtered = filtered.where((inspection) {
// //           return inspection['officer_name']?.toString().toLowerCase()
// //                  .contains(appliedFilters['officer'].toString().toLowerCase()) ?? false;
// //         }).toList();
// //       }

// //       // Filter by station
// //       if (appliedFilters['station'] != null && appliedFilters['station'].isNotEmpty) {
// //         filtered = filtered.where((inspection) {
// //           return inspection['station_name']?.toString().toLowerCase()
// //                  .contains(appliedFilters['station'].toString().toLowerCase()) ?? false;
// //         }).toList();
// //       }
// //     }

// //     print('Final filtered count: ${filtered.length}');
// //     return filtered;
// //   }

// //   void _onFiltersApplied(Map<String, dynamic> filters) {
// //     setState(() {
// //       appliedFilters = filters;
// //     });
    
// //     // Update count after filters are applied
// //     _updateInspectionCount();
    
// //     print('Applied Filters in Dashboard: $filters');
// //   }

// //   void _onSearchChanged(String value) {
// //     setState(() {
// //       searchQuery = value;
// //     });
    
// //     // Update count after search query changes
// //     _updateInspectionCount();
// //   }

// //   void _onTabChanged(int index) {
// //     setState(() {
// //       selectedTabIndex = index;
// //       // Reset general tab index when switching away from general tab
// //       if (index != 2) {
// //         selectedGeneralTabIndex = 0;
// //       }
// //     });
    
// //     // Update count when tab changes
// //     _updateInspectionCount();
// //   }

// //   // Add this method to handle general inspection sub-tab changes
// //   void _onGeneralTabChanged(int index) {
// //     setState(() {
// //       selectedGeneralTabIndex = index;
// //     });
    
// //     // Update count when general sub-tab changes
// //     _updateInspectionCount();
    
// //     print('General tab changed to: $index');
// //   }

// //   // Method to get current inspection data for the selected tab
// //   List<Map<String, dynamic>> getCurrentInspectionData() {
// //     return _getFilteredInspections();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       drawer: const HamburgerMenu(),
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             // Top Bar
// //             Container(
// //               color: Colors.white,
// //               padding: const EdgeInsets.symmetric(horizontal: 12),
// //               child: Row(
// //                 children: [
// //                   Builder(
// //                     builder: (context) => IconButton(
// //                       icon: const Icon(Icons.menu),
// //                       onPressed: () => Scaffold.of(context).openDrawer(),
// //                     ),
// //                   ),
// //                   const Icon(Icons.train, color: primaryBlue, size: 30),
// //                   const SizedBox(width: 8),
// //                   const Text(
// //                     'E-Inspection',
// //                     style: TextStyle(
// //                       fontSize: 20,
// //                       color: primaryBlue,
// //                       fontWeight: FontWeight.bold,
// //                     ),
// //                   ),
// //                   const Spacer(),
// //                   IconButton(
// //                     icon: const Icon(Icons.add, color: primaryBlue),
// //                     onPressed: addNewInspection,
// //                   ),
// //                   const ProfileScreen(),
// //                 ],
// //               ),
// //             ),

// //             // Search + Dynamic Count
// //             Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
// //               child: Row(
// //                 children: [
// //                   Expanded(
// //                     child: TextField(
// //                       decoration: InputDecoration(
// //                         hintText: 'Search inspections, meetings...',
// //                         prefixIcon: const Icon(Icons.search),
// //                         contentPadding: const EdgeInsets.symmetric(vertical: 0),
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(25),
// //                           borderSide: const BorderSide(color: Colors.grey),
// //                         ),
// //                         enabledBorder: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(25),
// //                           borderSide: BorderSide(color: Colors.grey[300]!),
// //                         ),
// //                         focusedBorder: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(25),
// //                           borderSide: const BorderSide(color: primaryBlue),
// //                         ),
// //                       ),
// //                       onChanged: _onSearchChanged,
// //                     ),
// //                   ),
// //                   const SizedBox(width: 12),
// //                   // Dynamic count display
// //                   Container(
// //                     width: 45,
// //                     height: 45,
// //                     decoration: const BoxDecoration(
// //                       color: primaryOrange,
// //                       shape: BoxShape.circle,
// //                     ),
// //                     alignment: Alignment.center,
// //                     child: Text(
// //                       '$currentInspectionCount', // Dynamic count
// //                       style: const TextStyle(
// //                         color: Colors.white,
// //                         fontWeight: FontWeight.bold,
// //                         fontSize: 14,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),

// //             // Navigation Tabs (Removed Home)
// //             Container(
// //               height: 60,
// //               color: Colors.grey[50],
// //               child: Row(
// //                 children: [
// //                   // MOM Tab
// //                   Expanded(
// //                     child: _buildNavTab(
// //                       icon: Icons.meeting_room,
// //                       label: 'MOM',
// //                       index: 0,
// //                     ),
// //                   ),
// //                   // Field Inspection Tab
// //                   Expanded(
// //                     child: _buildNavTab(
// //                       icon: Icons.assignment,
// //                       label: 'Field Inspection',
// //                       index: 1,
// //                     ),
// //                   ),
// //                   // General Inspection Tab
// //                   Expanded(
// //                     child: _buildNavTab(
// //                       icon: Icons.fact_check,
// //                       label: 'General Inspection',
// //                       index: 2,
// //                     ),
// //                   ),
// //                   // Filter Button
// //                   Container(
// //                     padding: const EdgeInsets.all(8),
// //                     child: FilterButton(
// //                       onFiltersApplied: _onFiltersApplied,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),

// //             // Filter Status Indicator
// //             if (appliedFilters.isNotEmpty) _buildFilterStatusBar(),

// //             const SizedBox(height: 8),

// //             // Tab content with loading state
// //             Expanded(
// //               child: Container(
// //                 padding: const EdgeInsets.symmetric(horizontal: 12),
// //                 child: isLoading 
// //                   ? Center(
// //                       child: Column(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         children: [
// //                           CircularProgressIndicator(color: primaryBlue),
// //                           SizedBox(height: 16),
// //                           Text('Loading inspections...'),
// //                         ],
// //                       ),
// //                     )
// //                   : _buildTabContent(),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildTabContent() {
// //     // For General Inspection tab, we need to pass additional data and callbacks
// //     if (selectedTabIndex == 2) {
// //       return GeneralInspectionTabWithCallback(
// //         issuedByMeInspections: issuedByMeInspections,
// //         markedToMeInspections: markedToMeInspections,
// //         forwardedToMeInspections: forwardedToMeInspections,
// //         selectedSubTabIndex: selectedGeneralTabIndex,
// //         onSubTabChanged: _onGeneralTabChanged,
// //         searchQuery: searchQuery,
// //         appliedFilters: appliedFilters,
// //       );
// //     }
    
// //     return tabViews[selectedTabIndex];
// //   }

// //   Widget _buildNavTab({
// //     required IconData icon,
// //     required String label,
// //     required int index,
// //   }) {
// //     final isSelected = selectedTabIndex == index;
// //     return GestureDetector(
// //       onTap: () => _onTabChanged(index),
// //       child: Container(
// //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
// //         decoration: BoxDecoration(
// //           color: isSelected ? primaryBlue : Colors.transparent,
// //           borderRadius: BorderRadius.circular(8),
// //         ),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Icon(
// //               icon,
// //               color: isSelected ? Colors.white : Colors.grey[600],
// //               size: 22,
// //             ),
// //             const SizedBox(height: 4),
// //             Text(
// //               label,
// //               style: TextStyle(
// //                 color: isSelected ? Colors.white : Colors.grey[600],
// //                 fontSize: 10,
// //                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
// //               ),
// //               textAlign: TextAlign.center,
// //               maxLines: 1,
// //               overflow: TextOverflow.ellipsis,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget _buildFilterStatusBar() {
// //     int activeFiltersCount = appliedFilters.values
// //         .where((value) => value != null && value.toString().isNotEmpty)
// //         .length;

// //     return Container(
// //       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //       decoration: BoxDecoration(
// //         color: Colors.blue[50],
// //         borderRadius: BorderRadius.circular(20),
// //         border: Border.all(color: Colors.blue[200]!),
// //       ),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Icon(
// //             Icons.filter_list,
// //             size: 16,
// //             color: Colors.blue[800],
// //           ),
// //           const SizedBox(width: 8),
// //           Text(
// //             '$activeFiltersCount filter${activeFiltersCount != 1 ? 's' : ''} applied',
// //             style: TextStyle(
// //               color: Colors.blue[800],
// //               fontSize: 12,
// //               fontWeight: FontWeight.w500,
// //             ),
// //           ),
// //           const SizedBox(width: 8),
// //           GestureDetector(
// //             onTap: () {
// //               setState(() {
// //                 appliedFilters.clear();
// //               });
// //               _updateInspectionCount();
// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 const SnackBar(
// //                   content: Text('Filters cleared'),
// //                   duration: Duration(seconds: 2),
// //                 ),
// //               );
// //             },
// //             child: Container(
// //               padding: const EdgeInsets.all(2),
// //               decoration: BoxDecoration(
// //                 color: Colors.blue[800],
// //                 shape: BoxShape.circle,
// //               ),
// //               child: const Icon(
// //                 Icons.close,
// //                 size: 12,
// //                 color: Colors.white,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   // Method to refresh data from your APIs
// //   Future<void> refreshInspections() async {
// //     await _loadAllInspectionData();
// //   }

// //   void _showErrorSnackBar(String message) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text(message),
// //         backgroundColor: Colors.red,
// //         duration: Duration(seconds: 3),
// //       ),
// //     );
// //   }

// //   // Method to add new inspection (called when add button is pressed)
// //   void addNewInspection() {
// //     // Navigate to add inspection screen or show dialog
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       SnackBar(
// //         content: Text('Add new inspection - Implement navigation'),
// //         action: SnackBarAction(
// //           label: 'Refresh',
// //           onPressed: refreshInspections,
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // Custom widget for General Inspection Tab with callback
// // class GeneralInspectionTabWithCallback extends StatelessWidget {
// //   final List<Map<String, dynamic>> issuedByMeInspections;
// //   final List<Map<String, dynamic>> markedToMeInspections;
// //   final List<Map<String, dynamic>> forwardedToMeInspections;
// //   final int selectedSubTabIndex;
// //   final Function(int) onSubTabChanged;
// //   final String searchQuery;
// //   final Map<String, dynamic> appliedFilters;

// //   const GeneralInspectionTabWithCallback({
// //     Key? key,
// //     required this.issuedByMeInspections,
// //     required this.markedToMeInspections,
// //     required this.forwardedToMeInspections,
// //     required this.selectedSubTabIndex,
// //     required this.onSubTabChanged,
// //     required this.searchQuery,
// //     required this.appliedFilters,
// //   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return GeneralInspectionTab(
// //       onSubTabChanged: onSubTabChanged,
// //     );
// //   }
// // }











// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../components/drawer/hamburger_menu.dart';
// import '../components/profile/profile_screen.dart';
// import '../components/dashboard_tabs/filter_button.dart';
// import '../components/dashboard_tabs/all_tab.dart';
// import '../components/dashboard_tabs/mom_tab.dart';
// import '../components/dashboard_tabs/field_inspection_tab.dart';
// import '../components/dashboard_tabs/general_inspection_tab.dart';
// import '../constants/colors.dart';

// class RailwayDashboard extends StatefulWidget {
//   final int? userId; // Optional parameter to pass userId
  
//   const RailwayDashboard({super.key, this.userId});

//   @override
//   State<RailwayDashboard> createState() => _RailwayDashboardState();
// }

// class _RailwayDashboardState extends State<RailwayDashboard>
//     with TickerProviderStateMixin {
//   int selectedTabIndex = 0; // 0: MOM, 1: Field Inspection, 2: General Inspection
//   Map<String, dynamic> appliedFilters = {};
//   String searchQuery = '';
  
//   // Dynamic inspection count
//   int currentInspectionCount = 0;
  
//   // Separate data for each inspection type
//   List<Map<String, dynamic>> allInspections = [];
//   List<Map<String, dynamic>> momInspections = [];
//   List<Map<String, dynamic>> fieldInspections = [];
  
//   // General inspection sub-categories
//   List<Map<String, dynamic>> issuedByMeInspections = [];
//   List<Map<String, dynamic>> markedToMeInspections = [];
//   List<Map<String, dynamic>> forwardedToMeInspections = [];
  
//   bool isLoading = true;
//   int? userId; // Dynamic user ID - will be set in initState

//   // Track which general inspection sub-tab is selected (for nested tabs in GeneralInspectionTab)
//   int selectedGeneralTabIndex = 0; // 0: Marked to Me, 1: Issued by Me, 2: Forwarded to Me

//   final List<Widget> tabViews = const [
//     MOMTab(),
//     FieldInspectionTab(),
//     GeneralInspectionTab(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _initializeUserId();
//   }

//   // Initialize userId from widget parameter or SharedPreferences
//   Future<void> _initializeUserId() async {
//     try {
//       if (widget.userId != null) {
//         // Use userId passed from widget
//         userId = widget.userId;
//         print('Using userId from widget: $userId');
//       } else {
//         // Try to get from SharedPreferences
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         userId = prefs.getInt('user_id');
//         print('Loaded userId from SharedPreferences: $userId');
//       }

//       // If still no userId, show error
//       if (userId == null) {
//         _showErrorSnackBar('User ID not found. Please login again.');
//         setState(() {
//           isLoading = false;
//         });
//         return;
//       }

//       // Load data after userId is set
//       await _loadAllInspectionData();
//     } catch (e) {
//       print('Error initializing userId: $e');
//       _showErrorSnackBar('Error initializing user: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   // Load all inspection data from your APIs
//   Future<void> _loadAllInspectionData() async {
//     if (userId == null) {
//       _showErrorSnackBar('User ID not found');
//       return;
//     }

//     setState(() {
//       isLoading = true;
//     });
    
//     try {
//       // Load data from all your API endpoints
//       await Future.wait([
//         _fetchIssuedByMeInspections(),
//         _fetchMarkedToMeInspections(), 
//         _fetchForwardedToMeInspections(),
//         _fetchFieldInspections(),
//         _fetchMOMInspections(),
//       ]);
      
//       // Combine all inspections for "All" tab
//       _combineAllInspections();
      
//       setState(() {
//         isLoading = false;
//       });
//       _updateInspectionCount();
      
//     } catch (e) {
//       print('Error loading inspections: $e');
//       setState(() {
//         isLoading = false;
//       });
//       _showErrorSnackBar('Error loading inspections: $e');
//     }
//   }

//   // Fetch Issued By Me Inspections
//   Future<void> _fetchIssuedByMeInspections() async {
//     if (userId == null) return;
    
//     try {
//       final response = await http.get(
//         Uri.parse('https://deveins.indianrailways.gov.in/api/field-inspections/?user_id=$userId'),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         if (responseData['success']) {
//           List<dynamic> rawInspections = responseData['data']['inspections'];
//           setState(() {
//             // Using mock data for demonstration - replace with actual API data
//             issuedByMeInspections = List.generate(243, (index) => {
//               'inspection_id': 'ISS${1000 + index}',
//               'inspection_title': 'Issued Inspection ${index + 1}',
//               'inspection_no': 'ISS-2024-${1000 + index}',
//               'officer_name': 'Officer ${(index % 10) + 1}',
//               'station_name': 'Station ${(index % 5) + 1}',
//               'status': ['Pending', 'Completed', 'In Progress'][index % 3],
//               'start_date': '2024-${((index % 12) + 1).toString().padLeft(2, '0')}-${((index % 28) + 1).toString().padLeft(2, '0')}',
//               'type': 'issued_by_me',
//             });
//           });
//           print('Issued by me inspections loaded for user $userId: ${issuedByMeInspections.length}');
//         }
//       }
//     } catch (e) {
//       print('Error fetching issued by me inspections: $e');
//     }
//   }

//   // Fetch Marked To Me Inspections
//   Future<void> _fetchMarkedToMeInspections() async {
//     if (userId == null) return;
    
//     try {
//       final response = await http.get(
//         Uri.parse('http://localhost:8000/api/marked-to-me/?user_id=$userId'),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         if (responseData['success']) {
//           List<dynamic> rawInspections = responseData['inspections'] ?? [];
//           setState(() {
//             // Using mock data for demonstration - replace with actual API data
//             markedToMeInspections = List.generate(1995, (index) => {
//               'inspection_id': 'MRK${2000 + index}',
//               'inspection_title': 'Marked Inspection ${index + 1}',
//               'inspection_no': 'MRK-2024-${2000 + index}',
//               'officer_name': 'Marking Officer ${(index % 15) + 1}',
//               'station_name': 'Station ${(index % 8) + 1}',
//               'status': ['Pending', 'Completed', 'In Progress', 'Under Review'][index % 4],
//               'start_date': '2024-${((index % 12) + 1).toString().padLeft(2, '0')}-${((index % 28) + 1).toString().padLeft(2, '0')}',
//               'inspected_on': '2024-${((index % 12) + 1).toString().padLeft(2, '0')}-${((index % 28) + 1).toString().padLeft(2, '0')}',
//               'type': 'marked_to_me',
//             });
//           });
//           print('Marked to me inspections loaded for user $userId: ${markedToMeInspections.length}');
//         }
//       }
//     } catch (e) {
//       print('Error fetching marked to me inspections: $e');
//       // If API fails, set empty list
//       setState(() {
//         markedToMeInspections = [];
//       });
//     }
//   }

//   // Fetch Forwarded To Me Inspections
//   Future<void> _fetchForwardedToMeInspections() async {
//     if (userId == null) return;
    
//     try {
//       final response = await http.get(
//         Uri.parse('http://localhost:8000/api/forwarded-to-me/?user_id=$userId'),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         if (responseData['success']) {
//           List<dynamic> rawInspections = responseData['inspections'] ?? [];
//           setState(() {
//             // Using empty list as per requirement (0 count)
//             forwardedToMeInspections = [];
//           });
//           print('Forwarded to me inspections loaded for user $userId: ${forwardedToMeInspections.length}');
//         }
//       } else {
//         setState(() {
//           forwardedToMeInspections = [];
//         });
//       }
//     } catch (e) {
//       print('Error fetching forwarded to me inspections: $e');
//       setState(() {
//         forwardedToMeInspections = [];
//       });
//     }
//   }

//   // Fetch Field Inspections
//   Future<void> _fetchFieldInspections() async {
//     if (userId == null) return;
    
//     try {
//       final response = await http.get(
//         Uri.parse('http://localhost:8000/api/field-inspections-list/?user_id=$userId'),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         if (responseData['success']) {
//           List<dynamic> rawInspections = responseData['data']['inspections'] ?? [];
//           setState(() {
//             fieldInspections = rawInspections.map((inspection) {
//               Map<String, dynamic> inspectionMap = Map<String, dynamic>.from(inspection);
//               inspectionMap['type'] = 'field';
//               return inspectionMap;
//             }).toList();
//           });
//           print('Field inspections loaded for user $userId: ${fieldInspections.length}');
//         }
//       }
//     } catch (e) {
//       print('Error fetching field inspections: $e');
//     }
//   }

//   // Fetch MOM Inspections
//   Future<void> _fetchMOMInspections() async {
//     if (userId == null) return;
    
//     try {
//       final response = await http.get(
//         Uri.parse('http://localhost:8000/api/mom-inspections/?user_id=$userId'),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         final responseData = json.decode(response.body);
//         if (responseData['success']) {
//           List<dynamic> rawInspections = responseData['data']['inspections'] ?? [];
//           setState(() {
//             momInspections = rawInspections.map((inspection) {
//               Map<String, dynamic> inspectionMap = Map<String, dynamic>.from(inspection);
//               inspectionMap['type'] = 'mom';
//               return inspectionMap;
//             }).toList();
//           });
//           print('MOM inspections loaded for user $userId: ${momInspections.length}');
//         }
//       }
//     } catch (e) {
//       print('Error fetching MOM inspections: $e');
//     }
//   }

//   // Combine all inspection types
//   void _combineAllInspections() {
//     allInspections = [
//       ...issuedByMeInspections,
//       ...markedToMeInspections,
//       ...forwardedToMeInspections,
//       ...fieldInspections,
//       ...momInspections,
//     ];
//     print('All inspections combined for user $userId: ${allInspections.length}');
//   }

//   void _updateInspectionCount() {
//     List<Map<String, dynamic>> filteredInspections = _getFilteredInspections();
//     setState(() {
//       currentInspectionCount = filteredInspections.length;
//     });
//     print('Updated inspection count: $currentInspectionCount for tab: $selectedTabIndex');
//   }

//   List<Map<String, dynamic>> _getFilteredInspections() {
//     List<Map<String, dynamic>> filtered = [];

//     // Filter by current main tab
//     switch (selectedTabIndex) {
//       case 0: // MOM Tab
//         filtered = List<Map<String, dynamic>>.from(momInspections);
//         break;
//       case 1: // Field Inspection Tab
//         filtered = List<Map<String, dynamic>>.from(fieldInspections);
//         break;
//       case 2: // General Inspection Tab
//         // For General Inspection, filter by sub-tab
//         switch (selectedGeneralTabIndex) {
//           case 0: // Marked to Me
//             filtered = List<Map<String, dynamic>>.from(markedToMeInspections);
//             break;
//           case 1: // Issued by Me
//             filtered = List<Map<String, dynamic>>.from(issuedByMeInspections);
//             break;
//           case 2: // Forwarded to Me
//             filtered = List<Map<String, dynamic>>.from(forwardedToMeInspections);
//             break;
//           default:
//             filtered = List<Map<String, dynamic>>.from(markedToMeInspections);
//         }
//         break;
//     }

//     print('Base filtered count: ${filtered.length} for tab: $selectedTabIndex, generalTab: $selectedGeneralTabIndex');

//     // Apply search filter
//     if (searchQuery.isNotEmpty) {
//       filtered = filtered.where((inspection) {
//         final title = inspection['inspection_title']?.toString().toLowerCase() ?? '';
//         final inspectionNo = inspection['inspection_no']?.toString().toLowerCase() ?? '';
//         final officerName = inspection['officer_name']?.toString().toLowerCase() ?? '';
//         final stationName = inspection['station_name']?.toString().toLowerCase() ?? '';
        
//         return title.contains(searchQuery.toLowerCase()) ||
//                inspectionNo.contains(searchQuery.toLowerCase()) ||
//                officerName.contains(searchQuery.toLowerCase()) ||
//                stationName.contains(searchQuery.toLowerCase());
//       }).toList();
//     }

//     // Apply additional filters
//     if (appliedFilters.isNotEmpty) {
//       // Filter by status
//       if (appliedFilters['status'] != null && appliedFilters['status'].isNotEmpty) {
//         filtered = filtered.where((inspection) {
//           return inspection['status']?.toString().toLowerCase() == 
//                  appliedFilters['status'].toString().toLowerCase();
//         }).toList();
//       }

//       // Filter by date range
//       if (appliedFilters['dateFrom'] != null && appliedFilters['dateTo'] != null) {
//         filtered = filtered.where((inspection) {
//           try {
//             String dateField = inspection['start_date'] ?? inspection['inspected_on'] ?? '';
//             if (dateField.isNotEmpty) {
//               DateTime inspectionDate = DateTime.parse(dateField);
//               DateTime fromDate = DateTime.parse(appliedFilters['dateFrom']);
//               DateTime toDate = DateTime.parse(appliedFilters['dateTo']);
//               return inspectionDate.isAfter(fromDate.subtract(Duration(days: 1))) &&
//                      inspectionDate.isBefore(toDate.add(Duration(days: 1)));
//             }
//             return false;
//           } catch (e) {
//             return false;
//           }
//         }).toList();
//       }

//       // Filter by officer name
//       if (appliedFilters['officer'] != null && appliedFilters['officer'].isNotEmpty) {
//         filtered = filtered.where((inspection) {
//           return inspection['officer_name']?.toString().toLowerCase()
//                  .contains(appliedFilters['officer'].toString().toLowerCase()) ?? false;
//         }).toList();
//       }

//       // Filter by station
//       if (appliedFilters['station'] != null && appliedFilters['station'].isNotEmpty) {
//         filtered = filtered.where((inspection) {
//           return inspection['station_name']?.toString().toLowerCase()
//                  .contains(appliedFilters['station'].toString().toLowerCase()) ?? false;
//         }).toList();
//       }
//     }

//     print('Final filtered count: ${filtered.length}');
//     return filtered;
//   }

//   void _onFiltersApplied(Map<String, dynamic> filters) {
//     setState(() {
//       appliedFilters = filters;
//     });
    
//     // Update count after filters are applied
//     _updateInspectionCount();
    
//     print('Applied Filters in Dashboard: $filters');
//   }

//   void _onSearchChanged(String value) {
//     setState(() {
//       searchQuery = value;
//     });
    
//     // Update count after search query changes
//     _updateInspectionCount();
//   }

//   void _onTabChanged(int index) {
//     setState(() {
//       selectedTabIndex = index;
//       // Reset general tab index when switching away from general tab
//       if (index != 2) {
//         selectedGeneralTabIndex = 0;
//       }
//     });
    
//     // Update count when tab changes
//     _updateInspectionCount();
//   }

//   // Add this method to handle general inspection sub-tab changes
//   void _onGeneralTabChanged(int index) {
//     setState(() {
//       selectedGeneralTabIndex = index;
//     });
    
//     // Update count when general sub-tab changes
//     _updateInspectionCount();
    
//     print('General tab changed to: $index');
//   }

//   // Method to get current inspection data for the selected tab
//   List<Map<String, dynamic>> getCurrentInspectionData() {
//     return _getFilteredInspections();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const HamburgerMenu(),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Top Bar
//             Container(
//               color: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: Row(
//                 children: [
//                   Builder(
//                     builder: (context) => IconButton(
//                       icon: const Icon(Icons.menu),
//                       onPressed: () => Scaffold.of(context).openDrawer(),
//                     ),
//                   ),
//                   const Icon(Icons.train, color: primaryBlue, size: 30),
//                   const SizedBox(width: 8),
//                   const Text(
//                     'E-Inspection',
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: primaryBlue,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const Spacer(),
//                   IconButton(
//                     icon: const Icon(Icons.add, color: primaryBlue),
//                     onPressed: addNewInspection,
//                   ),
//                   const ProfileScreen(),
//                 ],
//               ),
//             ),

//             // Search + Dynamic Count
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       decoration: InputDecoration(
//                         hintText: 'Search inspections, meetings...',
//                         prefixIcon: const Icon(Icons.search),
//                         contentPadding: const EdgeInsets.symmetric(vertical: 0),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(25),
//                           borderSide: const BorderSide(color: Colors.grey),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(25),
//                           borderSide: BorderSide(color: Colors.grey[300]!),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(25),
//                           borderSide: const BorderSide(color: primaryBlue),
//                         ),
//                       ),
//                       onChanged: _onSearchChanged,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   // Dynamic count display
//                   Container(
//                     width: 45,
//                     height: 45,
//                     decoration: const BoxDecoration(
//                       color: primaryOrange,
//                       shape: BoxShape.circle,
//                     ),
//                     alignment: Alignment.center,
//                     child: Text(
//                       '$currentInspectionCount', // Dynamic count
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Navigation Tabs (Removed Home)
//             Container(
//               height: 60,
//               color: Colors.grey[50],
//               child: Row(
//                 children: [
//                   // MOM Tab
//                   Expanded(
//                     child: _buildNavTab(
//                       icon: Icons.meeting_room,
//                       label: 'MOM',
//                       index: 0,
//                     ),
//                   ),
//                   // Field Inspection Tab
//                   Expanded(
//                     child: _buildNavTab(
//                       icon: Icons.assignment,
//                       label: 'Field Inspection',
//                       index: 1,
//                     ),
//                   ),
//                   // General Inspection Tab
//                   Expanded(
//                     child: _buildNavTab(
//                       icon: Icons.fact_check,
//                       label: 'General Inspection',
//                       index: 2,
//                     ),
//                   ),
//                   // Filter Button
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     child: FilterButton(
//                       onFiltersApplied: _onFiltersApplied,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Filter Status Indicator
//             if (appliedFilters.isNotEmpty) _buildFilterStatusBar(),

//             const SizedBox(height: 8),

//             // Tab content with loading state
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 child: isLoading 
//                   ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           CircularProgressIndicator(color: primaryBlue),
//                           SizedBox(height: 16),
//                           Text('Loading inspections...'),
//                         ],
//                       ),
//                     )
//                   : _buildTabContent(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTabContent() {
//     // For General Inspection tab, we need to pass additional data and callbacks
//     if (selectedTabIndex == 2) {
//       return GeneralInspectionTabWithCallback(
//         issuedByMeInspections: issuedByMeInspections,
//         markedToMeInspections: markedToMeInspections,
//         forwardedToMeInspections: forwardedToMeInspections,
//         selectedSubTabIndex: selectedGeneralTabIndex,
//         onSubTabChanged: _onGeneralTabChanged,
//         searchQuery: searchQuery,
//         appliedFilters: appliedFilters,
//       );
//     }
    
//     return tabViews[selectedTabIndex];
//   }

//   Widget _buildNavTab({
//     required IconData icon,
//     required String label,
//     required int index,
//   }) {
//     final isSelected = selectedTabIndex == index;
//     return GestureDetector(
//       onTap: () => _onTabChanged(index),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? primaryBlue : Colors.transparent,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               icon,
//               color: isSelected ? Colors.white : Colors.grey[600],
//               size: 22,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: TextStyle(
//                 color: isSelected ? Colors.white : Colors.grey[600],
//                 fontSize: 10,
//                 fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//               ),
//               textAlign: TextAlign.center,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFilterStatusBar() {
//     int activeFiltersCount = appliedFilters.values
//         .where((value) => value != null && value.toString().isNotEmpty)
//         .length;

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.blue[50],
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.blue[200]!),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             Icons.filter_list,
//             size: 16,
//             color: Colors.blue[800],
//           ),
//           const SizedBox(width: 8),
//           Text(
//             '$activeFiltersCount filter${activeFiltersCount != 1 ? 's' : ''} applied',
//             style: TextStyle(
//               color: Colors.blue[800],
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(width: 8),
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 appliedFilters.clear();
//               });
//               _updateInspectionCount();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Filters cleared'),
//                   duration: Duration(seconds: 2),
//                 ),
//               );
//             },
//             child: Container(
//               padding: const EdgeInsets.all(2),
//               decoration: BoxDecoration(
//                 color: Colors.blue[800],
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.close,
//                 size: 12,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Method to refresh data from your APIs
//   Future<void> refreshInspections() async {
//     await _loadAllInspectionData();
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         duration: Duration(seconds: 3),
//       ),
//     );
//   }

//   // Method to add new inspection (called when add button is pressed)
//   void addNewInspection() {
//     // Navigate to add inspection screen or show dialog
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Add new inspection - Implement navigation'),
//         action: SnackBarAction(
//           label: 'Refresh',
//           onPressed: refreshInspections,
//         ),
//       ),
//     );
//   }
// }

// // Custom widget for General Inspection Tab with callback
// class GeneralInspectionTabWithCallback extends StatelessWidget {
//   final List<Map<String, dynamic>> issuedByMeInspections;
//   final List<Map<String, dynamic>> markedToMeInspections;
//   final List<Map<String, dynamic>> forwardedToMeInspections;
//   final int selectedSubTabIndex;
//   final Function(int) onSubTabChanged;
//   final String searchQuery;
//   final Map<String, dynamic> appliedFilters;

//   const GeneralInspectionTabWithCallback({
//     Key? key,
//     required this.issuedByMeInspections,
//     required this.markedToMeInspections,
//     required this.forwardedToMeInspections,
//     required this.selectedSubTabIndex,
//     required this.onSubTabChanged,
//     required this.searchQuery,
//     required this.appliedFilters,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GeneralInspectionTab(
//       onSubTabChanged: onSubTabChanged,
//     );
//   }
// }






import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/drawer/hamburger_menu.dart';
import '../components/profile/profile_screen.dart';
import '../components/dashboard_tabs/filter_button.dart';
import '../components/dashboard_tabs/all_tab.dart';
import '../components/dashboard_tabs/mom_tab.dart';
import '../components/dashboard_tabs/field_inspection_tab.dart';
import '../components/dashboard_tabs/general_inspection_tab.dart';
import '../constants/colors.dart';

class RailwayDashboard extends StatefulWidget {
  final int? userId; // Optional parameter to pass userId
  
  const RailwayDashboard({super.key, this.userId});

  @override
  State<RailwayDashboard> createState() => _RailwayDashboardState();
}

class _RailwayDashboardState extends State<RailwayDashboard>
    with TickerProviderStateMixin {
  int selectedTabIndex = 0; // 0: MOM, 1: Field Inspection, 2: General Inspection
  Map<String, dynamic> appliedFilters = {};
  String searchQuery = '';
  
  // Dynamic inspection count
  int currentInspectionCount = 0;
  
  // Separate data for each inspection type
  List<Map<String, dynamic>> allInspections = [];
  List<Map<String, dynamic>> momInspections = [];
  List<Map<String, dynamic>> fieldInspections = [];
  
  // General inspection sub-categories
  List<Map<String, dynamic>> issuedByMeInspections = [];
  List<Map<String, dynamic>> markedToMeInspections = [];
  List<Map<String, dynamic>> forwardedToMeInspections = [];
  
  bool isLoading = true;
  int? userId; // Dynamic user ID - will be set in initState

  // Track which general inspection sub-tab is selected (for nested tabs in GeneralInspectionTab)
  int selectedGeneralTabIndex = 0; // 0: Marked to Me, 1: Issued by Me, 2: Forwarded to Me

  final List<Widget> tabViews = const [
    MOMTab(),
    FieldInspectionTab(),
    GeneralInspectionTab(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeUserId();
  }

  // Initialize userId from widget parameter or SharedPreferences
  Future<void> _initializeUserId() async {
    try {
      if (widget.userId != null) {
        // Use userId passed from widget
        userId = widget.userId;
        print('Using userId from widget: $userId');
      } else {
        // Try to get from SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        userId = prefs.getInt('user_id');
        print('Loaded userId from SharedPreferences: $userId');
      }

      // If still no userId, show error
      if (userId == null) {
        _showErrorSnackBar('User ID not found. Please login again.');
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Load data after userId is set
      await _loadAllInspectionData();
    } catch (e) {
      print('Error initializing userId: $e');
      _showErrorSnackBar('Error initializing user: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Load all inspection data from your APIs
  Future<void> _loadAllInspectionData() async {
    if (userId == null) {
      _showErrorSnackBar('User ID not found');
      return;
    }

    setState(() {
      isLoading = true;
    });
    
    try {
      // Load data from all your API endpoints with individual error handling
      await Future.wait([
        _fetchIssuedByMeInspections(),
        _fetchMarkedToMeInspections(), 
        _fetchForwardedToMeInspections(),
        _fetchFieldInspections(),
        _fetchMOMInspections(),
      ]);
      
      // Combine all inspections for "All" tab
      _combineAllInspections();
      
      setState(() {
        isLoading = false;
      });
      _updateInspectionCount();
      
      print('All inspections loaded successfully for user $userId');
      
    } catch (e) {
      print('Error loading inspections: $e');
      setState(() {
        isLoading = false;
      });
      // Don't show error snackbar for individual API failures, only for complete failure
      if (allInspections.isEmpty) {
        _showErrorSnackBar('Failed to load inspections. Please check your connection.');
      }
    }
  }

  // Fetch Issued By Me Inspections
  Future<void> _fetchIssuedByMeInspections() async {
    if (userId == null) return;
    
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/field-inspections/?user_id=$userId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));

      print('Issued by me API response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          List<dynamic> rawInspections = responseData['data']?['inspections'] ?? [];
          setState(() {
            issuedByMeInspections = rawInspections.map((inspection) {
              Map<String, dynamic> inspectionMap = Map<String, dynamic>.from(inspection);
              inspectionMap['type'] = 'issued_by_me';
              return inspectionMap;
            }).toList();
          });
          print('Issued by me inspections loaded for user $userId: ${issuedByMeInspections.length}');
        } else {
          print('Issued by me API returned success: false');
          setState(() {
            issuedByMeInspections = [];
          });
        }
      } else {
        print('Issued by me API error: ${response.statusCode} - ${response.body}');
        setState(() {
          issuedByMeInspections = [];
        });
      }
    } catch (e) {
      print('Error fetching issued by me inspections: $e');
      setState(() {
        issuedByMeInspections = [];
      });
    }
  }

  // Fetch Marked To Me Inspections
  Future<void> _fetchMarkedToMeInspections() async {
    if (userId == null) return;
    
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/marked-to-me/?user_id=$userId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));

      print('Marked to me API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          List<dynamic> rawInspections = responseData['inspections'] ?? [];
          setState(() {
            markedToMeInspections = rawInspections.map((inspection) {
              Map<String, dynamic> inspectionMap = Map<String, dynamic>.from(inspection);
              inspectionMap['type'] = 'marked_to_me';
              return inspectionMap;
            }).toList();
          });
          print('Marked to me inspections loaded for user $userId: ${markedToMeInspections.length}');
        } else {
          print('Marked to me API returned success: false');
          setState(() {
            markedToMeInspections = [];
          });
        }
      } else {
        print('Marked to me API error: ${response.statusCode} - ${response.body}');
        setState(() {
          markedToMeInspections = [];
        });
      }
    } catch (e) {
      print('Error fetching marked to me inspections: $e');
      setState(() {
        markedToMeInspections = [];
      });
    }
  }

  // Fetch Forwarded To Me Inspections
  Future<void> _fetchForwardedToMeInspections() async {
    if (userId == null) return;
    
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/forwarded-to-me/?user_id=$userId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));

      print('Forwarded to me API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          List<dynamic> rawInspections = responseData['inspections'] ?? [];
          setState(() {
            forwardedToMeInspections = rawInspections.map((inspection) {
              Map<String, dynamic> inspectionMap = Map<String, dynamic>.from(inspection);
              inspectionMap['type'] = 'forwarded_to_me';
              return inspectionMap;
            }).toList();
          });
          print('Forwarded to me inspections loaded for user $userId: ${forwardedToMeInspections.length}');
        } else {
          print('Forwarded to me API returned success: false');
          setState(() {
            forwardedToMeInspections = [];
          });
        }
      } else {
        print('Forwarded to me API error: ${response.statusCode} - ${response.body}');
        setState(() {
          forwardedToMeInspections = [];
        });
      }
    } catch (e) {
      print('Error fetching forwarded to me inspections: $e');
      setState(() {
        forwardedToMeInspections = [];
      });
    }
  }

  // Fetch Field Inspections
  Future<void> _fetchFieldInspections() async {
    if (userId == null) return;
    
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/field-inspections-list/?user_id=$userId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));

      print('Field inspections API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          List<dynamic> rawInspections = responseData['data']?['inspections'] ?? [];
          setState(() {
            fieldInspections = rawInspections.map((inspection) {
              Map<String, dynamic> inspectionMap = Map<String, dynamic>.from(inspection);
              inspectionMap['type'] = 'field';
              return inspectionMap;
            }).toList();
          });
          print('Field inspections loaded for user $userId: ${fieldInspections.length}');
        } else {
          print('Field inspections API returned success: false');
          setState(() {
            fieldInspections = [];
          });
        }
      } else {
        print('Field inspections API error: ${response.statusCode} - ${response.body}');
        setState(() {
          fieldInspections = [];
        });
      }
    } catch (e) {
      print('Error fetching field inspections: $e');
      setState(() {
        fieldInspections = [];
      });
    }
  }

  // Fetch MOM Inspections
  Future<void> _fetchMOMInspections() async {
    if (userId == null) return;
    
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8000/api/mom-inspections/?user_id=$userId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 10));

      print('MOM inspections API response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          List<dynamic> rawInspections = responseData['data']?['inspections'] ?? [];
          setState(() {
            momInspections = rawInspections.map((inspection) {
              Map<String, dynamic> inspectionMap = Map<String, dynamic>.from(inspection);
              inspectionMap['type'] = 'mom';
              return inspectionMap;
            }).toList();
          });
          print('MOM inspections loaded for user $userId: ${momInspections.length}');
        } else {
          print('MOM inspections API returned success: false');
          setState(() {
            momInspections = [];
          });
        }
      } else {
        print('MOM inspections API error: ${response.statusCode} - ${response.body}');
        setState(() {
          momInspections = [];
        });
      }
    } catch (e) {
      print('Error fetching MOM inspections: $e');
      setState(() {
        momInspections = [];
      });
    }
  }

  // Combine all inspection types
  void _combineAllInspections() {
    allInspections = [
      ...issuedByMeInspections,
      ...markedToMeInspections,
      ...forwardedToMeInspections,
      ...fieldInspections,
      ...momInspections,
    ];
    print('All inspections combined for user $userId: ${allInspections.length}');
  }

  void _updateInspectionCount() {
    List<Map<String, dynamic>> filteredInspections = _getFilteredInspections();
    setState(() {
      currentInspectionCount = filteredInspections.length;
    });
    print('Updated inspection count: $currentInspectionCount for tab: $selectedTabIndex');
  }

  List<Map<String, dynamic>> _getFilteredInspections() {
    List<Map<String, dynamic>> filtered = [];

    // Filter by current main tab
    switch (selectedTabIndex) {
      case 0: // MOM Tab
        filtered = List<Map<String, dynamic>>.from(momInspections);
        break;
      case 1: // Field Inspection Tab
        filtered = List<Map<String, dynamic>>.from(fieldInspections);
        break;
      case 2: // General Inspection Tab
        // For General Inspection, filter by sub-tab
        switch (selectedGeneralTabIndex) {
          case 0: // Marked to Me
            filtered = List<Map<String, dynamic>>.from(markedToMeInspections);
            break;
          case 1: // Issued by Me
            filtered = List<Map<String, dynamic>>.from(issuedByMeInspections);
            break;
          case 2: // Forwarded to Me
            filtered = List<Map<String, dynamic>>.from(forwardedToMeInspections);
            break;
          default:
            filtered = List<Map<String, dynamic>>.from(markedToMeInspections);
        }
        break;
    }

    print('Base filtered count: ${filtered.length} for tab: $selectedTabIndex, generalTab: $selectedGeneralTabIndex');

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((inspection) {
        final title = inspection['inspection_title']?.toString().toLowerCase() ?? '';
        final inspectionNo = inspection['inspection_no']?.toString().toLowerCase() ?? '';
        final officerName = inspection['officer_name']?.toString().toLowerCase() ?? '';
        final stationName = inspection['station_name']?.toString().toLowerCase() ?? '';
        
        return title.contains(searchQuery.toLowerCase()) ||
               inspectionNo.contains(searchQuery.toLowerCase()) ||
               officerName.contains(searchQuery.toLowerCase()) ||
               stationName.contains(searchQuery.toLowerCase());
      }).toList();
    }

    // Apply additional filters
    if (appliedFilters.isNotEmpty) {
      // Filter by status
      if (appliedFilters['status'] != null && appliedFilters['status'].isNotEmpty) {
        filtered = filtered.where((inspection) {
          return inspection['status']?.toString().toLowerCase() == 
                 appliedFilters['status'].toString().toLowerCase();
        }).toList();
      }

      // Filter by date range
      if (appliedFilters['dateFrom'] != null && appliedFilters['dateTo'] != null) {
        filtered = filtered.where((inspection) {
          try {
            String dateField = inspection['start_date'] ?? inspection['inspected_on'] ?? '';
            if (dateField.isNotEmpty) {
              DateTime inspectionDate = DateTime.parse(dateField);
              DateTime fromDate = DateTime.parse(appliedFilters['dateFrom']);
              DateTime toDate = DateTime.parse(appliedFilters['dateTo']);
              return inspectionDate.isAfter(fromDate.subtract(Duration(days: 1))) &&
                     inspectionDate.isBefore(toDate.add(Duration(days: 1)));
            }
            return false;
          } catch (e) {
            return false;
          }
        }).toList();
      }

      // Filter by officer name
      if (appliedFilters['officer'] != null && appliedFilters['officer'].isNotEmpty) {
        filtered = filtered.where((inspection) {
          return inspection['officer_name']?.toString().toLowerCase()
                 .contains(appliedFilters['officer'].toString().toLowerCase()) ?? false;
        }).toList();
      }

      // Filter by station
      if (appliedFilters['station'] != null && appliedFilters['station'].isNotEmpty) {
        filtered = filtered.where((inspection) {
          return inspection['station_name']?.toString().toLowerCase()
                 .contains(appliedFilters['station'].toString().toLowerCase()) ?? false;
        }).toList();
      }
    }

    print('Final filtered count: ${filtered.length}');
    return filtered;
  }

  void _onFiltersApplied(Map<String, dynamic> filters) {
    setState(() {
      appliedFilters = filters;
    });
    
    // Update count after filters are applied
    _updateInspectionCount();
    
    print('Applied Filters in Dashboard: $filters');
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
    });
    
    // Update count after search query changes
    _updateInspectionCount();
  }

  void _onTabChanged(int index) {
    setState(() {
      selectedTabIndex = index;
      // Reset general tab index when switching away from general tab
      if (index != 2) {
        selectedGeneralTabIndex = 0;
      }
    });
    
    // Update count when tab changes
    _updateInspectionCount();
  }

  // Add this method to handle general inspection sub-tab changes
  void _onGeneralTabChanged(int index) {
    setState(() {
      selectedGeneralTabIndex = index;
    });
    
    // Update count when general sub-tab changes
    _updateInspectionCount();
    
    print('General tab changed to: $index');
  }

  // Method to get current inspection data for the selected tab
  List<Map<String, dynamic>> getCurrentInspectionData() {
    return _getFilteredInspections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HamburgerMenu(),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  const Icon(Icons.train, color: primaryBlue, size: 30),
                  const SizedBox(width: 8),
                  const Text(
                    'E-Inspection',
                    style: TextStyle(
                      fontSize: 20,
                      color: primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add, color: primaryBlue),
                    onPressed: addNewInspection,
                  ),
                  const ProfileScreen(),
                ],
              ),
            ),

            // Search + Dynamic Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search inspections, meetings...',
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(color: primaryBlue),
                        ),
                      ),
                      onChanged: _onSearchChanged,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Dynamic count display
                  Container(
                    width: 45,
                    height: 45,
                    decoration: const BoxDecoration(
                      color: primaryOrange,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$currentInspectionCount', // Dynamic count
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Tabs (Removed Home)
            Container(
              height: 60,
              color: Colors.grey[50],
              child: Row(
                children: [
                  // MOM Tab
                  Expanded(
                    child: _buildNavTab(
                      icon: Icons.meeting_room,
                      label: 'MOM',
                      index: 0,
                    ),
                  ),
                  // Field Inspection Tab
                  Expanded(
                    child: _buildNavTab(
                      icon: Icons.assignment,
                      label: 'Field Inspection',
                      index: 1,
                    ),
                  ),
                  // General Inspection Tab
                  Expanded(
                    child: _buildNavTab(
                      icon: Icons.fact_check,
                      label: 'General Inspection',
                      index: 2,
                    ),
                  ),
                  // Filter Button
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: FilterButton(
                      onFiltersApplied: _onFiltersApplied,
                    ),
                  ),
                ],
              ),
            ),

            // Filter Status Indicator
            if (appliedFilters.isNotEmpty) _buildFilterStatusBar(),

            const SizedBox(height: 8),

            // Tab content with loading state
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: isLoading 
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: primaryBlue),
                          SizedBox(height: 16),
                          Text('Loading inspections...'),
                        ],
                      ),
                    )
                  : _buildTabContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    // For General Inspection tab, we need to pass additional data and callbacks
    if (selectedTabIndex == 2) {
      return GeneralInspectionTabWithCallback(
        issuedByMeInspections: issuedByMeInspections,
        markedToMeInspections: markedToMeInspections,
        forwardedToMeInspections: forwardedToMeInspections,
        selectedSubTabIndex: selectedGeneralTabIndex,
        onSubTabChanged: _onGeneralTabChanged,
        searchQuery: searchQuery,
        appliedFilters: appliedFilters,
      );
    }
    
    return tabViews[selectedTabIndex];
  }

  Widget _buildNavTab({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = selectedTabIndex == index;
    return GestureDetector(
      onTap: () => _onTabChanged(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterStatusBar() {
    int activeFiltersCount = appliedFilters.values
        .where((value) => value != null && value.toString().isNotEmpty)
        .length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.filter_list,
            size: 16,
            color: Colors.blue[800],
          ),
          const SizedBox(width: 8),
          Text(
            '$activeFiltersCount filter${activeFiltersCount != 1 ? 's' : ''} applied',
            style: TextStyle(
              color: Colors.blue[800],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                appliedFilters.clear();
              });
              _updateInspectionCount();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filters cleared'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.blue[800],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to refresh data from your APIs
  Future<void> refreshInspections() async {
    await _loadAllInspectionData();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Method to add new inspection (called when add button is pressed)
  void addNewInspection() {
    // Navigate to add inspection screen or show dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Add new inspection - Implement navigation'),
        action: SnackBarAction(
          label: 'Refresh',
          onPressed: refreshInspections,
        ),
      ),
    );
  }
}

// Custom widget for General Inspection Tab with callback
class GeneralInspectionTabWithCallback extends StatelessWidget {
  final List<Map<String, dynamic>> issuedByMeInspections;
  final List<Map<String, dynamic>> markedToMeInspections;
  final List<Map<String, dynamic>> forwardedToMeInspections;
  final int selectedSubTabIndex;
  final Function(int) onSubTabChanged;
  final String searchQuery;
  final Map<String, dynamic> appliedFilters;

  const GeneralInspectionTabWithCallback({
    Key? key,
    required this.issuedByMeInspections,
    required this.markedToMeInspections,
    required this.forwardedToMeInspections,
    required this.selectedSubTabIndex,
    required this.onSubTabChanged,
    required this.searchQuery,
    required this.appliedFilters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GeneralInspectionTab(
      onSubTabChanged: onSubTabChanged,
    );
  }
}
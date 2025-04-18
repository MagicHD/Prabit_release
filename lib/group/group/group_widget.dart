import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/group/discover_group/discover_group_widget.dart';
import '/group/existing_group/existing_group_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'group_model.dart';
export 'group_model.dart';

/// The group screen of the Prabit app is designed to help users effortlessly
/// manage their current group memberships and discover new communities.
///
/// The screen’s layout is structured, user-centric, and visually consistent
/// with the rest of the app’s dark mode aesthetic. It emphasizes clarity,
/// social engagement, and accessibility. At the top of the screen, the title
/// “Groups” is displayed in bold white text, aligned to the left. To the
/// right is a search icon, allowing users to quickly find specific groups.
/// This sets the stage for both browsing and targeted discovery. My Groups
/// The first section, labeled “My Groups”, displays the user’s current group
/// memberships in a vertically stacked list. Each group is encapsulated in a
/// rounded rectangular card with a dark blue background and colored icon
/// representing the group’s identity. Each card includes: A group icon in a
/// colored circular background (blue, purple, green) representing the group’s
/// theme or category. The group name in bold white text (e.g., “Morning
/// Fitness Club”). A small label below the name showing: The group type
/// (Public or Private) with an accompanying icon. The number of members in
/// gray text with a member icon. A chevron arrow on the right side indicates
/// that the user can tap to view more details or manage the group. The clear
/// visual hierarchy and use of spacing make each card easy to scan and
/// distinguish, even at a glance. Discover Groups The second section, titled
/// “Discover Groups”, highlights suggested or popular public groups that the
/// user hasn’t joined yet. These cards follow the same design principles as
/// the ones in “My Groups,” but with the addition of a “Join” button on the
/// right side of each card. Each group card in this section includes: A
/// colored icon (e.g., red, orange, teal) for category identity. The group
/// name, type (always public), and member count. A vibrant blue “Join” button
/// that stands out against the dark background, inviting immediate
/// interaction. Floating Action Button In the bottom-right corner of the
/// screen, there is a prominent floating action button (FAB)—a bright blue
/// circle with a white plus icon. This button is used to create a new group,
/// and it follows mobile UI best practices for initiating primary actions.
/// Summary The group screen in Prabit is optimized for both engagement and
/// exploration. It visually separates joined and available groups, provides
/// clear metadata on each group, and makes key actions like joining or
/// creating a group immediately accessible. The use of bold iconography,
/// colored tags, and responsive design elements within a dark interface makes
/// this screen approachable, social, and effective.
class GroupWidget extends StatefulWidget {
  const GroupWidget({super.key});

  static String routeName = 'group';
  static String routePath = '/group';

  @override
  State<GroupWidget> createState() => _GroupWidgetState();
}

class _GroupWidgetState extends State<GroupWidget> {
  late GroupModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? ''; // Get current user ID

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GroupModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    _fetchUserGroups();
    _model.textController!.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _model.textController!.removeListener(_onSearchChanged); // <-- Add listener removal
    _model.debounceTimer?.cancel(); // <-- Add timer cancellation
    _model.dispose();
    super.dispose();
  }

  // --- Debounce search input ---
  void _onSearchChanged() {
    // Cancel any existing timer
    if (_model.debounceTimer?.isActive ?? false) _model.debounceTimer!.cancel();

    // Start a new timer
    _model.debounceTimer = Timer(const Duration(milliseconds: 500), () {
      // Check if the text has actually changed to avoid unnecessary fetches
      if (_model.searchQuery != _model.textController!.text) {
        setState(() {
          // Update the search query in the model
          _model.searchQuery = _model.textController!.text;
        });
        // Trigger the search fetch
        _fetchSearchResults();
      }
    });
  }
  // --- Widget Builder for Default View (My Groups & Discover) ---
  Widget _buildDefaultGroupLists() {
    final theme = FlutterFlowTheme.of(context);
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // --- My Groups Section ---
        Text('My Groups', style: theme.titleLarge),
        SizedBox(height: 12.0),
        _model.isLoadingMyGroups
            ? Padding( padding: const EdgeInsets.symmetric(vertical: 20.0), child: Center(child: CircularProgressIndicator()),)
            : _model.userGroups.isEmpty
            ? Padding( padding: const EdgeInsets.symmetric(vertical: 20.0), child: Center( child: Text('You haven\'t joined any groups yet.', style: theme.bodyMedium,),),)
            : Column(
          mainAxisSize: MainAxisSize.min,
          // ** CORRECTED NAVIGATION PLACEMENT **
          children: _model.userGroups.map((group) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: GestureDetector( // <-- Wrap with GestureDetector
                onTap: () { // <-- Implement onTap
                  context.pushNamed( // <-- Navigation inside onTap
                    GroupChatWidget.routeName,
                    queryParameters: {
                      'groupId': group['groupId'], // Use group map
                      'groupName': group['groupName'],
                      'groupImageUrl': group['groupImageUrl'],
                    }.withoutNulls,
                  );
                },
                child: ExistingGroupWidget( // The card
                  groupname: group['groupName'],
                  membercount: group['memberCount'],
                  groupImageUrl: group['groupImageUrl'], // Pass image URL
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 24.0),

        // --- Discover Groups Section ---
        // Keep this section as it was unless you want to make it dynamic
        Text('Discover Groups', style: theme.titleLarge,),
        SizedBox(height: 12.0),
        // Add your DiscoverGroupWidget instances here (or fetch dynamically)
        // Example: DiscoverGroupWidget(), SizedBox(height: 12), DiscoverGroupWidget(),

        SizedBox(height: 80), // Padding for FAB
      ],
    );
  }

  // --- Widget Builder for Search Results View ---
  Widget _buildSearchResultsList() {
    final theme = FlutterFlowTheme.of(context);
    if (_model.isLoadingSearchResults) { return Center(child: CircularProgressIndicator()); }
    if (_model.searchResults.isEmpty && _model.searchQuery.trim().isNotEmpty) { return Center( child: Text('No groups found matching "${_model.searchQuery}"', textAlign: TextAlign.center, style: theme.bodyMedium,),); }
    // Don't show anything if search is empty and not loading
    if (_model.searchQuery.trim().isEmpty) { return Container(); }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: _model.searchResults.length,
      itemBuilder: (context, index) {
        final group = _model.searchResults[index];
        // ** CORRECTED NAVIGATION PLACEMENT **
        return GestureDetector( // <-- Wrap with GestureDetector
          onTap: () { // <-- Implement onTap
            context.pushNamed( // <-- Navigation inside onTap
              GroupChatWidget.routeName,
              queryParameters: {
                'groupId': group['groupId'], // Use group map
                'groupName': group['groupName'],
                'groupImageUrl': group['groupImageUrl'],
              }.withoutNulls,
            );
          },
          child: ExistingGroupWidget( // The card
            groupname: group['groupName'],
            membercount: group['memberCount'],
            groupImageUrl: group['groupImageUrl'], // Pass image URL
            // TODO: Add logic here or inside ExistingGroupWidget to show a "Join" button
            // if group['isMember'] is false and group['groupType'] allows joining.
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 12.0),
    );
  }


  // --- Fetch Search Results ---
  // Replace the existing _fetchSearchResults function with this one

// --- Fetch Search Results (with Group Code Logic) ---
  Future<void> _fetchSearchResults() async {
    final query = _model.searchQuery.trim(); // Use trimmed query
    final queryLower = query.toLowerCase(); // Lowercase for name search

    if (query.isEmpty) {
      if (mounted) {
        setState(() {
          _model.searchResults = [];
          _model.isLoadingSearchResults = false;
          _model.isSearching = false;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _model.isLoadingSearchResults = true;
        _model.isSearching = true;
      });
    }

    try {
      QuerySnapshot querySnapshot;
      bool searchedByCode = false; // Flag to know if we already got results by code

      // Check if the query looks like a group code (e.g., length 8) [cite: 110]
      // *** Adjust the length check (e.g., == 8) if your group codes have a different fixed length ***
      if (query.length == 8) {
        print('Searching by group code: $query'); // Debugging print
        querySnapshot = await FirebaseFirestore.instance
            .collection('groups')
            .where('groupCode', isEqualTo: query) // Query by groupCode field [cite: 110]
            .get();
        searchedByCode = true;
      } else {
        // Otherwise, search by name.
        // Option 1: Fetch all and filter (less efficient, as previously implemented)
        // querySnapshot = await FirebaseFirestore.instance.collection('groups').get();

        // Option 2: Fetch only public groups like group_screen.txt (more efficient for name search) [cite: 111]
        // Requires 'groupType' field to be correctly set on your documents.
        print('Searching public groups by name containing: $queryLower'); // Debugging print
        querySnapshot = await FirebaseFirestore.instance
            .collection('groups')
            .where('groupType', whereIn: ['Public - Instant Join', 'Public - Request & Admin Approval']) // Adjust types if needed [cite: 111]
            .get(); // We will filter by name client-side after this initial fetch
      }

      // Process the snapshot results
      List<Map<String, dynamic>> results = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        // Ensure you retrieve 'groupCode' if you need it later (e.g., for display)
        return {
          'groupId': doc.id,
          'groupName': data['groupName'] ?? 'Unnamed Group',
          'groupImageUrl': data['groupImageUrl'],
          'groupType': data['groupType'] ?? 'Unknown',
          'memberCount': (data['members'] as List?)?.length.toString() ?? '0',
          'isMember': (data['members'] as List?)?.contains(currentUserId) ?? false,
          'groupCode': data['groupCode'], // Include group code in the map
        };
      }).toList(); // Use toList() here

      // If we didn't search by code initially, filter the public groups by name client-side [cite: 113]
      if (!searchedByCode) {
        results = results.where((group) =>
            group['groupName'].toLowerCase().contains(queryLower)
        ).toList();
      }


      if (mounted) {
        setState(() {
          _model.searchResults = results; // Update results
          _model.isLoadingSearchResults = false;
        });
      }
    } catch (e) {
      print('Error fetching search results: $e');
      if (mounted) {
        setState(() {
          _model.searchResults = [];
          _model.isLoadingSearchResults = false;
        });
        // Optionally show an error message
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error searching groups.')),
        // );
      }
    }
  }

  // Add this function within your _GroupWidgetState class
  // --- Fetch User's Groups ---
  Future<void> _fetchUserGroups() async {
    // Ensure currentUserId is available (it's already defined in your class)
    if (currentUserId.isEmpty) {
      if (mounted) { // Check if the widget is still mounted before calling setState
        setState(() => _model.isLoadingMyGroups = false);
      }
      return;
    }

    // Set loading state to true before fetching
    if (mounted) {
      setState(() => _model.isLoadingMyGroups = true);
    }

    try {
      final userGroupsSnapshot = await FirebaseFirestore.instance
          .collection('groups') // Your main groups collection
          .where('members', arrayContains: currentUserId)
          .get();

      // Process the documents into a list of maps
      final groups = userGroupsSnapshot.docs.map((doc) {
        final data = doc.data();
        // Calculate member count safely
        final membersList = data['members'] as List?;
        final memberCount = membersList?.length.toString() ?? '0';

        return {
          'groupId': doc.id,
          'groupName': data['groupName'] ?? 'Unnamed Group',
          'groupImageUrl': data['groupImageUrl'], // Will be null if not present
          'groupType': data['groupType'] ?? 'Unknown',
          'memberCount': memberCount, // Use calculated member count
          'isMember': true, // User is part of this group
        };
      }).toList();

      // Update the model state if the widget is still mounted
      if (mounted) {
        setState(() {
          _model.userGroups = groups;
          _model.isLoadingMyGroups = false; // Set loading to false
        });
      }
    } catch (e) {
      print('Error fetching user groups: $e');
      if (mounted) {
        setState(() => _model.isLoadingMyGroups = false); // Ensure loading stops on error
        // Optionally show an error message
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Error loading your groups.')),
        // );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primary,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            context.pushNamed(GroupCreation2Widget.routeName);
          },
          backgroundColor: FlutterFlowTheme.of(context).buttonBackground,
          elevation: 3.0,
          child: Icon(
            Icons.add,
            color: FlutterFlowTheme.of(context).buttonText,
            size: 24.0,
          ),
        ),
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            FFLocalizations.of(context).getText(
              'n29bio07' /* Groups */,
            ),
            style: FlutterFlowTheme.of(context).displaySmall.override(
                  fontFamily: FlutterFlowTheme.of(context).displaySmallFamily,
                  letterSpacing: 0.0,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                      FlutterFlowTheme.of(context).displaySmallFamily),
                ),
          ),
          actions: [
            Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: FlutterFlowIconButton(
                  borderRadius: 40.0,
                  buttonSize: 40.0,
                  // --- CHANGE ICON HERE ---
                  icon: Icon(
                    _model.showSearch ? Icons.close : Icons.search_rounded, // Toggle icon
                    color: Colors.white,
                    size: 24.0,
                  ),
                  // --- REPLACE onPressed HERE ---
                  onPressed: () async { // Keep async if needed for other reasons
                    setState(() {
                      _model.showSearch = !_model.showSearch;
                      if (!_model.showSearch) {
                        // --- START: Modify this block ---
                        _model.textController?.clear(); // Clear the text field
                        _model.searchQuery = '';       // Clear the query state
                        _model.searchResults = [];   // Clear previous results
                        _model.isSearching = false;    // Reset searching flag
                        _model.isLoadingSearchResults = false; // Reset loading flag
                        FocusScope.of(context).unfocus(); // Unfocus keyboard
                        // --- END: Modify this block ---
                      } else {
                        _model.textFieldFocusNode?.requestFocus(); // Request focus when opening
                      }
                    });
                  },
                ),
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Container( // Keep outer Container if needed for background color/decoration
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground, // Use your theme background
            ),
            child: Padding( // Keep Padding if needed for overall screen padding
              padding: EdgeInsets.all(16.0),
              child: Column( // Use Column as the main layout element
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Search Bar (Conditionally Visible) ---
                  if (_model.showSearch)
                    Padding(
                      // Use padding consistent with your previous search bar style
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                      child: TextFormField(
                        controller: _model.textController,
                        focusNode: _model.textFieldFocusNode,
                        // onChanged is handled by the listener now
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: "Search all groups by name...", // Updated hint text
                          hintStyle: FlutterFlowTheme.of(context).labelMedium,
                          prefixIcon: Icon(
                            Icons.search,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                          contentPadding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium,
                        cursorColor: FlutterFlowTheme.of(context).primary,
                      ),
                    ),

                  // --- Content Area (Conditionally Shows Search Results or Default Lists) ---
                  Expanded( // Use Expanded to make the list area fill remaining space
                    child: _model.isSearching // Check if we are in search mode (query entered or loading results)
                        ? _buildSearchResultsList() // Show search results list
                        : _buildDefaultGroupLists(), // Show default My Groups / Discover
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Color _getGroupColorFromName(String name) {
    final colors = [
      Color(0xFF3B82F6), Color(0xFF9333EA), Color(0xFF22C55E),
      Color(0xFFEA580C), Color(0xFFDC2626), Color(0xFF0D9488),
      Color(0xFFF43F5E), Color(0xFF0D6DFD),
      // Add more colors if needed
    ];
    // Use hashCode for simple distribution, ensure colors list is not empty
    return colors.isNotEmpty ? colors[name.hashCode % colors.length] : Colors.grey;
  }

} //


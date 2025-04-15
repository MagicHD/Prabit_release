import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart'; // Assuming this imports HabitSelectionScreenWidget routeName
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'statistics_screen_model.dart';
export 'statistics_screen_model.dart';

class StatisticsScreenWidget extends StatefulWidget {
  const StatisticsScreenWidget({super.key});

  static String routeName = 'statistics_screen';
  static String routePath = '/statisticsScreen';

  @override
  State<StatisticsScreenWidget> createState() => _StatisticsScreenWidgetState();
}

// Added TickerProviderStateMixin for TabController
class _StatisticsScreenWidgetState extends State<StatisticsScreenWidget> with TickerProviderStateMixin {
  late StatisticsScreenModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Tab Controller
  late TabController _tabController; // Added

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, int> _categoryData = {};
  int _totalPostsAmount = 0;
  bool _isLoading = true;
  int _currentStreak = 0;
  int _highestStreak = 0;
  int _totalGroupAmount = 0; // Fetched, but not displayed in group card yet


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StatisticsScreenModel());
    // Initialize TabController
    _tabController = TabController(length: 2, vsync: this); // Added (2 tabs)
    _fetchStats();
    // Optional: Add listener if needed beyond TabBarView synchronization
    // _tabController.addListener(_handleTabSelection);
  }

  // Optional: Handle tab selection if needed for more complex logic
  // void _handleTabSelection() {
  //   if (_tabController.indexIsChanging) {
  //     print("Selected tab index: ${_tabController.index}");
  //     // TODO: Potentially trigger data refetch here based on index
  //     // Example: _fetchStats(timePeriod: _tabController.index == 0 ? 'week' : 'month');
  //   }
  // }


  // TODO: Modify _fetchStats or create new methods to fetch data based on time period
  // Currently fetches all-time data regardless of tab selection.
  Future<void> _fetchStats({String timePeriod = 'all'}) async {
    // Ensure widget is still mounted before updating state
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('DEBUG: User not authenticated.');
        _totalPostsAmount = 0;
        _currentStreak = 0;
        _highestStreak = 0;
        _totalGroupAmount = 0;
        _categoryData = {};
        return;
      }

      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data()!;
        _totalPostsAmount = (userData['totalPostsAmount'] as int?) ?? 0;
        _currentStreak = (userData['streak'] as int?) ?? 0;
        _highestStreak = (userData['highestStreak'] as int?) ?? 0;
        // Assuming Firestore field name matches the variable name exactly. Change if needed.
        _totalGroupAmount = (userData['totalGroupAmount'] as int?) ?? 0; // Corrected field name assumption

        // --- Category Data Fetching ---
        // TODO: This needs modification for time-based filtering (week/month).
        // Currently fetches all category shares. You'd need timestamps on habit completions
        // and query the completions within the 'timePeriod', then aggregate counts.
        // For now, it fetches all categories regardless of the 'timePeriod' parameter.
        final categorySharesCollection = _firestore
            .collection('users')
            .doc(user.uid)
            .collection('categoryShares'); // This collection likely holds *all-time* counts
        final querySnapshot = await categorySharesCollection.get();
        final categories = querySnapshot.docs;

        final fetchedCategoryData = <String, int>{};
        for (var doc in categories) {
          if (doc.data().containsKey('count') && doc.data()['count'] is int) {
            fetchedCategoryData[doc.id] = doc.data()['count'] as int;
          } else {
            fetchedCategoryData[doc.id] = 0;
          }
        }
        _categoryData = fetchedCategoryData;
        // --- End of Category Data Fetching ---

        print('DEBUG: Total posts amount: $_totalPostsAmount');
        print('DEBUG: Current Streak: $_currentStreak');
        print('DEBUG: Highest Streak: $_highestStreak');
        print('DEBUG: Total Group Amount: $_totalGroupAmount');
        print('DEBUG: Category data: $_categoryData');
      } else {
        print('DEBUG: User document does not exist.');
        _totalPostsAmount = 0;
        _currentStreak = 0;
        _highestStreak = 0;
        _totalGroupAmount = 0;
        _categoryData = {};
      }
    } catch (e) {
      print('DEBUG: Error fetching stats: $e');
      _totalPostsAmount = 0;
      _currentStreak = 0;
      _highestStreak = 0;
      _totalGroupAmount = 0;
      _categoryData = {};
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // TODO: Modify _generatePieChartSections to accept filtered data if needed
  List<PieChartSectionData> _generatePieChartSections(/* Potentially pass filtered data here */) {
    final List<PieChartSectionData> sections = [];
    // Use the state's _categoryData and _totalPostsAmount for now
    final currentCategoryData = _categoryData;
    final currentTotal = _totalPostsAmount; // TODO: This total should ideally reflect the selected time period

    if (currentTotal == 0 || currentCategoryData.isEmpty) return sections;

    currentCategoryData.forEach((category, count) {
      if (count > 0) {
        // TODO: Ensure 'currentTotal' reflects the total for the *selected period*
        final percentage = (count / currentTotal) * 100;

        print('DEBUG (Pie): Category: $category, Count: $count, Percentage: ${percentage.toStringAsFixed(1)}%');

        sections.add(
          PieChartSectionData(
            value: percentage,
            color: _getCategoryColor(category),
            radius: 80,
            showTitle: false, // <--- ADD THIS LINE TO HIDE THE PERCENTAGE

          ),
        );
      }
    });
    return sections;
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'physical': return Color(0xFF3A9BFF);
      case 'mental': return Color(0xFFB23AFF);
      case 'learning': return Color(0xFFFF3A9E);
      case 'social': return Color(0xFF3AC8FF);
      case 'health': return Color(0xFF3AFFEC);
      case 'creativity': return Color(0xFF3AFF7E);
      default:
        final colors = [ Colors.blueGrey, Colors.deepOrange, Colors.indigo, Colors.amber, Colors.cyan, Colors.lime, Colors.pinkAccent, Colors.lightGreen, Colors.brown, ];
        final index = category.hashCode.abs() % colors.length;
        return colors[index];
    }
  }


  @override
  void dispose() {
    _tabController.dispose(); // Dispose TabController
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context); // Get theme once

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF09090B),
        body: SafeArea(
          top: true,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(color: theme.primary),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
              child: _isLoading
                  ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(theme.info)))
                  : SingleChildScrollView( // Make outer column scrollable if content overflows
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Header Section ---
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 24),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlutterFlowIconButton(
                            borderRadius: 20, buttonSize: 40,
                            icon: Icon(Icons.arrow_back_rounded, color: theme.info, size: 24),
                            onPressed: () => context.pushNamed(HabitSelectionScreenWidget.routeName),
                          ),
                          Text( FFLocalizations.of(context).getText('nr1w2zcj') ?? 'Statistics', style: theme.headlineSmall ),
                          SizedBox(width: 40),
                        ],
                      ),
                    ),

                    // --- Stats Grid Section (Unaffected by TabBar) ---
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
                      child: GridView(
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.2, ),
                        primary: false, shrinkWrap: true, scrollDirection: Axis.vertical,
                        children: [
                          _buildStatCard( context: context, icon: Icons.local_fire_department_rounded, iconColor: Color(0xFF3A9BFF), titleKey: 'bqerj86e', titleDefault: 'Current Streak', value: '$_currentStreak', valueColor: Color(0xFF3A9BFF), subtitleKey: 'it1vq0r1', subtitleDefault: 'days in a row', backgroundColor: Color(0xFF0D2E6E), ),
                          _buildStatCard( context: context, icon: Icons.emoji_events_rounded, iconColor: Color(0xFFFF9A3A), titleKey: 'hplt8wwc', titleDefault: 'Longest Streak', value: '$_highestStreak', valueColor: Color(0xFFFF9A3A), subtitleKey: 'titegc7k', subtitleDefault: 'days in a row', backgroundColor: Color(0xFF6E2D0D), hasShadow: true, ),
                          _buildStatCard( context: context, icon: Icons.check_circle_rounded, iconColor: Color(0xFF3AFF7E), titleKey: 'c4k56jkc', titleDefault: 'Total Check-ins', value: '$_totalPostsAmount', valueColor: Color(0xFF3AFF7E), subtitleKey: '3bwwnqxn', subtitleDefault: 'since you started', backgroundColor: Color(0xFF0D6E2D), ),
                          // Use fetched _totalGroupAmount now
                          _buildStatCard( context: context, icon: Icons.group_rounded, iconColor: Color(0xFFB23AFF), titleKey: 'bwnj13gt', titleDefault: 'Group Check-ins', value: '$_totalGroupAmount', valueColor: Color(0xFFC05FFF), subtitleKey: 'afcerjxv', subtitleDefault: 'with friends', backgroundColor: Color(0xFF662F7A), ),
                        ],
                      ),
                    ),

                    // --- Habit Categories Title ---
                    Text( FFLocalizations.of(context).getText('iej2yejz') ?? 'Habit Categories', style: theme.titleLarge.override( fontFamily: theme.titleLargeFamily, color: theme.info, fontWeight: FontWeight.bold, useGoogleFonts: GoogleFonts.asMap().containsKey(theme.titleLargeFamily), ), ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 16),
                      child: Text( FFLocalizations.of(context).getText('fsfl3ixx') ?? 'See which categories your habits fall into', style: theme.labelMedium.override( fontFamily: theme.labelMediumFamily, color: Colors.white70, useGoogleFonts: GoogleFonts.asMap().containsKey(theme.labelMediumFamily), ), ),
                    ),

                    // --- TabBar Section ---
                    Container(
                      // Optional: Add background or decoration if needed
                      // decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(20)),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: FlutterFlowTheme.of(context).primaryText,
                        unselectedLabelColor:
                        FlutterFlowTheme.of(context).secondaryText,
                        labelStyle: FlutterFlowTheme.of(context)
                            .titleLarge
                            .override(
                          fontFamily:
                          FlutterFlowTheme.of(context).titleLargeFamily,
                          letterSpacing: 0.0,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).titleLargeFamily),
                        ),
                        unselectedLabelStyle: FlutterFlowTheme.of(context)
                            .titleMedium
                            .override(
                          fontFamily:
                          FlutterFlowTheme.of(context).titleMediumFamily,
                          letterSpacing: 0.0,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).titleMediumFamily),
                        ),
                        indicatorColor:
                        FlutterFlowTheme.of(context).buttonBackground,
                        indicatorWeight: 3.5,
                        tabs: [
                          Tab(text: FFLocalizations.of(context).getText('al681wub') ?? 'This Week'),
                          Tab(text: FFLocalizations.of(context).getText('fy6s9g93') ?? 'This Month'),
                        ],
                      ),
                    ),

                    // --- TabBarView Section ---
                    // Use an Expanded or SizedBox to give TabBarView a defined height
                    // Adjust height as needed, or use Expanded if within a Column that allows it
                    SizedBox(
                      height: 450, // **IMPORTANT**: Adjust height to fit chart + legend comfortably
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Content for "This Week" Tab
                          _buildChartAndLegendView(context, timePeriod: 'week'),

                          // Content for "This Month" Tab
                          _buildChartAndLegendView(context, timePeriod: 'month'),
                        ],
                      ),
                    ),

                  ], // End of main Column children
                ),
              ), // End of SingleChildScrollView
            ), // End of Padding
          ), // End of Container
        ), // End of SafeArea
      ), // End of Scaffold
    ); // End of GestureDetector
  }

  // --- Helper Widget for Tab Content (Chart + Legend) ---
  Widget _buildChartAndLegendView(BuildContext context, {required String timePeriod}) {
    // TODO: Fetch or filter data specifically for the 'timePeriod' here
    // Currently, it uses the all-time data (_categoryData, _totalPostsAmount)
    final bool hasData = _totalPostsAmount > 0 && _categoryData.isNotEmpty;

    print("Building view for timePeriod: $timePeriod"); // Debug print
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 55, 16, 16), // Padding around chart/legend
      child: !hasData // Use the check derived from current state data
          ? Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Text(
              'No data available for $timePeriod.', // Adjust message
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                color: FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
                useGoogleFonts: GoogleFonts.asMap().containsKey(
                    FlutterFlowTheme.of(context).bodyMediumFamily),
              ),
              textAlign: TextAlign.center,
            ),
          ))
          : Column( // Main column for chart and legend
        mainAxisSize: MainAxisSize.min, // Fit content size
        mainAxisAlignment: MainAxisAlignment.start, // Align top
        children: [
          // --- Pie Chart Widget ---
          SizedBox(
            height: 220, width: 220,
            child: Stack( alignment: Alignment.center, children: [
              PieChart( PieChartData(
                sections: _generatePieChartSections(/* Pass filtered data */),
                centerSpaceRadius: 40, sectionsSpace: 3,
                pieTouchData: PieTouchData(enabled: false),
              )),
            ]),
          ),
          // --- Dynamic Legend ---
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 34, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _categoryData.entries.map((entry) { // TODO: Use filtered data
                final category = entry.key;
                final count = entry.value;
                final color = _getCategoryColor(category);
                if (count > 0) { return _buildLegendItem(context, color, category, count); }
                else { return SizedBox.shrink(); }
              }).toList(),
            ),
          ),
        ], // End Column children
      ), // End Column
    ); // End Padding
  }


  // --- Existing Helper Widgets (Stat Card, Legend Item) ---

  Widget _buildStatCard({ required BuildContext context, required IconData icon, required Color iconColor, required String titleKey, required String titleDefault, required String value, required Color valueColor, required String subtitleKey, required String subtitleDefault, required Color backgroundColor, bool hasShadow = false, }) { /* ... unchanged ... */
    return Container(
      width: double.infinity, // Ensure card fills grid cell width
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: hasShadow
            ? [ BoxShadow( blurRadius: 8, color: Color(0x40000000), offset: Offset(0, 4), ) ]
            : [ BoxShadow( blurRadius: 4, color: Color(0x33000000), offset: Offset(0, 2), ) ], // Default shadow
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon( icon, color: iconColor, size: 24, ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0), // Adjusted padding
                  child: Text( FFLocalizations.of(context).getText( titleKey /* Title */, ) ?? titleDefault,
                    style: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                      color: FlutterFlowTheme.of(context).info,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w600,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
              child: Text( value,
                style: FlutterFlowTheme.of(context).displayMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).displayMediumFamily,
                  color: valueColor,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).displayMediumFamily),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              child: Text( FFLocalizations.of(context).getText( subtitleKey /* Subtitle */, ) ?? subtitleDefault,
                style: FlutterFlowTheme.of(context).labelSmall.override(
                  fontFamily: FlutterFlowTheme.of(context).labelSmallFamily,
                  color: FlutterFlowTheme.of(context).info,
                  letterSpacing: 0.0,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelSmallFamily),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, Color color, String category, int count) { /* ... unchanged ... */
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8), // Consistent bottom padding
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min, // Take minimum space
            children: [
              Container(
                width: 12, height: 12,
                decoration: BoxDecoration( color: color, shape: BoxShape.circle, ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0), // Padding only after circle
                child: Text( category, // Display category name
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                    color: FlutterFlowTheme.of(context).info, // Use theme color
                    letterSpacing: 0.0,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
                  ),
                ),
              ),
            ],
          ),
          Text( '$count check-ins', // Display category count
            style: FlutterFlowTheme.of(context).labelMedium.override(
              fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
              color: Colors.white, // Use theme color: theme.secondaryText
              letterSpacing: 0.0,
              useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
            ),
          ),
        ],
      ),
    );
  }

} // End of _StatisticsScreenWidgetState class
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../photo/habit_photo_screen_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/habit/habitcard/habitcard_widget.dart';
import 'dart:ui';
import '/index.dart'; // Assuming this imports necessary base widgets like HabitConfigureWidget, StatisticsScreenWidget etc.
import '../../streak_page/streak_page_widget.dart'; // <-- ADDED IMPORT FOR STREAK PAGE
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'habit_selection_screen_model.dart';
export 'habit_selection_screen_model.dart';


/// Prompt:
///
/// Design a habit tracking mobile screen named "Habits" with a modern,
/// colorful, and dark-themed UI.
///
/// This screen should have the following layout and interactive components:
///
/// 🔵 Overall Layout:
/// Title/Header:
///
/// Text: "Habits"
///
/// Positioned at the top-left.
///
/// On the right side of the title, include a bar graph icon (to represent
/// progress or analytics).
///
/// Tab Selector (Below Header):
///
/// Two buttons:
///
/// "Personal" (active by default)
///
/// "Group" (inactive until clicked)
///
/// Styled as pill-shaped toggle buttons. Active tab has a blue background,
/// inactive is transparent with white text.
///
/// 🟣 Habit Cards Grid:
/// Layout:
///
/// Two-column grid of cards, scrollable vertically.
///
/// Each card represents one habit and has a rounded rectangle shape with
/// distinct background colors for visual grouping.
///
/// Each Habit Card includes:
///
/// Top-left Icon: A unique symbol representing the habit (e.g. pencil, heart,
/// clock).
///
/// Top-right Menu Icon: A vertical ellipsis ("⋮") for additional options.
///
/// Habit Name: Bold white text (e.g., "Reading", "Workout").
///
/// Time Label: Light smaller text under the name (e.g., "14:06").
///
/// Weekday Selector:
///
/// 7 small rounded buttons labeled: M, T, W, T, F, S, S
///
/// Use the first letter of each weekday (Sunday at the end).
///
/// Highlight selected days (e.g., brightened or fully colored), while
/// unselected are dimmed or outlined.
///
/// 🔸 Example Habit Cards:
/// Card 1:
///
/// Color: Deep purple
///
/// Icon: Pencil
///
/// Name: "Reading"
///
/// Time: "14:06"
///
/// Selected Days: M, T, W, T, F
///
/// Card 2:
///
/// Color: Pink-red
///
/// Icon: Sparkle/Zen symbol
///
/// Name: "Meditation"
///
/// Time: "17:32"
///
/// Selected Days: M, T, W, T, F
///
/// Card 3:
///
/// Color: Orange
///
/// Icon: Heart
///
/// Name: "Self-care"
///
/// Time: "09:15"
///
/// Selected Days: M, T, W, T, F
///
/// Card 4:
///
/// Color: Bright yellow
///
/// Icon: Plus or Dumbbell
///
/// Name: "Workout"
///
/// Time: "06:30"
///
/// Selected Days: M, T, W, T, F
///
/// Card 5:
///
/// Color: Rose Pink
///
/// Icon: Stopwatch or Moon/Stars
///
/// Name: "Gratitude"
///
/// Time: "22:00"
///
/// Selected Days: M, T, W, T, F
///
/// Card 6:
///
/// Color: Light yellow
///
/// Icon: Pencil
///
/// Name: "Journaling"
///
/// Time: "21:15"
///
/// Selected Days: M, T, W, T, F
///
/// 🔵 Bottom of the Screen:
/// Floating Action Button (FAB):
///
/// Positioned at bottom-right.
///
/// Circular shape, blue background, with a white "+" icon.
///
/// Tapping it opens the screen to create a new habit.
///
/// 🌙 Style & Design Notes:
/// Dark theme: Background is black or near-black.
///
/// Vivid accent colors used per habit card to easily differentiate them.
///
/// Rounded corners everywhere: buttons, cards, tabs.
///
/// Fonts are modern and legible, using white or bright text for visibility.
///
/// The UI must feel vibrant, structured, and intuitive to navigate.
class HabitSelectionScreenWidget extends StatefulWidget {
  const HabitSelectionScreenWidget({super.key});

  static String routeName = 'HabitSelectionScreen';
  static String routePath = '/habitSelectionScreen';

  @override
  State<HabitSelectionScreenWidget> createState() =>
      _HabitSelectionScreenWidgetState();
}

class _HabitSelectionScreenWidgetState extends State<HabitSelectionScreenWidget>
    with TickerProviderStateMixin {
  late HabitSelectionScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _habits = [];
  bool _isLoading = true;
  List<Map<String, dynamic>> _myHabits = []; // 🔹 Personal habits
  List<Map<String, dynamic>> _groupHabits = []; // 🔹 Group habits
  bool _isMyHabitsTab = true; // 🔹 Track selected tab
  bool _wasMyHabitsTab = true;
  double _fabScale = 1.0;
  late TabController _tabController;


  Future<void> _fetchStats() async {
    // Ensure widget is still mounted before updating state
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final user = _auth.currentUser;
      if (user == null) {


        _currentStreak = 0;

        return; // Exit if no user
      }


      final userDoc = await _firestore.collection('users').doc(user.uid).get();


      if (userDoc.exists) {
        final userData = userDoc.data()!;
        // Safely access data with null checks and type casting [cite: 1]
        _currentStreak = (userData['streak'] as int?) ?? 0;







      }
    } catch (e) {
      print('DEBUG: Error fetching stats: $e');


    } finally {
      // Ensure widget is still mounted before updating state
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }


  void _fetchHabits() async {
    setState(() => _isLoading = true);
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final snapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('habits')
            .get();

        List<Map<String, dynamic>> habits = snapshot.docs.map((doc) =>
        {
          'id': doc.id,
          ...doc.data()
        }).toList();

        setState(() {
          _myHabits = habits.where((h) => h['isGroupHabit'] != true)
              .toList(); // ✅ Separate personal habits
          _groupHabits = habits.where((h) => h['isGroupHabit'] == true)
              .toList(); // ✅ Separate group habits
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching habits: $e');
    }
  }


  Color _getHabitColor(int index) {
    List<Color> colors = [
      FlutterFlowTheme.of(context).habitcard1, // Assuming you defined these in Theme
      FlutterFlowTheme.of(context).habitcard2,
      FlutterFlowTheme.of(context).habitcard3,
      FlutterFlowTheme.of(context).habitcard4,
      FlutterFlowTheme.of(context).habitcard5,

      // Add more colors if needed
    ];
    // Or use colors defined in habit_selectionScreen.txt
    // List<Color> colors = [ Color(0xFFFFB200), Color(0xFFBE4B02), ... ];
    return colors[index % colors.length];
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HabitSelectionScreenModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    // Fetch habits when the screen is initialized
    _fetchHabits();
    _fetchStats();
  }

  int _currentStreak = 0; // Your streak variable


  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
        floatingActionButton: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 15.0),
          child: FloatingActionButton(
            onPressed: () async {
              // Assuming HabitConfigureWidget.routeName is defined elsewhere, possibly via /index.dart
              context.pushNamed(HabitConfigureWidget.routeName);
            },
            backgroundColor: FlutterFlowTheme.of(context).buttonBackground,
            elevation: 8.0,
            child: Icon(
              Icons.add_rounded,
              color: FlutterFlowTheme.of(context).info,
              size: 24.0,
            ),
          ),
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Pushes title left and icons right
                children: [
                  // Habits Title (stays on the left)
                  Text(
                    FFLocalizations.of(context).getText(
                      '43f5vne0' /* Habits */,
                    ),
                    style: FlutterFlowTheme.of(context).displaySmall.override(
                      fontFamily:
                      FlutterFlowTheme.of(context).displaySmallFamily,
                      letterSpacing: 0.0,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).displaySmallFamily),
                    ),
                  ),

                  // Row for Streak and Statistics Icon (grouped on the right)
                  Row(
                    mainAxisSize: MainAxisSize.min, // Keep icons grouped
                    children: [
                      // -- START: MODIFIED Section - Added InkWell --
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed(StreakPageWidget.routeName);
                        },
                        child: Row( // Row containing the streak icon and text
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.local_fire_department_rounded, // Flame icon
                              color: Colors.orangeAccent, // Example color
                              size: 24.0,
                            ),
                            SizedBox(width: 4.0), // Space between icon and text
                            Text(
                              '$_currentStreak', // Display the streak count
                              style: FlutterFlowTheme.of(context).titleMedium.override(
                                fontFamily:
                                FlutterFlowTheme.of(context).titleMediumFamily,
                                color: Colors.orangeAccent, // Match icon color (optional)
                                letterSpacing: 0.0,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context).titleMediumFamily),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // -- END: MODIFIED Section - Added InkWell --

                      SizedBox(width: 8.0), // Space between streak and statistics icon

                      // Statistics Icon Button
                      FlutterFlowIconButton(
                        borderRadius: 8.0,
                        buttonSize: 40.0,
                        fillColor: FlutterFlowTheme.of(context).primary,
                        icon: Icon(
                          Icons.bar_chart,
                          color: FlutterFlowTheme.of(context).info,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          // Assuming StatisticsScreenWidget.routeName is defined elsewhere
                          context.pushNamed(StatisticsScreenWidget.routeName);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [],
            centerTitle: false, // Title is not centered
            elevation: 0.0,
          ),
        ), // AppBar end
        body: SafeArea( // Body Start
          top: true,
          child: Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary,
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 10.0, 16.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment(0.0, 0),
                          child: TabBar(
                            labelColor:
                            FlutterFlowTheme.of(context).primaryText,
                            unselectedLabelColor:
                            FlutterFlowTheme.of(context).secondaryText,
                            labelStyle: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                              fontFamily: FlutterFlowTheme.of(context)
                                  .titleLargeFamily,
                              letterSpacing: 0.0,
                              useGoogleFonts: GoogleFonts.asMap()
                                  .containsKey(FlutterFlowTheme.of(context)
                                  .titleLargeFamily),
                            ),
                            unselectedLabelStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                              fontFamily: FlutterFlowTheme.of(context)
                                  .titleMediumFamily,
                              letterSpacing: 0.0,
                              useGoogleFonts: GoogleFonts.asMap()
                                  .containsKey(FlutterFlowTheme.of(context)
                                  .titleMediumFamily),
                            ),
                            indicatorColor:
                            FlutterFlowTheme.of(context).buttonBackground,
                            indicatorWeight: 3.5,
                            tabs: [
                              Tab(
                                text: FFLocalizations.of(context).getText(
                                  'i3xr2cf1' /* Your habits */,
                                ),
                              ),
                              Tab(
                                text: FFLocalizations.of(context).getText(
                                  '21878072' /* Group habits */,
                                ),
                              ),
                            ],
                            controller: _model.tabBarController,
                            onTap: (i) async {
                              [() async {}, () async {}][i]();
                            },
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _model.tabBarController,
                            children: [
                              // Tab 1: Personal Habits
                              _buildHabitsGrid(_myHabits),

                              // Tab 2: Group Habits
                              _buildHabitsGrid(_groupHabits),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ), // Body end
      ),
    );
  } // build method end


  Widget _buildHabitsGrid(List<Map<String, dynamic>> habits) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: FlutterFlowTheme.of(context).buttonBackground));
    }

    if (habits.isEmpty) {
      // Placeholder for no habits
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            _model.tabBarController?.index == 0 // Check current tab index
                ? 'No personal habits yet.\nTap "+" to add your first one!'
                : 'No group habits found.\nJoin or create a group!',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyLarge.override(
              fontFamily: 'Inter',
              color: FlutterFlowTheme.of(context).secondaryText,
              letterSpacing: 0.0,
            ),
          ),
        ),
      );
    }

    // Use GridView.builder
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(4.0, 24.0, 4.0, 16.0), // Add bottom padding
      child: GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15.0,
          mainAxisSpacing: 15.0,
          childAspectRatio: 1.0, // Adjust for square cards if HabitcardWidget is square
        ),
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: habits.length,
        itemBuilder: (context, index) {
          final habit = habits[index];

          // Safely get data with defaults
          final String name = habit['name'] ?? 'Unnamed Habit';
          final String time = habit['time'] ?? '--:--';
          final List<dynamic> days = habit['days'] ?? [];
          final int iconCode = habit['icon'] ?? Icons.question_mark.codePoint;
          final String iconFontFamily = habit['iconFontFamily'] ?? 'MaterialIcons';
          final Color color = _getHabitColor(index); // Use your color logic

          // --- Add GestureDetector for Navigation ---
          return GestureDetector(
            onTap: () {
              print("Habit tapped: ${habit['name']}"); // Debug print
              // Navigate to HabitPhotoScreenWidget
              // Assuming HabitPhotoScreenWidget.routeName is defined elsewhere
              context.pushNamed(
                HabitPhotoScreenWidget.routeName, // Use route name
                extra: <String, dynamic>{
                  'habit': habit, // Pass the entire habit map
                },
              );
            },
            child: HabitcardWidget(
              // Add a key if needed for state preservation, e.g., key: ValueKey(habit['id'])
              key: ValueKey(habit['id'] ?? index), // Use habit ID for key
              habitName: name,
              habitTime: time,
              selectedDays: days,
              habitIconCode: iconCode,
              habitIconFontFamily: iconFontFamily,
              habitColor: color,
            ),
          );
          // --- End GestureDetector ---
        },
      ),
    );
  } // _buildHabitsGrid end
} // _HabitSelectionScreenWidgetState end
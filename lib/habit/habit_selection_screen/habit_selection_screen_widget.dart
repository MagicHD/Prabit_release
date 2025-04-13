import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/habit/habitcard/habitcard_widget.dart';
import 'dart:ui';
import '/index.dart';
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
  }


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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                      context.pushNamed(StatisticsScreenWidget.routeName);
                    },
                  ),
                ],
              ),
            ),
            actions: [],
            centerTitle: true,
            elevation: 0.0,
          ),
        ),
        body: SafeArea(
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
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        4.0, 24.0, 4.0, 0.0),
                                    child: GridView(
                                      padding: EdgeInsets.zero,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 15.0,
                                        mainAxisSpacing: 15.0,
                                        childAspectRatio: 0.9,
                                      ),
                                      primary: false,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      children: [
                                        wrapWithModel(
                                          model: _model.habitcardModel1,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: HabitcardWidget(
                                            habitcolor:
                                                FlutterFlowTheme.of(context)
                                                    .habitcard5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              GridView(
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 15.0,
                                  mainAxisSpacing: 10.0,
                                  childAspectRatio: 1.0,
                                ),
                                scrollDirection: Axis.vertical,
                                children: [
                                  wrapWithModel(
                                    model: _model.habitcardModel7,
                                    updateCallback: () => safeSetState(() {}),
                                    child: HabitcardWidget(),
                                  ),

                                ],
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
          ),
        ),
      ),
    );
  }
}

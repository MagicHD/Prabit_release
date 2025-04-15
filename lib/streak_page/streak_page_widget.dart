import 'package:cloud_firestore/cloud_firestore.dart'; // Added import
import 'package:firebase_auth/firebase_auth.dart'; // Added import
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'streak_page_model.dart';
export 'streak_page_model.dart';

/// Layout & Elements: Celebration Visual: Place a mascot or illustrated badge
/// at the top (e.g., glowing flame, trophy, or habit-themed character with
/// sunglasses) The visual should look cheerful and celebratory (animated or
/// stylized is fine) Streak Number: Large, bold number in the center (e.g.
///
/// “21” or “365”) Below it, “day streak!” in bright accent color (e.g. orange
/// or gold) The text should feel energetic and positive Message Box: Rounded
/// dark box or pill-style container with motivational subtext like: “You’ve
/// stayed consistent for 21 days – keep the momentum going!” or “Congrats!
/// You've shown up 365 days in a row!” Buttons: Primary Button: Label:
/// “Share” Bright blue, full-width, rounded Triggers sharing functionality
/// (e.g., post to feed, screenshot) Secondary Button: Label: “Continue”
/// Subtle text-only button or slightly dimmed Optional Extras: Small
/// fire/flame icon or streak bar showConfetti or sparkles in the background
/// to enhance celebratory feel Visual & Style Guide: Dark background
/// (#0d0d0d) for contrast and modern feel Bold typography for the streak
/// number (preferably in white) Accent color (orange or gold) for “day
/// streak!” and emphasis All components should have rounded corners, gentle
/// shadows, and clear spacing Mobile-first layout with large tap targets and
/// visual hierarchy
class StreakPageWidget extends StatefulWidget {
  const StreakPageWidget({super.key});

  static String routeName = 'streak_page';
  static String routePath = '/streakPage';

  @override
  State<StreakPageWidget> createState() => _StreakPageWidgetState();
}

class _StreakPageWidgetState extends State<StreakPageWidget> {
  late StreakPageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // --- ADDED THESE ---
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _currentStreak = 0; // To store the fetched streak
  bool _isLoading = true; // To track loading state
  // --- END OF ADDED ---

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StreakPageModel());
    _fetchStats(); // Call the fetch function here
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // --- ADDED THIS METHOD ---
  Future<void> _fetchStats() async {
    // Start loading
    if (mounted) { // Check if the widget is still in the tree
      setState(() => _isLoading = true);
    }

    try {
      final user = _auth.currentUser;
      if (user == null) {
        if (mounted) {
          setState(() {
            _currentStreak = 0; // Default to 0 if no user
            _isLoading = false;
          });
        }
        return; // Exit if no user
      }

      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      int fetchedStreak = 0; // Default value
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        // Safely access data with null checks and type casting
        fetchedStreak = (userData['streak'] as int?) ?? 0;
      }

      // Update state only if the widget is still mounted
      if (mounted) {
        setState(() {
          _currentStreak = fetchedStreak;
          _isLoading = false; // Stop loading
        });
      }

    } catch (e) {
      print('DEBUG: Error fetching stats on Streak Page: $e');
      // Handle error state, potentially update UI
      if (mounted) {
        setState(() {
          _currentStreak = 0; // Set to 0 on error
          _isLoading = false; // Stop loading even if error
        });
      }
    }
  }
  // --- END OF ADDED METHOD ---


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
        body: SafeArea(
          top: true,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary,
            ),
            // --- ADDED LOADING CHECK ---
            child: _isLoading
                ? Center( // Show loading indicator while fetching
              child: CircularProgressIndicator(
                color: FlutterFlowTheme.of(context).buttonBackground,
              ),
            )
                : Align( // Show content when loaded
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container( // Your mascot/image
                      width: 150.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: Image.asset(
                            // Consider replacing with a more relevant celebration image
                            'assets/images/logo.png',
                          ).image,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Column( // Streak Number and Text
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // --- MODIFIED THIS TEXT ---
                        Text(
                          '$_currentStreak', // Use the fetched streak variable
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .displayLarge
                              .override(
                            fontFamily: FlutterFlowTheme.of(context)
                                .displayLargeFamily,
                            color: Colors.white,
                            fontSize: 80.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w800,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context)
                                    .displayLargeFamily),
                          ),
                        ),
                        // --- END OF MODIFIED TEXT ---
                        Text(
                          FFLocalizations.of(context).getText(
                            '3c9f9t29' /* day streak! */,
                          ),
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .override(
                            fontFamily: FlutterFlowTheme.of(context)
                                .headlineMediumFamily,
                            color: Color(0xFFFFA500), // Accent color
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context)
                                    .headlineMediumFamily),
                          ),
                        ),
                      ].divide(SizedBox(height: 8.0)),
                    ),
                    Padding( // Motivational Message Box
                      padding: EdgeInsets.all(20.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          // Optional: Add background color/different styling
                          // color: Color(0x33FFFFFF), // Example: semi-transparent white
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              // --- MODIFIED THIS TEXT ---
                              child: Text(
                                // Dynamic message using fetched streak
                                _currentStreak > 0
                                    ? "You've stayed consistent for $_currentStreak day${_currentStreak == 1 ? '' : 's'} – keep the momentum going!"
                                    : "Start your streak today!", // Message for 0 streak
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyLargeFamily,
                                  color: Colors.white, // Text color
                                  letterSpacing: 0.0,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(
                                      FlutterFlowTheme.of(context)
                                          .bodyLargeFamily),
                                  lineHeight: 1.5,
                                ),
                              ),
                              // --- END OF MODIFIED TEXT ---
                            ),
                          ],
                        ),
                      ),
                    ),
                    FFButtonWidget( // Share Button
                      onPressed: () {
                        print('Share Button pressed ...');
                        // Add share functionality here
                        // e.g., using the 'share_plus' package
                      },
                      text: FFLocalizations.of(context).getText(
                        'le7oay1x' /* Share */,
                      ),
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 56.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 0.0, 24.0, 0.0),
                        iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).buttonBackground,
                        textStyle:
                        FlutterFlowTheme.of(context).titleMedium.override(
                          fontFamily: FlutterFlowTheme.of(context)
                              .titleMediumFamily,
                          color: Colors.white,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts: GoogleFonts.asMap()
                              .containsKey(FlutterFlowTheme.of(context)
                              .titleMediumFamily),
                        ),
                        elevation: 2.0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    // --- Continue Button (Made Tappable) ---
                    InkWell( // Wrap the Row in InkWell to make it tappable
                      onTap: () {
                        // Example: Navigate back
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          // Optional: Navigate somewhere else if cannot pop
                          // context.pushNamed('/'); // Example: Go to home
                        }
                      },
                      child: Padding( // Added padding for larger tap area
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              color: Color(0xFFFFA500), // Accent color
                              size: 20.0,
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 8.0, 0.0),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  'gkxdodb7' /* Continue */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyLargeFamily,
                                  color: Color(0xFFCCCCCC), // Subtle color
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                      .bodyLargeFamily),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // --- End of Continue Button ---
                  ].divide(SizedBox(height: 24.0)), // Vertical spacing between elements
                ),
              ),
            ),
            // --- END OF LOADING CHECK ---
          ),
        ),
      ),
    );
  }
}
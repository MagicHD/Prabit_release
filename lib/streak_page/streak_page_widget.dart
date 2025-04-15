import 'package:cloud_firestore/cloud_firestore.dart'; // Existing import
import 'package:firebase_auth/firebase_auth.dart'; // Existing import
import '/flutter_flow/flutter_flow_theme.dart'; // Existing import
import '/flutter_flow/flutter_flow_util.dart';   // Existing import
import '/flutter_flow/flutter_flow_widgets.dart';// Existing import
import 'dart:ui' as ui; // Import dart:ui with an alias for Image operations
import 'package:flutter/material.dart';         // Existing import
import 'package:flutter/rendering.dart';       // Needed for RenderRepaintBoundary
import 'package:google_fonts/google_fonts.dart'; // Existing import
import 'package:provider/provider.dart';       // Existing import
import 'streak_page_model.dart';            // Existing import

// --- ADD THESE IMPORTS ---
import 'package:share_plus/share_plus.dart';       // For sharing functionality
import 'package:path_provider/path_provider.dart'; // To get temporary directory
import 'dart:io';                              // For File operations
import 'dart:typed_data';                      // For Uint8List (image bytes)
// --- END OF ADDED IMPORTS ---

export 'streak_page_model.dart'; // Existing export

// Layout & Elements comments remain the same...
// Visual & Style Guide comments remain the same...

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

  // Existing state variables
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _currentStreak = 0;
  bool _isLoading = true;

  // --- ADD THESE STATE VARIABLES for Sharing ---
  final GlobalKey _screenshotKey = GlobalKey(); // Key for screenshot area
  bool _isSharing = false; // To track if sharing is in progress
  // --- END OF ADDED STATE VARIABLES ---

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StreakPageModel());
    _fetchStats(); // Fetch stats when the widget initializes
  }

  @override
  void dispose() {
    _model.dispose(); //
    super.dispose();
  }

  // Existing _fetchStats method - NO CHANGES NEEDED HERE
  Future<void> _fetchStats() async {
    if (mounted) {
      setState(() => _isLoading = true);
    }
    try {
      final user = _auth.currentUser;
      if (user == null) {
        if (mounted) {
          setState(() {
            _currentStreak = 0;
            _isLoading = false;
          });
        }
        return;
      }
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      int fetchedStreak = 0;
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        fetchedStreak = (userData['streak'] as int?) ?? 0;
      }
      if (mounted) {
        setState(() {
          _currentStreak = fetchedStreak;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('DEBUG: Error fetching stats on Streak Page: $e');
      if (mounted) {
        setState(() {
          _currentStreak = 0;
          _isLoading = false;
        });
      }
    }
  }

  // --- METHOD FOR SCREENSHOT AND SHARING --- (No changes needed in the logic itself)
  Future<void> _shareStreak() async {
    if (_isSharing) return; // Prevent multiple simultaneous shares

    if (mounted) {
      setState(() => _isSharing = true); //
    }

    try {
      // Wait for the frame to render
      await Future.delayed(const Duration(milliseconds: 100)); //

      if (!mounted || _screenshotKey.currentContext == null) { //
        print("Warning: Context lost after delay in _shareStreak. Aborting."); //
        throw Exception("Context became unavailable after delay"); //
      }

      // Find the RenderRepaintBoundary
      RenderRepaintBoundary boundary = _screenshotKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary; //

      // Optional check
      if (boundary.debugNeedsPaint || boundary.semanticBounds.isEmpty) { //
        print("Warning: RepaintBoundary might still need paint or has no size. Trying one more delay."); //
        await Future.delayed(const Duration(milliseconds: 100)); //
        if (!mounted || boundary.debugNeedsPaint || boundary.semanticBounds.isEmpty) { //
          throw Exception("RepaintBoundary issue persists after delays. Cannot capture image."); //
        }
      }

      // Capture the image
      double pixelRatio = MediaQuery.of(context).devicePixelRatio; //
      ui.Image image = await boundary.toImage(pixelRatio: pixelRatio); //

      // Convert to PNG bytes
      ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png); //
      if (byteData == null) { //
        throw Exception("Could not get byte data from image for sharing"); //
      }
      Uint8List pngBytes = byteData.buffer.asUint8List(); //

      // Get temporary directory and create file path
      final tempDir = await getTemporaryDirectory(); //
      final filePath = '${tempDir.path}/streak_share_${DateTime.now().millisecondsSinceEpoch}.png'; //
      final file = File(filePath); //

      // Write image bytes to file
      await file.writeAsBytes(pngBytes); //

      // Prepare share text
      final shareText = "Look at my great streak of $_currentStreak day${_currentStreak == 1 ? '' : 's'}! Go to prabit.tech for more"; //

      // Share using share_plus
      final xFile = XFile(filePath); //
      await Share.shareXFiles( //
          [xFile], //
          text: shareText, //
          subject: 'Check out my streak!' //
      );

      // Optional: await file.delete();

    } catch (e) {
      print('Error during sharing streak: $e'); //
      if (mounted) { //
        ScaffoldMessenger.of(context).showSnackBar( //
          SnackBar(content: Text('Sharing failed. Please try again. Error: ${e.toString().substring(0, min(e.toString().length, 100))}...')), //
        );
      }
    } finally {
      if (mounted) { //
        setState(() => _isSharing = false); //
      }
    }
  }
  // --- END OF METHOD ---


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); //
        FocusManager.instance.primaryFocus?.unfocus(); //
      },
      child: Scaffold(
        key: scaffoldKey, //
        backgroundColor: FlutterFlowTheme.of(context).primary, // Dark background
        body: SafeArea(
          top: true, //
          // --- MAIN COLUMN FOR LAYOUT ---
          child: Padding( // Add padding around the whole column if desired
            padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 24.0), // Adjusted bottom padding
            child: Column(
              mainAxisSize: MainAxisSize.max, // Use max available space
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Push content and buttons apart
              children: [
                // --- TOP CONTENT AREA TO BE SCREENSHOTTED ---
                Expanded( // Allow this section to take available space, pushing buttons down
                  child: RepaintBoundary( // --- THIS IS THE AREA TO CAPTURE ---
                    key: _screenshotKey, // Assign the key
                    child: Container( // Container ensures background color for the screenshot
                      width: double.infinity,
                      height: double.infinity, // Takes space provided by Expanded
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary, // Match scaffold background
                      ),
                      child: _isLoading
                          ? Center( // Loading indicator
                        child: CircularProgressIndicator(
                          color: FlutterFlowTheme.of(context).buttonBackground, //
                        ),
                      )
                          : Align( // Align content within the capture area
                        alignment: AlignmentDirectional(0.0, 0.0), //
                        child: Column( // Main content column
                          mainAxisSize: MainAxisSize.min, // Fit content size vertically
                          mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                          children: [
                            Container( // Mascot/image
                              width: 150.0,
                              height: 150.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: Image.asset(
                                    'assets/images/logo.png',
                                  ).image,
                                ),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(height: 24.0), // Spacing
                            Column( // Streak Number and Text
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text( // Streak number
                                  '$_currentStreak',
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
                                Text( // "day streak!"
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
                              ].divide(SizedBox(height: 8.0)), //
                            ),
                            SizedBox(height: 24.0), // Spacing
                            Padding( // Motivational Message Box padding
                              padding: EdgeInsets.symmetric(horizontal: 20.0), // Use symmetric padding
                              child: Container( //
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0), //
                                ),
                                child: Text( // Dynamic message
                                  _currentStreak > 0
                                      ? "You've stayed consistent for $_currentStreak day${_currentStreak == 1 ? '' : 's'} – keep the momentum going!"
                                      : "Start your streak today!",
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyLargeFamily,
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                        FlutterFlowTheme.of(context)
                                            .bodyLargeFamily),
                                    lineHeight: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ), // --- END OF RepaintBoundary ---
                ), // --- END OF TOP CONTENT AREA ---

                // --- BOTTOM AREA WITH BUTTONS (Outside RepaintBoundary) ---
                Column( // Column to hold the buttons
                  mainAxisSize: MainAxisSize.min, // Take minimum space needed for buttons
                  children: [
                    SizedBox(height: 24.0), // Add space above buttons
                    // --- SHARE BUTTON (Now outside RepaintBoundary) ---
                    FFButtonWidget( //
                      onPressed: _isSharing ? null : _shareStreak, //
                      text: _isSharing //
                          ? 'Sharing...' //
                          : FFLocalizations.of(context).getText( //
                        'le7oay1x' /* Share */, //
                      ), //
                      options: FFButtonOptions( //
                        width: double.infinity, //
                        height: 56.0, //
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 0.0, 24.0, 0.0), //
                        iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0), //
                        color: _isSharing //
                            ? FlutterFlowTheme.of(context).buttonBackground.withOpacity(0.6) //
                            : FlutterFlowTheme.of(context).buttonBackground, //
                        textStyle:
                        FlutterFlowTheme.of(context).titleMedium.override( //
                          fontFamily: FlutterFlowTheme.of(context)
                              .titleMediumFamily, //
                          color: Colors.white, //
                          letterSpacing: 0.0, //
                          fontWeight: FontWeight.w600, //
                          useGoogleFonts: GoogleFonts.asMap() //
                              .containsKey(FlutterFlowTheme.of(context) //
                              .titleMediumFamily), //
                        ), //
                        elevation: 2.0, //
                        borderSide: BorderSide( //
                          color: Colors.transparent, //
                          width: 1.0, //
                        ), //
                        borderRadius: BorderRadius.circular(30.0), //
                      ), //
                    ), //
                    // --- END OF SHARE BUTTON ---

                    SizedBox(height: 16.0), // Spacing between buttons

                    // --- CONTINUE BUTTON (Now outside RepaintBoundary) ---
                    InkWell( //
                      onTap: () { //
                        if (context.canPop()) { //
                          context.pop(); //
                        } else {
                          // context.pushNamed('/'); // Example fallback
                        }
                      },
                      child: Padding( //
                        padding: const EdgeInsets.symmetric(vertical: 8.0), // Adjusted padding slightly
                        child: Row( //
                          mainAxisSize: MainAxisSize.max, //
                          mainAxisAlignment: MainAxisAlignment.center, //
                          children: [
                            Icon( //
                              Icons.local_fire_department, //
                              color: Color(0xFFFFA500), //
                              size: 20.0, //
                            ),
                            Padding( //
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  8.0, 0.0, 8.0, 0.0), //
                              child: Text( //
                                FFLocalizations.of(context).getText( //
                                  'gkxdodb7' /* Continue */, //
                                ), //
                                style: FlutterFlowTheme.of(context) //
                                    .bodyLarge //
                                    .override( //
                                  fontFamily: FlutterFlowTheme.of(context) //
                                      .bodyLargeFamily, //
                                  color: Color(0xFFCCCCCC), //
                                  letterSpacing: 0.0, //
                                  fontWeight: FontWeight.w500, //
                                  useGoogleFonts: GoogleFonts.asMap() //
                                      .containsKey(FlutterFlowTheme.of(context) //
                                      .bodyLargeFamily), //
                                ), //
                              ), //
                            ),
                          ],
                        ),
                      ),
                    ),
                    // --- End of Continue Button ---
                  ],
                ),
                // --- END OF BOTTOM AREA ---
              ],
            ),
          ),
          // --- END OF MAIN COLUMN ---
        ),
      ),
    );
  }
}
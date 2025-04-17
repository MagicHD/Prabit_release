import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../custom_picker_widget.dart';
import '../icon/icon_picker_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'habit_configure_model.dart';
export 'habit_configure_model.dart';

/// The habit configuration screen in the Prabit app allows users to create
/// and customize a new personal habit through a structured and visually
/// intuitive interface.
///
/// It stays consistent with Prabit’s dark mode design language while offering
/// flexibility, clarity, and real-time visual feedback. Header Bar At the top
/// of the screen, the title “Create Habit” is displayed in bold white text,
/// centered between a back arrow (left) and a checkmark icon (right),
/// allowing users to return or confirm the habit creation. This navigation
/// layout is simple and familiar, providing clear directional options. Habit
/// Information The top section captures the habit’s basic properties: Habit
/// Name: A rounded text input field with a dark background and gray
/// placeholder text (“Enter habit name”). Time: A secondary input below with
/// a clock icon, defaulting to “08:00 AM,” labeled as optional. It follows
/// the same clean, accessible styling. Category Selection Beneath the time
/// input is the Category section: Organized into a 2-column grid, each
/// category is represented by a pill-shaped button with both an icon and
/// label. Available categories include: Physical, Mental, Learning, Social,
/// Health, Creativity, Productivity, and Mindfulness Each button has a
/// slightly raised appearance and a dark background to fit the app’s overall
/// aesthetic. A short instructional note explains the purpose: “Categorizing
/// your habit helps you organize and track patterns in your habit formation
/// journey.” Day Selection Below the categories, the Days section allows
/// users to select which days the habit should occur: Days are presented as
/// circular buttons labeled with single letters (M, T, W, etc.). Unselected
/// days have a dimmed appearance, while selected ones will likely light up to
/// show active status. Icon Selection Next is the Icon field: A button-style
/// row with a left-aligned icon and label (“Select Icon”), guiding users to a
/// dedicated icon picker screen. The icon is framed in a rounded rectangle
/// with a soft blue highlight, visually linking to the icon shown in the
/// preview. Color Selection The Color section follows, featuring a row of
/// circular color swatches in vibrant tones—yellow, orange, red, pink,
/// purple, etc. One color can be selected at a time. The selected swatch is
/// visually emphasized with an outer glow or border. Real-Time Preview At the
/// bottom of the screen is a Preview card showing a real-time visual of the
/// configured habit: The preview mimics how the habit will appear in the main
/// dashboard. It includes the selected icon, habit name (defaulting to “Habit
/// Name”), category label (e.g., “Uncategorized”), time, and active days. The
/// card background changes dynamically based on the selected color, giving
/// users immediate feedback. Summary The habit configuration screen in Prabit
/// is highly interactive, visually clear, and fully customizable. It provides
/// a seamless flow from entering basic info to selecting categories, timing,
/// and appearance. The structured layout and live preview make habit creation
/// both easy and rewarding. Rounded components, strong contrast, and
/// purposeful spacing contribute to a modern and motivational user
/// experience, perfectly suited to Prabit’s focus on mindful habit building.
class HabitConfigureWidget extends StatefulWidget {
  const HabitConfigureWidget({super.key});

  static String routeName = 'habit_configure';
  static String routePath = '/habitConfigure';

  @override
  State<HabitConfigureWidget> createState() => _HabitConfigureWidgetState();
}

class _HabitConfigureWidgetState extends State<HabitConfigureWidget> {
  late HabitConfigureModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HabitConfigureModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
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
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderRadius: 20.0,
            buttonSize: 40.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).info,
              size: 24.0,
            ),
            onPressed: () async {
              context.safePop();
            },
          ),
          title: Text(
            FFLocalizations.of(context).getText(
              'uoy72169' /* Create Habit */,
            ),
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                  letterSpacing: 0.0,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                      FlutterFlowTheme.of(context).headlineSmallFamily),
                ),
          ),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              child: FlutterFlowIconButton(
                borderRadius: 20.0,
                buttonSize: 40.0,
                icon: Icon(
                  Icons.check_rounded,
                  color: FlutterFlowTheme.of(context).info,
                  size: 24.0,
                ),
                onPressed: () async {
                  // --- START: Firebase Save Logic ---

                  // 1. Get Data from Model
                  final habitName = _model.textController.text.trim();
                  final category = _model.selectedCategory;
                  final iconData = _model.selectedIcon;
                  final color = _model.selectedColor;
                  final time = _model.selectedTime; // This is likely a DateTime? from the model

                  // 2. Validation
                  if (habitName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please enter a habit name.',
                          // Use theme colors for consistency
                          style: TextStyle(color: FlutterFlowTheme.of(context).info),
                        ),
                        backgroundColor: FlutterFlowTheme.of(context).error,
                      ),
                    );
                    return; // Stop if validation fails
                  }
                  if (category == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please select a category.',
                          style: TextStyle(color: FlutterFlowTheme.of(context).info),
                        ),
                        backgroundColor: FlutterFlowTheme.of(context).error,
                      ),
                    );
                    return;
                  }
                  if (iconData == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please select an icon.',
                          style: TextStyle(color: FlutterFlowTheme.of(context).info),
                        ),
                        backgroundColor: FlutterFlowTheme.of(context).error,
                      ),
                    );
                    return;
                  }
                  if (color == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please select a color.',
                          style: TextStyle(color: FlutterFlowTheme.of(context).info),
                        ),
                        backgroundColor: FlutterFlowTheme.of(context).error,
                      ),
                    );
                    return;
                  }
                  // Add validation for other required fields if necessary (e.g., at least one day selected)


                  // 3. Prepare Data for Firebase
                  final user = FirebaseAuth.instance.currentUser;
                  if (user == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Error: User not logged in.',
                          style: TextStyle(color: FlutterFlowTheme.of(context).info),
                        ),
                        backgroundColor: FlutterFlowTheme.of(context).error,
                      ),
                    );
                    return; // Make sure user is logged in
                  }

                  // Convert selected days map to a list of strings
                  final List<String> daysList = _model.selectedDays.entries
                      .where((entry) => entry.value) // Filter where the value is true
                      .map((entry) => entry.key) // Get the key ('M', 'T', etc.)
                      .toList();

                  // Format time (if selected) - Storing as HH:mm string
                  String? timeString;
                  if (time != null) {
                    // Ensure you have imported the 'intl' package for DateFormat
                    // Usually done automatically by FlutterFlow or add: import 'package:intl/intl.dart';
                    timeString = DateFormat('HH:mm').format(time); // Example: "08:00"
                  }

                  // Store color as a hex string (e.g., #FFD700)
                  String colorString = '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';


                  // Prepare the data map to be saved
                  final habitData = {
                    'name': habitName,
                    'category': category, // String like 'Physical', 'Mental' etc.
                    'days': daysList, // List ['M', 'W', 'F']
                    // Store icon details reliably
                    'iconCodePoint': iconData.codePoint,
                    'iconFontFamily': iconData.fontFamily,
                    // 'iconName': iconData.icon?.toString(), // Less reliable way
                    'color': colorString, // Hex string like #FFD700
                    'time': timeString, // HH:mm string or null
                    'userId': user.uid, // Link habit to the user
                    'createdAt': FieldValue.serverTimestamp(), // Track creation time
                    // Add any other fields from your model you need to save
                  };

                  // 4. Save to Firestore
                  try {
                    // Assuming collection path: users/{userId}/habits/{habitId}
                    // Using .add() automatically generates a unique document ID for the new habit
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('habits')
                        .add(habitData);

                    // 5. Provide Success Feedback and Navigate Back
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Habit created successfully!',
                          style: TextStyle(color: FlutterFlowTheme.of(context).info),
                        ),
                        backgroundColor: FlutterFlowTheme.of(context).success,
                      ),
                    );
                    // Navigate back after successful save
                    context.safePop(); // Use safePop for robust navigation

                  } catch (e) {
                    print('Error saving habit: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Error saving habit: ${e.toString()}',
                          style: TextStyle(color: FlutterFlowTheme.of(context).info),
                        ),
                        backgroundColor: FlutterFlowTheme.of(context).error,
                      ),
                    );
                  }
                  // --- END: Firebase Save Logic ---
                },
              ),
            ),
          ],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary,
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 24.0, 24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          FFLocalizations.of(context).getText(
                            'znbfms7b' /* Habit Name */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .titleLarge
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .titleLargeFamily,
                                letterSpacing: 0.0,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .titleLargeFamily),
                              ),
                        ),
                        TextFormField(
                          controller: _model.textController,
                          focusNode: _model.textFieldFocusNode,
                          autofocus: false,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: FFLocalizations.of(context).getText(
                              '1k633i9r' /* Enter habit name */,
                            ),
                            hintStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .bodyMediumFamily,
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyMediumFamily),
                                ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBordercolor,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBordercolor,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            filled: true,
                            fillColor: FlutterFlowTheme.of(context).secondary,
                            contentPadding: EdgeInsets.all(16.0),
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).info,
                                letterSpacing: 0.0,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                          cursorColor: FlutterFlowTheme.of(context).secondary,
                          validator: _model.textControllerValidator
                              .asValidator(context),
                        ),
                      ].divide(SizedBox(height: 8.0)),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding( // Added padding for spacing consistency if needed
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0), // Matches divider spacing
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'hfbd6ief' /* Time (Optional) */,
                            ),
                            style: FlutterFlowTheme.of(context)
                                .titleLarge
                                .override(
                              fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                              letterSpacing: 0.0,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context).titleLargeFamily),
                            ),
                          ),
                        ),
                        // Wrap the Container with GestureDetector to make it tappable
                        GestureDetector(
                          // Inside habit_configure_widget.dart, replace the onTap for the time GestureDetector:
                          onTap: () async {
                            // Determine initial time for the custom picker
                            final currentTimeOfDay = _model.selectedTime != null
                                ? TimeOfDay.fromDateTime(_model.selectedTime!)
                                : TimeOfDay.now(); // Or a default like TimeOfDay(hour: 8, minute: 0)

                            // Show the custom dialog
                            final TimeOfDay? picked = await showDialog<TimeOfDay?>(
                              context: context,
                              builder: (dialogContext) {
                                return CustomTimePickerPopup(
                                  initialTime: currentTimeOfDay,
                                );
                              },
                            );

                            // If the user picked a time (didn't cancel)
                            if (picked != null) {
                              final now = DateTime.now();
                              setState(() {
                                // Update the model's selectedTime (which is DateTime?)
                                _model.selectedTime = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  picked.hour,
                                  picked.minute,
                                );
                              });
                            }
                            // Handle potential clearing if needed (if your dialog could return a specific value for clear)
                            // else {
                            //   setState(() { _model.selectedTime = null; });
                            // }
                          }, // End of onTap
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              // Styling from your original code to match app design
                              color: FlutterFlowTheme.of(context).secondary,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).primaryBordercolor,
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0), // Consistent padding
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: FlutterFlowTheme.of(context).info, // Use theme color
                                        size: 24.0,
                                      ),
                                      Padding( // Added padding for spacing
                                        padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          _model.selectedTime != null
                                          // Format the DateTime using intl package (e.g., 8:00 AM)
                                              ? DateFormat.jm().format(_model.selectedTime!)
                                          // Use a clear placeholder text
                                              : 'Select Time',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                            color: FlutterFlowTheme.of(context).info, // Use theme color
                                            letterSpacing: 0.0,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                          ),
                                        ),
                                      ),
                                    ],
                                    // Note: .divide extension method might not be standard Flutter/Dart.
                                    // If it causes issues, replace it with Padding/SizedBox widgets.
                                    // Example replacement: Adding Padding around Text above.
                                  ),
                                  Icon(
                                    // Icon indicating tappability
                                    Icons.edit_calendar_outlined,
                                    color: FlutterFlowTheme.of(context).info, // Use theme color
                                    size: 24.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                      // Note: .divide extension method might not be standard Flutter/Dart.
                      // If this wrapping Column uses .divide and it causes issues,
                      // replace it with Padding on the Text and GestureDetector/Container widgets.
                      // Example replacement: Added Padding to the Title Text above.
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          FFLocalizations.of(context).getText(
                            'z8k3r8u2' /* Days */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .titleLarge
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .titleLargeFamily,
                                letterSpacing: 0.0,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .titleLargeFamily),
                              ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                // This is where the onTap action goes
                                setState(() {
                                  // Use the correct key for Monday as defined in your model ('M' in the previous example)
                                  _model.selectedDays['M'] = !_model.selectedDays['M']!;
                                });
                                // You could add other actions here if needed after the state updates
                              },
                              child:
                              Container(

                              width: 40.0,
                              height: 40.0,

                              decoration: BoxDecoration(
                                color: _model.selectedDays['M']! // Checks the updated state
                                    ? FlutterFlowTheme.of(context).buttonBackground // Color IF true (selected)
                                    : FlutterFlowTheme.of(context).secondary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBordercolor,
                                  width: 1.0,
                                ),

                              ),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    FFLocalizations.of(context).getText(
                                      'j1wgbwkw' /* M */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                ),
                              ),
                            ),),
                            GestureDetector(
                              onTap: () async {
                                // This is where the onTap action goes
                                setState(() {
                                  // Use the correct key for Monday as defined in your model ('M' in the previous example)
                                  _model.selectedDays['T'] = !_model.selectedDays['T']!;
                                });
                                // You could add other actions here if needed after the state updates
                              },
                              child:
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: _model.selectedDays['T']! // Checks the updated state
                                    ? FlutterFlowTheme.of(context).buttonBackground // Color IF true (selected)
                                    : FlutterFlowTheme.of(context).secondary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBordercolor,
                                  width: 1.0,
                                ),
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    FFLocalizations.of(context).getText(
                                      'h7r4t8ij' /* T */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                ),
                              ),
                            ),),
                            GestureDetector(
                              onTap: () async {
                                // This is where the onTap action goes
                                setState(() {
                                  // Use the correct key for Monday as defined in your model ('M' in the previous example)
                                  _model.selectedDays['W'] = !_model.selectedDays['W']!;
                                });
                                // You could add other actions here if needed after the state updates
                              },
                              child:
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: _model.selectedDays['W']! // Checks the updated state
                                    ? FlutterFlowTheme.of(context).buttonBackground // Color IF true (selected)
                                    : FlutterFlowTheme.of(context).secondary,

                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 1.0,
                                ),
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    FFLocalizations.of(context).getText(
                                      'kdcmblme' /* W */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                ),
                              ),
                            ),),
                            GestureDetector(
                              onTap: () async {
                                // This is where the onTap action goes
                                setState(() {
                                  // Use the correct key for Monday as defined in your model ('M' in the previous example)
                                  _model.selectedDays['Th'] = !_model.selectedDays['Th']!;
                                });
                                // You could add other actions here if needed after the state updates
                              },
                              child:
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: _model.selectedDays['Th']! // Checks the updated state
                                    ? FlutterFlowTheme.of(context).buttonBackground // Color IF true (selected)
                                    : FlutterFlowTheme.of(context).secondary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBordercolor,
                                  width: 1.0,
                                ),
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    FFLocalizations.of(context).getText(
                                      'clbwih2d' /* T */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                ),
                              ),
                            ),),
                            GestureDetector(
                              onTap: () async {
                                // This is where the onTap action goes
                                setState(() {
                                  // Use the correct key for Monday as defined in your model ('M' in the previous example)
                                  _model.selectedDays['F'] = !_model.selectedDays['F']!;
                                });
                                // You could add other actions here if needed after the state updates
                              },
                              child:
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: _model.selectedDays['F']! // Checks the updated state
                                    ? FlutterFlowTheme.of(context).buttonBackground // Color IF true (selected)
                                    : FlutterFlowTheme.of(context).secondary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 1.0,
                                ),
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    FFLocalizations.of(context).getText(
                                      'bboeouw7' /* F */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                ),
                              ),
                            ),),
                            GestureDetector(
                              onTap: () async {
                                // This is where the onTap action goes
                                setState(() {
                                  // Use the correct key for Monday as defined in your model ('M' in the previous example)
                                  _model.selectedDays['Sa'] = !_model.selectedDays['Sa']!;
                                });
                                // You could add other actions here if needed after the state updates
                              },
                              child:
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: _model.selectedDays['Sa']! // Checks the updated state
                                    ? FlutterFlowTheme.of(context).buttonBackground // Color IF true (selected)
                                    : FlutterFlowTheme.of(context).secondary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBordercolor,
                                  width: 1.0,
                                ),
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    FFLocalizations.of(context).getText(
                                      'xdmz6e21' /* S */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                ),
                              ),
                            ),),
                            GestureDetector(
                              onTap: () async {
                                // This is where the onTap action goes
                                setState(() {
                                  // Use the correct key for Monday as defined in your model ('M' in the previous example)
                                  _model.selectedDays['Su'] = !_model.selectedDays['Su']!;
                                });
                                // You could add other actions here if needed after the state updates
                              },
                              child:
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: _model.selectedDays['Su']! // Checks the updated state
                                    ? FlutterFlowTheme.of(context).buttonBackground // Color IF true (selected)
                                    : FlutterFlowTheme.of(context).secondary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBordercolor,
                                  width: 1.0,
                                ),
                              ),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    FFLocalizations.of(context).getText(
                                      'z6ntn6yf' /* S */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                          color:
                                              FlutterFlowTheme.of(context).info,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                ),
                              ),
                            ),),
                          ],
                        ),
                      ].divide(SizedBox(height: 16.0)),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          FFLocalizations.of(context).getText(
                            'ssb073ij' /* Color */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .titleLarge
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .titleLargeFamily,
                                letterSpacing: 0.0,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .titleLargeFamily),
                              ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                // This is where the onTap action goes
                                setState(() {
                                  // Use the correct key for Monday as defined in your model ('M' in the previous example)
                                  _model.selectedColor = Color(0xFFFFD700);
                                });
                                // You could add other actions here if needed after the state updates
                              },
                              child: Container(
                              width: 32.0,
                              height: 32.0,
                              decoration: BoxDecoration(
                                color: Color(0xFFFFD700),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _model.selectedColor == Color(0xFFFFD700)
                                      ? FlutterFlowTheme.of(context).info // Selected indicator
                                      : Colors.transparent, // No border if not selected
                                  width: 2.0,
                                ),
                              ),
                            ),),
                            GestureDetector(
                              onTap: () async {
                                // This is where the onTap action goes
                                setState(() {
                                  // Use the correct key for Monday as defined in your model ('M' in the previous example)
                                  _model.selectedColor = Color(0xFFFF8C00);
                                });
                                // You could add other actions here if needed after the state updates
                              },
                              child: Container(
                                width: 32.0,
                                height: 32.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF8C00),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _model.selectedColor == Color(0xFFFF8C00)
                                        ? FlutterFlowTheme.of(context).info // Selected indicator
                                        : Colors.transparent, // No border if not selected
                                    width: 2.0,
                                  ),
                                ),
                              ),),
                            GestureDetector(
                              onTap: () async {
                                // This is where the onTap action goes
                                setState(() {
                                  // Use the correct key for Monday as defined in your model ('M' in the previous example)
                                  _model.selectedColor = Color(0xFFFF4500);
                                });
                                // You could add other actions here if needed after the state updates
                              },
                              child: Container(
                                width: 32.0,
                                height: 32.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF4500),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _model.selectedColor == Color(0xFFFF4500)
                                        ? FlutterFlowTheme.of(context).info // Selected indicator
                                        : Colors.transparent, // No border if not selected
                                    width: 2.0,
                                  ),
                                ),
                              ),),
                            GestureDetector(
                              onTap: () async {
                                // This is where the onTap action goes
                                setState(() {
                                  // Use the correct key for Monday as defined in your model ('M' in the previous example)
                                  _model.selectedColor = Color(0xFFFF1493);
                                });
                                // You could add other actions here if needed after the state updates
                              },
                              child: Container(
                                width: 32.0,
                                height: 32.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF1493),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _model.selectedColor == Color(0xFFFF1493)
                                        ? FlutterFlowTheme.of(context).info // Selected indicator
                                        : Colors.transparent, // No border if not selected
                                    width: 2.0,
                                  ),
                                ),
                              ),),
                            GestureDetector(
                              onTap: () async {
                                // This is where the onTap action goes
                                setState(() {
                                  // Use the correct key for Monday as defined in your model ('M' in the previous example)
                                  _model.selectedColor = Color(0xFF9370DB);
                                });
                                // You could add other actions here if needed after the state updates
                              },
                              child: Container(
                                width: 32.0,
                                height: 32.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFF9370DB),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _model.selectedColor == Color(0xFF9370DB)
                                        ? FlutterFlowTheme.of(context).info // Selected indicator
                                        : Colors.transparent, // No border if not selected
                                    width: 2.0,
                                  ),
                                ),
                              ),),
                            GestureDetector(
                              onTap: () async {
                                // This is where the onTap action goes
                                setState(() {
                                  // Use the correct key for Monday as defined in your model ('M' in the previous example)
                                  _model.selectedColor = Color(0xFF4169E1);
                                });
                                // You could add other actions here if needed after the state updates
                              },
                              child: Container(
                                width: 32.0,
                                height: 32.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFF4169E1),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _model.selectedColor == Color(0xFF4169E1)
                                        ? FlutterFlowTheme.of(context).info // Selected indicator
                                        : Colors.transparent, // No border if not selected
                                    width: 2.0,
                                  ),
                                ),
                              ),),
                            GestureDetector(
                              onTap: () async {
                                // This is where the onTap action goes
                                setState(() {
                                  // Use the correct key for Monday as defined in your model ('M' in the previous example)
                                  _model.selectedColor = Color(0xFF00BFFF);
                                });
                                // You could add other actions here if needed after the state updates
                              },
                              child: Container(
                                width: 32.0,
                                height: 32.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFF00BFFF),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _model.selectedColor == Color(0xFF00BFFF)
                                        ? FlutterFlowTheme.of(context).info // Selected indicator
                                        : Colors.transparent, // No border if not selected
                                    width: 2.0,
                                  ),
                                ),
                              ),),
                            GestureDetector(
                              onTap: () async {
                                // This is where the onTap action goes
                                setState(() {
                                  // Use the correct key for Monday as defined in your model ('M' in the previous example)
                                  _model.selectedColor = Color(0xFF32CD32);
                                });
                                // You could add other actions here if needed after the state updates
                              },
                              child: Container(
                                width: 32.0,
                                height: 32.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFF32CD32),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _model.selectedColor == Color(0xFF32CD32)
                                        ? FlutterFlowTheme.of(context).info // Selected indicator
                                        : Colors.transparent, // No border if not selected
                                    width: 2.0,
                                  ),
                                ),
                              ),),
                          ],
                        ),
                      ].divide(SizedBox(height: 16.0)),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Inside the build method, within the Column for the 'Icon' section:

                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              FFLocalizations.of(context).getText(
                                'e9ivxfh1' /* Icon */,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .titleLargeFamily,
                                letterSpacing: 0.0,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(
                                    FlutterFlowTheme.of(context)
                                        .titleLargeFamily),
                              ),
                            ),
                            // Wrap the Container with GestureDetector
                            GestureDetector(
                              // Inside habit_configure_widget.dart, replace the onTap content:
                              // Inside habit_configure_widget.dart, replace the onTap content:
                              onTap: () async {
                                // Show IconPickerWidget in a Dialog
                                final selectedIconResult = await showDialog<IconData?>( // Or String? if returning ID
                                  context: context,
                                  builder: (dialogContext) {
                                    // Return a Dialog widget containing your IconPickerWidget
                                    return Dialog(
                                      // Optional: Adjust shape, background color, padding etc.
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                      ),
                                      // You might need to constrain the size of the Dialog
                                      // or adjust the IconPickerWidget layout significantly.
                                      child: IconPickerWidget(
                                        currentlySelectedId: _model.selectedIcon?.toString(), // Pass current selection if needed
                                        // Note: Adjust type based on what you store/compare
                                      ),
                                    );
                                  },
                                );

                                // If an icon was selected and returned, update the state
                                if (selectedIconResult != null) {
                                  // --- Keep your existing logic for handling the result ---
                                  // Make sure the type matches what IconPickerWidget returns via Navigator.pop()
                                  // Example if IconData is returned:
                                  setState(() {
                                    _model.selectedIcon = selectedIconResult;
                                  });
                                  // Example if String ID is returned:
                                  // setState(() {
                                  //   _model.selectedIconId = selectedIconResult;
                                  //   // Add logic to find IconData from ID if needed
                                  // });
                                }
                              }, // End of onTapf onTap
                              child: Container( // This is the original container for the button
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).secondary,
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBordercolor,
                                    width: 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            width: 40.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              color: _model.selectedColor ?? FlutterFlowTheme.of(context).buttonBackground, // Use selected color for consistency?
                                              borderRadius:
                                              BorderRadius.circular(8.0),
                                            ),
                                            child: Align(
                                              alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                              // Display selected icon or default
                                              child: Icon(
                                                _model.selectedIcon ?? Icons.add_reaction_outlined, // Show selected icon or a default placeholder
                                                color:
                                                FlutterFlowTheme.of(context)
                                                    .info,
                                                size: 24.0,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            // Change text if an icon is selected
                                            _model.selectedIcon != null
                                                ? 'Icon Selected' // Or display icon name if available
                                                : FFLocalizations.of(context).getText(
                                              '5sq430y4' /* Select Icon */,
                                            ),
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                              fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily,
                                              color:
                                              FlutterFlowTheme.of(context)
                                                  .info,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: GoogleFonts
                                                  .asMap()
                                                  .containsKey(
                                                  FlutterFlowTheme.of(
                                                      context)
                                                      .bodyMediumFamily),
                                            ),
                                          ),
                                        ].divide(SizedBox(width: 16.0)),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Colors.white,
                                        size: 24.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ].divide(SizedBox(height: 16.0)),
                        ), // End of Icon Column

// Make sure your IconPickerWidget returns the selected IconData like this:
// In IconPickerWidget, when an icon is tapped:
// Navigator.pop(context, selectedIconData); // e.g., Navigator.pop(context, Icons.fitness_center);
                        Text(
                          FFLocalizations.of(context).getText(
                            'duoeg3ai' /* Category */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .titleLarge
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .titleLargeFamily,
                                letterSpacing: 0.0,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .titleLargeFamily),
                              ),
                        ),
                        GridView(
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12.0,
                            mainAxisSpacing: 12.0,
                            childAspectRatio: 2.5,
                          ),
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: [
                            // Wrap the Material widget with GestureDetector
                            GestureDetector(
                              onTap: () async {
                                // Action to perform when tapped
                                setState(() {
                                  // Update the selectedCategory state in your model
                                  // Use the specific category name for this button
                                  _model.selectedCategory = 'Physical'; // <<< Set category to 'Physical'
                                });
                              },
                              child: Material( // The original Material widget is now the child
                                color: Colors.transparent,
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    // Update color/border based on selection
                                    color: _model.selectedCategory == 'Physical' // <<< Check for 'Physical'
                                        ? FlutterFlowTheme.of(context).buttonBackground // Example: Color when selected
                                        : FlutterFlowTheme.of(context).secondary, // Default color
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: _model.selectedCategory == 'Physical' // <<< Check for 'Physical'
                                          ? FlutterFlowTheme.of(context).primaryText // Example: Border color when selected
                                          : FlutterFlowTheme.of(context).primaryBordercolor, // Default border color
                                      width: _model.selectedCategory == 'Physical' // <<< Check for 'Physical'
                                          ? 2.0 // Example: Thicker border when selected
                                          : 1.0, // Default border width
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.sports_tennis, // Icon for Physical
                                          // Optionally change icon color based on selection
                                          color: _model.selectedCategory == 'Physical' // <<< Check for 'Physical'
                                              ? FlutterFlowTheme.of(context).secondary // Example: Icon color when selected
                                              : FlutterFlowTheme.of(context).primaryText, // Default icon color
                                          size: 20.0,
                                        ),
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            'ww1rw39y' /* Physical */, // Text for Physical
                                          ),
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                            // Optionally change text color based on selection
                                            color: _model.selectedCategory == 'Physical' // <<< Check for 'Physical'
                                                ? FlutterFlowTheme.of(context).secondary // Example: Text color when selected
                                                : FlutterFlowTheme.of(context).info, // Default text color
                                            letterSpacing: 0.0,
                                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                                FlutterFlowTheme.of(context).bodyMediumFamily),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 8.0)), // Assuming .divide is an extension method you have
                                    ),
                                  ),
                                ),
                              ),
                            )
                            // Wrap the Material widget with GestureDetector
                            ,GestureDetector(
                              onTap: () async {
                                // Action to perform when tapped
                                setState(() {
                                  // Update the selectedCategory state in your model
                                  // Use the specific category name for this button
                                  _model.selectedCategory = 'Mental';
                                });
                              },
                              child: Material( // The original Material widget is now the child
                                color: Colors.transparent,
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    // Update color/border based on selection
                                    color: _model.selectedCategory == 'Mental' // Check if this category is selected
                                        ? FlutterFlowTheme.of(context).buttonBackground // Example: Color when selected
                                        : FlutterFlowTheme.of(context).secondary, // Default color
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: _model.selectedCategory == 'Mental'
                                          ? FlutterFlowTheme.of(context).primaryText // Example: Border color when selected
                                          : FlutterFlowTheme.of(context).primaryBordercolor, // Default border color
                                      width: _model.selectedCategory == 'Mental'
                                          ? 2.0 // Example: Thicker border when selected
                                          : 1.0, // Default border width
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.psychology_outlined,
                                          // Optionally change icon color based on selection
                                          color: _model.selectedCategory == 'Mental'
                                              ? FlutterFlowTheme.of(context).secondary // Example: Icon color when selected
                                              : FlutterFlowTheme.of(context).primaryText, // Default icon color
                                          size: 20.0,
                                        ),
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            'ieiic0ns' /* Mental */,
                                          ),
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                            // Optionally change text color based on selection
                                            color: _model.selectedCategory == 'Mental'
                                                ? FlutterFlowTheme.of(context).secondary // Example: Text color when selected
                                                : FlutterFlowTheme.of(context).info, // Default text color
                                            letterSpacing: 0.0,
                                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                                FlutterFlowTheme.of(context).bodyMediumFamily),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 8.0)), // Assuming .divide is an extension method you have
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Wrap the Material widget with GestureDetector
                            GestureDetector(
                              onTap: () async {
                                // Action to perform when tapped
                                setState(() {
                                  // Update the selectedCategory state in your model
                                  // Use the specific category name for this button
                                  _model.selectedCategory = 'Learning'; // <<< Set category to 'Learning'
                                });
                              },
                              child: Material( // The original Material widget is now the child
                                color: Colors.transparent,
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    // Update color/border based on selection
                                    color: _model.selectedCategory == 'Learning' // <<< Check for 'Learning'
                                        ? FlutterFlowTheme.of(context).buttonBackground // Example: Color when selected
                                        : FlutterFlowTheme.of(context).secondary, // Default color
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: _model.selectedCategory == 'Learning' // <<< Check for 'Learning'
                                          ? FlutterFlowTheme.of(context).primaryText // Example: Border color when selected
                                          : FlutterFlowTheme.of(context).primaryBordercolor, // Default border color
                                      width: _model.selectedCategory == 'Learning' // <<< Check for 'Learning'
                                          ? 2.0 // Example: Thicker border when selected
                                          : 1.0, // Default border width
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.school_outlined, // Icon for Learning
                                          // Optionally change icon color based on selection
                                          color: _model.selectedCategory == 'Learning' // <<< Check for 'Learning'
                                              ? FlutterFlowTheme.of(context).secondary // Example: Icon color when selected
                                              : FlutterFlowTheme.of(context).primaryText, // Default icon color
                                          size: 20.0,
                                        ),
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            'ec4ugesd' /* Learning */, // Text for Learning
                                          ),
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                            // Optionally change text color based on selection
                                            color: _model.selectedCategory == 'Learning' // <<< Check for 'Learning'
                                                ? FlutterFlowTheme.of(context).secondary // Example: Text color when selected
                                                : FlutterFlowTheme.of(context).info, // Default text color
                                            letterSpacing: 0.0,
                                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                                FlutterFlowTheme.of(context).bodyMediumFamily),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 8.0)), // Assuming .divide is an extension method you have
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Wrap the Material widget with GestureDetector
                            GestureDetector(
                              onTap: () async {
                                // Action to perform when tapped
                                setState(() {
                                  // Update the selectedCategory state in your model
                                  // Use the specific category name for this button
                                  _model.selectedCategory = 'Social'; // <<< Set category to 'Social'
                                });
                              },
                              child: Material( // The original Material widget is now the child
                                color: Colors.transparent,
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    // Update color/border based on selection
                                    color: _model.selectedCategory == 'Social' // <<< Check for 'Social'
                                        ? FlutterFlowTheme.of(context).buttonBackground // Example: Color when selected
                                        : FlutterFlowTheme.of(context).secondary, // Default color
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: _model.selectedCategory == 'Social' // <<< Check for 'Social'
                                          ? FlutterFlowTheme.of(context).primaryText // Example: Border color when selected
                                          : FlutterFlowTheme.of(context).primaryBordercolor, // Default border color
                                      width: _model.selectedCategory == 'Social' // <<< Check for 'Social'
                                          ? 2.0 // Example: Thicker border when selected
                                          : 1.0, // Default border width
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.mail_outline_rounded, // Icon for Social
                                          // Optionally change icon color based on selection
                                          color: _model.selectedCategory == 'Social' // <<< Check for 'Social'
                                              ? FlutterFlowTheme.of(context).secondary // Example: Icon color when selected
                                              : FlutterFlowTheme.of(context).primaryText, // Default icon color
                                          size: 20.0,
                                        ),
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            '98fmkouc' /* Social */, // Text for Social
                                          ),
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                            // Optionally change text color based on selection
                                            color: _model.selectedCategory == 'Social' // <<< Check for 'Social'
                                                ? FlutterFlowTheme.of(context).secondary // Example: Text color when selected
                                                : FlutterFlowTheme.of(context).info, // Default text color
                                            letterSpacing: 0.0,
                                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                                FlutterFlowTheme.of(context).bodyMediumFamily),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 8.0)), // Assuming .divide is an extension method you have
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Wrap the Material widget with GestureDetector
                            GestureDetector(
                              onTap: () async {
                                // Action to perform when tapped
                                setState(() {
                                  // Update the selectedCategory state in your model
                                  // Use the specific category name for this button
                                  _model.selectedCategory = 'Health'; // <<< Set category to 'Health'
                                });
                              },
                              child: Material( // The original Material widget is now the child
                                color: Colors.transparent,
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    // Update color/border based on selection
                                    color: _model.selectedCategory == 'Health' // <<< Check for 'Health'
                                        ? FlutterFlowTheme.of(context).buttonBackground // Example: Color when selected
                                        : FlutterFlowTheme.of(context).secondary, // Default color
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: _model.selectedCategory == 'Health' // <<< Check for 'Health'
                                          ? FlutterFlowTheme.of(context).primaryText // Example: Border color when selected
                                          : FlutterFlowTheme.of(context).primaryBordercolor, // Default border color
                                      width: _model.selectedCategory == 'Health' // <<< Check for 'Health'
                                          ? 2.0 // Example: Thicker border when selected
                                          : 1.0, // Default border width
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        FaIcon( // Using FaIcon for FontAwesome heart
                                          FontAwesomeIcons.heart, // Icon for Health
                                          // Optionally change icon color based on selection
                                          color: _model.selectedCategory == 'Health' // <<< Check for 'Health'
                                              ? FlutterFlowTheme.of(context).secondary // Example: Icon color when selected
                                              : FlutterFlowTheme.of(context).primaryText, // Default icon color
                                          size: 20.0,
                                        ),
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            '67xdqhyf' /* Health */, // Text for Health
                                          ),
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                            // Optionally change text color based on selection
                                            color: _model.selectedCategory == 'Health' // <<< Check for 'Health'
                                                ? FlutterFlowTheme.of(context).secondary // Example: Text color when selected
                                                : FlutterFlowTheme.of(context).info, // Default text color
                                            letterSpacing: 0.0,
                                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                                FlutterFlowTheme.of(context).bodyMediumFamily),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 8.0)), // Assuming .divide is an extension method you have
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Wrap the Material widget with GestureDetector
                            GestureDetector(
                              onTap: () async {
                                // Action to perform when tapped
                                setState(() {
                                  // Update the selectedCategory state in your model
                                  // Use the specific category name for this button
                                  _model.selectedCategory = 'Creativity'; // <<< Set category to 'Creativity'
                                });
                              },
                              child: Material( // The original Material widget is now the child
                                color: Colors.transparent,
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    // Update color/border based on selection
                                    color: _model.selectedCategory == 'Creativity' // <<< Check for 'Creativity'
                                        ? FlutterFlowTheme.of(context).buttonBackground // Example: Color when selected
                                        : FlutterFlowTheme.of(context).secondary, // Default color
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: _model.selectedCategory == 'Creativity' // <<< Check for 'Creativity'
                                          ? FlutterFlowTheme.of(context).primaryText // Example: Border color when selected
                                          : FlutterFlowTheme.of(context).primaryBordercolor, // Default border color
                                      width: _model.selectedCategory == 'Creativity' // <<< Check for 'Creativity'
                                          ? 2.0 // Example: Thicker border when selected
                                          : 1.0, // Default border width
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.music_note_outlined, // Icon for Creativity
                                          // Optionally change icon color based on selection
                                          color: _model.selectedCategory == 'Creativity' // <<< Check for 'Creativity'
                                              ? FlutterFlowTheme.of(context).secondary // Example: Icon color when selected
                                              : FlutterFlowTheme.of(context).primaryText, // Default icon color
                                          size: 20.0,
                                        ),
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            '59caj3e5' /* Creativity */, // Text for Creativity
                                          ),
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                            // Optionally change text color based on selection
                                            color: _model.selectedCategory == 'Creativity' // <<< Check for 'Creativity'
                                                ? FlutterFlowTheme.of(context).secondary // Example: Text color when selected
                                                : FlutterFlowTheme.of(context).info, // Default text color
                                            letterSpacing: 0.0,
                                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                                FlutterFlowTheme.of(context).bodyMediumFamily),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 8.0)), // Assuming .divide is an extension method you have
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Wrap the Material widget with GestureDetector
                            GestureDetector(
                              onTap: () async {
                                // Action to perform when tapped
                                setState(() {
                                  // Update the selectedCategory state in your model
                                  // Use the specific category name for this button
                                  _model.selectedCategory = 'Productivity'; // <<< Set category to 'Productivity'
                                });
                              },
                              child: Material( // The original Material widget is now the child
                                color: Colors.transparent,
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    // Update color/border based on selection
                                    color: _model.selectedCategory == 'Productivity' // <<< Check for 'Productivity'
                                        ? FlutterFlowTheme.of(context).buttonBackground // Example: Color when selected
                                        : FlutterFlowTheme.of(context).secondary, // Default color
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: _model.selectedCategory == 'Productivity' // <<< Check for 'Productivity'
                                          ? FlutterFlowTheme.of(context).primaryText // Example: Border color when selected
                                          : FlutterFlowTheme.of(context).primaryBordercolor, // Default border color
                                      width: _model.selectedCategory == 'Productivity' // <<< Check for 'Productivity'
                                          ? 2.0 // Example: Thicker border when selected
                                          : 1.0, // Default border width
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.task_alt, // Icon for Productivity
                                          // Optionally change icon color based on selection
                                          color: _model.selectedCategory == 'Productivity' // <<< Check for 'Productivity'
                                              ? FlutterFlowTheme.of(context).secondary // Example: Icon color when selected
                                              : FlutterFlowTheme.of(context).primaryText, // Default icon color
                                          size: 20.0,
                                        ),
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            'p6ycnc8w' /* Productivity */, // Text for Productivity
                                          ),
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                            // Optionally change text color based on selection
                                            color: _model.selectedCategory == 'Productivity' // <<< Check for 'Productivity'
                                                ? FlutterFlowTheme.of(context).secondary // Example: Text color when selected
                                                : FlutterFlowTheme.of(context).info, // Default text color
                                            letterSpacing: 0.0,
                                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                                FlutterFlowTheme.of(context).bodyMediumFamily),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 8.0)), // Assuming .divide is an extension method you have
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Wrap the Material widget with GestureDetector
                            GestureDetector(
                              onTap: () async {
                                // Action to perform when tapped
                                setState(() {
                                  // Update the selectedCategory state in your model
                                  // Use the specific category name for this button
                                  _model.selectedCategory = 'Mindfulness'; // <<< Set category to 'Mindfulness'
                                });
                              },
                              child: Material( // The original Material widget is now the child
                                color: Colors.transparent,
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    // Update color/border based on selection
                                    color: _model.selectedCategory == 'Mindfulness' // <<< Check for 'Mindfulness'
                                        ? FlutterFlowTheme.of(context).buttonBackground // Example: Color when selected
                                        : FlutterFlowTheme.of(context).secondary, // Default color
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: _model.selectedCategory == 'Mindfulness' // <<< Check for 'Mindfulness'
                                          ? FlutterFlowTheme.of(context).primaryText // Example: Border color when selected
                                          : FlutterFlowTheme.of(context).primaryBordercolor, // Default border color
                                      width: _model.selectedCategory == 'Mindfulness' // <<< Check for 'Mindfulness'
                                          ? 2.0 // Example: Thicker border when selected
                                          : 1.0, // Default border width
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.cloud_outlined, // Icon for Mindfulness
                                          // Optionally change icon color based on selection
                                          color: _model.selectedCategory == 'Mindfulness' // <<< Check for 'Mindfulness'
                                              ? FlutterFlowTheme.of(context).secondary // Example: Icon color when selected
                                              : FlutterFlowTheme.of(context).primaryText, // Default icon color
                                          size: 20.0,
                                        ),
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            'b5qt6f6w' /* Mindfulness */, // Text for Mindfulness
                                          ),
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                            // Optionally change text color based on selection
                                            color: _model.selectedCategory == 'Mindfulness' // <<< Check for 'Mindfulness'
                                                ? FlutterFlowTheme.of(context).secondary // Example: Text color when selected
                                                : FlutterFlowTheme.of(context).info, // Default text color
                                            letterSpacing: 0.0,
                                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                                FlutterFlowTheme.of(context).bodyMediumFamily),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 8.0)), // Assuming .divide is an extension method you have
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Text(
                          FFLocalizations.of(context).getText(
                            '66qp058a' /* Categorizing your habit helps ... */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .labelMediumFamily,
                                color: Colors.white,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.normal,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .labelMediumFamily),
                              ),
                        ),
                      ].divide(SizedBox(height: 16.0)),
                    ),
                  ].divide(SizedBox(height: 24.0)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

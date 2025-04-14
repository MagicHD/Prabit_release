import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/profile/calender/calender_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'calendar_model.dart';
export 'calendar_model.dart';
import 'package:intl/intl.dart';
import 'dart:math';

/// The calendar screen of the Prabit app is designed with a dark, elegant
/// interface that maintains consistency with the overall design language of
/// the app.
///
/// It combines minimalism with functionality, offering users a clean overview
/// of their habit-related photo entries.
///
/// At the very top, the screen title “Calendar” is displayed in bold white
/// text, aligned to the left. On the top-right corner, there's a circular
/// user icon, subtly integrated and visually balanced with the header.
///
/// Directly below, the current calendar view is titled “Photo Calendar” in
/// bold white text, accompanied by a left arrow icon for navigation. This
/// likely allows users to return to the previous screen or switch calendar
/// types. The title is centered horizontally, emphasizing the current
/// context.
///
/// The month and year, “March 2025,” appear in the next row, flanked by left
/// and right arrow icons for navigating to the previous or next month. The
/// font remains consistent with the rest of the app—white, clean, and easy to
/// read.
///
/// The calendar grid is presented in a classic layout with days of the week
/// labeled at the top: “S, M, T, W, T, F, S.” Each day is enclosed within a
/// square cell, with a slight spacing and dark border to create visual
/// separation. The empty days at the start of the month (before the 1st) are
/// rendered as blank placeholders, maintaining grid symmetry.
///
/// The calendar entries are visually enhanced with small, embedded thumbnail
/// images, giving each marked day a personalized touch. For example, on March
/// 18, a nature-themed photo covers the bottom half of the day’s square,
/// indicating a completed habit or memory associated with that date. Similar
/// thumbnails appear on the 15th and 22nd. These images create a dynamic,
/// visual record of activity and progress.
///
/// Some dates also include a small black circular badge with a white
/// number—such as “3” on the 15th and “2” on the 22nd—signaling how many
/// entries or photos are associated with that particular day.
///
/// The layout is carefully spaced, with a focus on usability and readability.
/// The dark background allows both the white text and colorful thumbnail
/// images to stand out clearly. The overall look is sleek and focused,
/// creating an intuitive and visually engaging way for users to browse their
/// progress over time.
///
/// In summary, the calendar screen combines aesthetic minimalism with
/// functional clarity. Its image-enhanced habit tracking is visually
/// compelling while remaining consistent with the dark mode and blue-accented
/// visual style that defines the Prabit app.
class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  static String routeName = 'calendar';
  static String routePath = '/calendar';

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {

  late DateTime _currentMonth;
  late List<DateTime?> _daysInGrid;

  late CalendarModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CalendarModel());
    _currentMonth = DateTime.now();
    _generateGridData();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  int _daysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }


  void _generateGridData() {
    final year = _currentMonth.year;
    final month = _currentMonth.month;

    final totalDaysInMonth = _daysInMonth(_currentMonth);
    final firstDayOfMonth = DateTime(year, month, 1);
    // Calculate weekday (Monday=1, Sunday=7), adjust to start week on Sunday (Sunday=0)
    int firstWeekdayOfMonth = firstDayOfMonth.weekday % 7;

    final List<DateTime?> days = [];

    // Add placeholders for days before the 1st of the month
    for (var i = 0; i < firstWeekdayOfMonth; i++) {
      days.add(null);
    }

    // Add actual days of the month
    for (var day = 1; day <= totalDaysInMonth; day++) {
      days.add(DateTime(year, month, day));
    }

    // Optional: Add placeholders at the end to fill the grid (usually 6 rows = 42 cells)
    // int remainingCells = 42 - days.length; // Assuming 6 rows max
    // Alternatively, calculate based on rows needed:
    int gridCells = (days.length / 7).ceil() * 7; // Calculate total cells needed for full weeks
    int remainingCells = max(0, gridCells - days.length); // Ensure non-negative

    for (var i = 0; i < remainingCells; i++) {
      days.add(null);
    }


    setState(() {
      _daysInGrid = days;
    });
  }

  void _changeMonth(int direction) {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + direction, 1);
      _generateGridData(); // Regenerate grid for the new month
    });
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
        backgroundColor: Color(0xFF14181B),
        appBar: AppBar(
          backgroundColor: Color(0xFF14181B),
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: EdgeInsets.all(8.0),
            child: FlutterFlowIconButton(
              borderRadius: 20.0,
              buttonSize: 40.0,
              fillColor: Color(0xFF2D3035),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20.0,
              ),
              onPressed: () async {
                context.safePop();
              },
            ),
          ),
          title: Text(
            FFLocalizations.of(context).getText(
              '1by656i7' /* Calendar */,
            ),
            style: FlutterFlowTheme.of(context).headlineSmall.override(
                  fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
                  letterSpacing: 0.0,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                      FlutterFlowTheme.of(context).headlineSmallFamily),
                ),
          ),
          actions: [
            Container(
              width: 36.0,
              height: 36.0,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.network(
                '\"500x500?person#1\"',
                fit: BoxFit.cover,
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary,
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 24.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 40.0,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlutterFlowIconButton(
                          borderRadius: 20.0,
                          buttonSize: 40.0,
                          fillColor: Color(0xFF2D3035),
                          icon: Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          onPressed: () {
                            _changeMonth(-1);
                          },
                        ),
                        Text(
                          DateFormat('MMMM yyyy').format(_currentMonth),
                          style: FlutterFlowTheme.of(context)
                              .titleMedium
                              .override(
                                fontFamily: 'Inter',
                                color: Colors.white,
                                fontSize: 18.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                useGoogleFonts:
                                    GoogleFonts.asMap().containsKey('Inter'),
                              ),
                        ),
                        FlutterFlowIconButton(
                          borderRadius: 20.0,
                          buttonSize: 40.0,
                          fillColor: Color(0xFF2D3035),
                          icon: Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          onPressed: () {
                            _changeMonth(1);
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          FFLocalizations.of(context).getText(
                            '177k9c8v' /* S */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Inter',
                                color: Colors.white,
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.normal,
                                useGoogleFonts:
                                    GoogleFonts.asMap().containsKey('Inter'),
                              ),
                        ),
                        Text(
                          FFLocalizations.of(context).getText(
                            'ufrpfnpk' /* M */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Inter',
                                color: Colors.white,
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.normal,
                                useGoogleFonts:
                                    GoogleFonts.asMap().containsKey('Inter'),
                              ),
                        ),
                        Text(
                          FFLocalizations.of(context).getText(
                            'yp2erjj3' /* T */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Inter',
                                color: Colors.white,
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.normal,
                                useGoogleFonts:
                                    GoogleFonts.asMap().containsKey('Inter'),
                              ),
                        ),
                        Text(
                          FFLocalizations.of(context).getText(
                            'i58o23eb' /* W */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Inter',
                                color: Colors.white,
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.normal,
                                useGoogleFonts:
                                    GoogleFonts.asMap().containsKey('Inter'),
                              ),
                        ),
                        Text(
                          FFLocalizations.of(context).getText(
                            'hynvrs95' /* T */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Inter',
                                color: Colors.white,
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.normal,
                                useGoogleFonts:
                                    GoogleFonts.asMap().containsKey('Inter'),
                              ),
                        ),
                        Text(
                          FFLocalizations.of(context).getText(
                            '4rjz0t0e' /* F */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Inter',
                                color: Colors.white,
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.normal,
                                useGoogleFonts:
                                    GoogleFonts.asMap().containsKey('Inter'),
                              ),
                        ),
                        Text(
                          FFLocalizations.of(context).getText(
                            '1s4y3l7p' /* S */,
                          ),
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Inter',
                                color: Colors.white,
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.normal,
                                useGoogleFonts:
                                    GoogleFonts.asMap().containsKey('Inter'),
                              ),
                        ),
                      ],
                    ),
                  ),
                  // Replace the entire existing GridView(...) block with this:
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: _daysInGrid.length, // Use the dynamic list count
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // Add if GridView is inside a Column/ScrollView
                    itemBuilder: (context, index) {
                      final dateTime = _daysInGrid[index]; // Get DateTime or null

                      if (dateTime == null) {
                        // It's a placeholder cell
                        return Container(
                          width: 45.0,
                          height: 45.0,
                          decoration: BoxDecoration(
                            // Use a subtle background for placeholders
                            color: Color(0x1AFFFFFF), // Semi-transparent white or another theme color
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        );
                      } else {
                        // It's a valid day, use your CalenderWidget
                        // Ensure the import path for CalenderWidget is correct
                        return CalenderWidget(
                          key: ValueKey(dateTime), // Add a key for better state management
                          date: dateTime, // Pass the DateTime for this day
                        );
                      }
                    },
                  )
                  // --- End of GridView replacement ---
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

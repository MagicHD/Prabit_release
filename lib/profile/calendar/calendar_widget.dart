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
  late CalendarModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CalendarModel());
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
                            print('IconButton pressed ...');
                          },
                        ),
                        Text(
                          FFLocalizations.of(context).getText(
                            'qila67g3' /* March 2025 */,
                          ),
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
                            print('IconButton pressed ...');
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
                  GridView(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 1.0,
                    ),
                    shrinkWrap: true,
                    children: [
                      wrapWithModel(
                        model: _model.calenderModel,
                        updateCallback: () => safeSetState(() {}),
                        child: CalenderWidget(
                          date: '22/22/22',
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondary,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondary,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondary,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondary,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              '4qj321w0' /* 1 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondary,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'jn8sj7b4' /* 2 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondary,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              '5obmi5ju' /* 3 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondary,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              's3hxx9tj' /* 4 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondary,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'e6zaqfuc' /* 5 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondary,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              '6ttaw8xf' /* 6 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondary,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'k5soyhgt' /* 7 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondary,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'uuvvq7xg' /* 8 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D3035),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'g54285j5' /* 9 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D3035),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'ibv418ck' /* 11 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D3035),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'uz8d7glt' /* 12 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D3035),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'xwdtwmgx' /* 13 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D3035),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'v47dxaoi' /* 14 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D3035),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  'nyqax5i2' /* 15 */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.normal,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey('Inter'),
                                    ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 1.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0.0),
                                child: Image.network(
                                  'https://images.unsplash.com/photo-1595225386386-79c3543adbd9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw0fHxtZWNoYW5pY2FsJTIwa2V5Ym9hcmR8ZW58MHx8fHwxNzQzODM3MjcwfDA&ixlib=rb-4.0.3&q=80&w=1080',
                                  width: 45.0,
                                  height: 22.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(1.0, -1.0),
                              child: Container(
                                width: 16.0,
                                height: 16.0,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      FFLocalizations.of(context).getText(
                                        'fkyy5wq5' /* 3 */,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            fontFamily: 'Inter',
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey('Inter'),
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D3035),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'bzdt9s1p' /* 16 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D3035),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'wfhih6hk' /* 17 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D3035),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  '6jeepcrh' /* 18 */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.normal,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey('Inter'),
                                    ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 1.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0.0),
                                child: Image.network(
                                  '\"500x500?nature#2\"',
                                  width: 45.0,
                                  height: 22.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D3035),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'l98l1wkr' /* 19 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D3035),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              '5c4u5gc1' /* 20 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D3035),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'lwbsj8pm' /* 21 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D3035),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  'a1syk1w3' /* 22 */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.normal,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey('Inter'),
                                    ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 1.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0.0),
                                child: Image.network(
                                  '\"500x500?nature#3\"',
                                  width: 45.0,
                                  height: 22.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(1.0, -1.0),
                              child: Container(
                                width: 16.0,
                                height: 16.0,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      FFLocalizations.of(context).getText(
                                        'scann1ne' /* 2 */,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            fontFamily: 'Inter',
                                            color: Colors.white,
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey('Inter'),
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D3035),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'uk5vf7wf' /* 23 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D3035),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'u0v8xomu' /* 24 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D3035),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              '1hwjpcfq' /* 25 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D3035),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              '4x0db481' /* 26 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D3035),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              '7je9ecp1' /* 27 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D3035),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              '77iidrvy' /* 28 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D3035),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'fskyvbv4' /* 29 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D3035),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'urmmp82a' /* 30 */,
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
                        ),
                      ),
                      Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2D3035),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            FFLocalizations.of(context).getText(
                              'lm7c2zg4' /* 31 */,
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
                        ),
                      ),
                    ],
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

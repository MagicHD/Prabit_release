import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/profile/friendlistitem/friendlistitem_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'profilescreen_model.dart';
export 'profilescreen_model.dart';

/// The profile screen of the Prabit app follows the same dark mode design
/// principles as the feed, with a sleek and minimal aesthetic that emphasizes
/// clarity, usability, and modern visual appeal.
///
/// At the top of the screen, the title “My Profile” is displayed in bold
/// white text, centered at the top-left. Flanking the header are two compact,
/// icon-based buttons: one for calendar access (likely to view habit history
/// or logs) and one for settings. These icons are white and subtly integrated
/// into the top bar without overpowering the layout.
///
/// The central area of the screen showcases the user’s profile card. A large
/// circular profile placeholder marked with the user’s initials ("PU") is
/// centered at the top of the card, with a thin blue outline that adds a
/// visual pop against the dark background. Beneath the avatar, the username
/// is displayed in bold white ("prabit_user"), followed by a smaller, gray
/// subtext indicating membership status: “Member since Apr 2025.” Below that
/// is a brief personal description in light gray text: “I'm tracking my
/// habits and making progress every day!”
///
/// Two clear and equally spaced buttons sit beneath the profile
/// information—“Edit Profile” and “Share Profile.” These buttons use
/// rectangular pill-shaped designs with subtle shadows and high contrast.
/// “Edit Profile” has a bordered style with a transparent background, while
/// “Share Profile” has a filled black background, maintaining the visual
/// language of the app.
///
/// Further down, the screen includes a segmented tab view with three options:
/// “Friends,” “Requests,” and “Add.” The currently selected tab (“Friends”)
/// is highlighted with a solid black background and white bold text, while
/// the others are dimmed but still clearly visible. The tab bar maintains a
/// consistent layout with the rest of the app, using rounded edges and
/// balanced spacing.
///
/// In the Friends tab, user entries are displayed as vertically stacked
/// cards. Each entry shows a circular avatar with user initials (for example,
/// “AF” for Alex Fitness and “MG” for Mindfulness Guide), along with the full
/// display name in bold white and the handle below it in a smaller gray font.
/// The design is simple and intuitive, allowing users to quickly scan their
/// friends list.
///
/// Overall, the profile screen design is consistent with the rest of the
/// app’s visual identity: dark-themed with blue accent highlights, rounded
/// and spaced elements, and an emphasis on clarity and accessibility. The
/// interface feels personal, approachable, and modern—well-suited for a
/// habit-tracking and social wellness application.
class ProfilescreenWidget extends StatefulWidget {
  const ProfilescreenWidget({super.key});

  static String routeName = 'Profilescreen';
  static String routePath = '/profilescreen';

  @override
  State<ProfilescreenWidget> createState() => _ProfilescreenWidgetState();
}

class _ProfilescreenWidgetState extends State<ProfilescreenWidget> {
  late ProfilescreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfilescreenModel());
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
          title: Text(
            FFLocalizations.of(context).getText(
              'qfklgi1u' /* My Profile */,
            ),
            style: FlutterFlowTheme.of(context).displaySmall.override(
                  fontFamily: FlutterFlowTheme.of(context).displaySmallFamily,
                  letterSpacing: 0.0,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                      FlutterFlowTheme.of(context).displaySmallFamily),
                ),
          ),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  FlutterFlowIconButton(
                    borderRadius: 20.0,
                    buttonSize: 40.0,
                    icon: Icon(
                      Icons.calendar_today_rounded,
                      color: FlutterFlowTheme.of(context).info,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      context.pushNamed(CalendarWidget.routeName);
                    },
                  ),
                  FlutterFlowIconButton(
                    borderRadius: 20.0,
                    buttonSize: 40.0,
                    icon: Icon(
                      Icons.settings_rounded,
                      color: FlutterFlowTheme.of(context).info,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      context.pushNamed(SettingsWidget.routeName);
                    },
                  ),
                ].divide(SizedBox(width: 8.0)),
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
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0.0),
                bottomRight: Radius.circular(0.0),
                topLeft: Radius.circular(0.0),
                topRight: Radius.circular(0.0),
              ),
              border: Border.all(
                color: FlutterFlowTheme.of(context).primary,
                width: 0.0,
              ),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              color: Color(0xFF2E353E),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFF0D6DFD),
                                width: 2.0,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                FFLocalizations.of(context).getText(
                                  'pappnzlc' /* prabit_user */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .titleLarge
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .titleLargeFamily,
                                      color: FlutterFlowTheme.of(context).info,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .titleLargeFamily),
                                    ),
                              ),
                              Text(
                                FFLocalizations.of(context).getText(
                                  '6z20lrxo' /* Member since Apr 2025 */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .labelMediumFamily,
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .labelMediumFamily),
                                    ),
                              ),
                              Text(
                                FFLocalizations.of(context).getText(
                                  '8i56dofc' /* I'm tracking my habits and mak... */,
                                ),
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      fontFamily: FlutterFlowTheme.of(context)
                                          .bodySmallFamily,
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodySmallFamily),
                                    ),
                              ),
                            ].divide(SizedBox(height: 4.0)),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              FFButtonWidget(
                                onPressed: () {
                                  print('Button pressed ...');
                                },
                                text: FFLocalizations.of(context).getText(
                                  '6h0iakqi' /* Edit Profile */,
                                ),
                                options: FFButtonOptions(
                                  width: 110.0,
                                  height: 40.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context)
                                      .buttonBackground,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color:
                                            FlutterFlowTheme.of(context).info,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                  elevation: 0.0,
                                  borderSide: BorderSide(
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(9.5),
                                ),
                              ),
                              FFButtonWidget(
                                onPressed: () {
                                  print('Button pressed ...');
                                },
                                text: FFLocalizations.of(context).getText(
                                  's13acu56' /* Share Profile */,
                                ),
                                options: FFButtonOptions(
                                  width: 110.0,
                                  height: 40.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context)
                                      .buttonBackground,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color:
                                            FlutterFlowTheme.of(context).info,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                  elevation: 0.0,
                                  borderSide: BorderSide(
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(9.5),
                                ),
                              ),
                            ].divide(SizedBox(width: 16.0)),
                          ),
                        ].divide(SizedBox(height: 16.0)),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 100.0,
                        height: 36.0,
                        decoration: BoxDecoration(
                          color: Color(0xFF2E353E),
                          borderRadius: BorderRadius.circular(10.5),
                          border: Border.all(
                            color:
                                FlutterFlowTheme.of(context).primaryBordercolor,
                          ),
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              FFLocalizations.of(context).getText(
                                'wx5w9agc' /* Friends */,
                              ),
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: FlutterFlowTheme.of(context).info,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                  ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 100.0,
                        height: 36.0,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10.5),
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              FFLocalizations.of(context).getText(
                                'zbaa0guh' /* Requests */,
                              ),
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                  ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 100.0,
                        height: 36.0,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10.5),
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              FFLocalizations.of(context).getText(
                                'my4enr56' /* Add */,
                              ),
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: FlutterFlowTheme.of(context)
                                        .bodyMediumFamily,
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        borderRadius: BorderRadius.circular(9.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ListView(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              children: [
                                wrapWithModel(
                                  model: _model.friendlistitemModel1,
                                  updateCallback: () => safeSetState(() {}),
                                  child: FriendlistitemWidget(),
                                ),
                                wrapWithModel(
                                  model: _model.friendlistitemModel2,
                                  updateCallback: () => safeSetState(() {}),
                                  child: FriendlistitemWidget(),
                                ),
                                wrapWithModel(
                                  model: _model.friendlistitemModel3,
                                  updateCallback: () => safeSetState(() {}),
                                  child: FriendlistitemWidget(),
                                ),
                              ].divide(SizedBox(height: 12.0)),
                            ),
                          ].divide(SizedBox(height: 16.0)),
                        ),
                      ),
                    ),
                  ),
                ].divide(SizedBox(height: 24.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

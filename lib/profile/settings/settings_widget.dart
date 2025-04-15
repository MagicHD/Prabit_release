import 'package:firebase_auth/firebase_auth.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'privacy_policy_screen.dart'; // Adjust path if necessary


import 'settings_model.dart';
export 'settings_model.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({super.key});

  static String routeName = 'settings';
  static String routePath = '/settings';

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  late SettingsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SettingsModel());
    _model.switchValue = true;
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _viewLegalNotice(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        title: Text(
          'Legal Notice',
          style: FlutterFlowTheme.of(context).titleLarge.override(
            fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
            color: FlutterFlowTheme.of(context).primaryText,
            letterSpacing: 0.0,
            useGoogleFonts: GoogleFonts.asMap().containsKey(
                FlutterFlowTheme.of(context).titleLargeFamily),
          ),
        ),
        content: Text(
          'Company Name: Paul Sammet und Levin Krieger GbR\n'
              'Address: Ölspielstraße 47, 97286 Sommerhausen, Germany\n'
              'Email: support@prabit.tech',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
            color: FlutterFlowTheme.of(context).secondaryText,
            letterSpacing: 0.0,
            useGoogleFonts: GoogleFonts.asMap().containsKey(
                FlutterFlowTheme.of(context).bodyMediumFamily),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(color: FlutterFlowTheme.of(context).primary),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // IMPORTANT: Replace 'LoginScreenWidget.routeName' with the actual route NAME of your login screen
      context.goNamed(LoginScreenWidget.routeName);
    } catch (error) {
      print("Logout Error: $error");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error logging out: $error',
            // Changed from primaryBtnText to Colors.white
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    // --- The rest of the build method remains the same as the previous version ---
    // --- Make sure to paste the ENTIRE build method from the previous correct version here ---
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primary, // Adapt if needed
        appBar: AppBar(
          backgroundColor: Color(0xFF14181B), // Keep existing style
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 20,
            borderWidth: 1,
            buttonSize: 40,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () async {
              context.safePop();
            },
          ),
          title: Text(
            FFLocalizations.of(context).getText(
              'lk39x5at' /* Settings */,
            ),
            style: FlutterFlowTheme.of(context).headlineSmall.override(
              fontFamily: FlutterFlowTheme.of(context).headlineSmallFamily,
              color: Colors.white,
              letterSpacing: 0.0,
              useGoogleFonts: GoogleFonts.asMap().containsKey(
                  FlutterFlowTheme.of(context).headlineSmallFamily),
            ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- SUPPORT Section ---
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        FFLocalizations.of(context).getText(
                          'cyi02yrp' /* SUPPORT */,
                        ),
                        style: FlutterFlowTheme.of(context).labelSmall.override(
                          fontFamily:
                          FlutterFlowTheme.of(context).labelSmallFamily,
                          color: Color(0xFF8D8D8D),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context)
                                  .labelSmallFamily),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          // Navigate to the support screen you provided
                          context.pushNamed(SupportScreenWidget.routeName);
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground, // Adapt theme color
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFF3C3F43), // Adapt theme color
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF2A2E33), // Adapt theme color
                                        shape: BoxShape.circle,
                                      ),
                                      child: Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Icon(
                                          Icons.chat_bubble_outline_rounded,
                                          color: Color(0xFF3B82F6), // Adapt theme color
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      FFLocalizations.of(context).getText(
                                        '0djp10fi' /* Contact Us */,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                        color: FlutterFlowTheme.of(context).primaryText, // Adapt theme color
                                        letterSpacing: 0.0,
                                        useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 12)),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: Color(0xFF8D8D8D), // Adapt theme color
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ].divide(SizedBox(height: 12)),
                  ),

                  // --- LEGAL Section ---
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        FFLocalizations.of(context).getText(
                          'qg4ucjhk' /* LEGAL */,
                        ),
                        style: FlutterFlowTheme.of(context).labelSmall.override(
                          fontFamily:
                          FlutterFlowTheme.of(context).labelSmallFamily,
                          color: Color(0xFF8D8D8D),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context)
                                  .labelSmallFamily),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground, // Adapt theme color
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFF3C3F43), // Adapt theme color
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  _viewLegalNotice(context);
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF2A2E33), // Adapt theme color
                                              shape: BoxShape.circle,
                                            ),
                                            child: Align(
                                              alignment: AlignmentDirectional(0, 0),
                                              child: Icon(
                                                Icons.menu_book_outlined,
                                                color: Color(0xFF3B82F6), // Adapt theme color
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            FFLocalizations.of(context).getText('eb5xlt4v' /* Legal Notice */,),
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                              color: FlutterFlowTheme.of(context).primaryText, // Adapt theme color
                                              letterSpacing: 0.0,
                                              useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                            ),
                                          ),
                                        ].divide(SizedBox(width: 12)),
                                      ),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: Color(0xFF8D8D8D), // Adapt theme color
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                height: 1,
                                thickness: 1,
                                indent: 16,
                                endIndent: 16,
                                color: Color(0xFF3C3F43), // Adapt theme color
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async { // <<<--- Make it async if needed by navigation
                                  // Navigate to the PrivacyPolicyScreen
                                  // If using named routes and FlutterFlow router:
                                  context.pushNamed(PrivacyPolicyScreen.routeName);

                                  // Or if using standard Flutter navigation:
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                                  // );
                                }, // <<<--- End of updated onTap
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF2A2E33), // Adapt theme color
                                              shape: BoxShape.circle,
                                            ),
                                            child: Align(
                                              alignment: AlignmentDirectional(0, 0),
                                              child: Icon(
                                                Icons.lock_outline_rounded,
                                                color: Color(0xFF9333EA), // Adapt theme color
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            FFLocalizations.of(context).getText('4vqvhygk' /* Privacy Policy */,),
                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                              color: FlutterFlowTheme.of(context).primaryText, // Adapt theme color
                                              letterSpacing: 0.0,
                                              useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                            ),
                                          ),
                                        ].divide(SizedBox(width: 12)),
                                      ),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: Color(0xFF8D8D8D), // Adapt theme color
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ].divide(SizedBox(height: 12)),
                  ),

                  // --- Theme Switch ---
                  Switch.adaptive(
                    value: _model.switchValue!,
                    onChanged: (newValue) async {
                      safeSetState(() => _model.switchValue = newValue!);
                      if (newValue!) {
                        setDarkModeSetting(context, ThemeMode.dark);
                      } else {
                        setDarkModeSetting(context, ThemeMode.light);
                      }
                    },
                    activeColor: FlutterFlowTheme.of(context).primary,
                    activeTrackColor: FlutterFlowTheme.of(context).accent1,
                    inactiveTrackColor: FlutterFlowTheme.of(context).alternate,
                    inactiveThumbColor: FlutterFlowTheme.of(context).secondaryBackground,
                  ),

                  // --- ACCOUNT Section ---
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        FFLocalizations.of(context).getText(
                          '11if3nk1' /* ACCOUNT */,
                        ),
                        style: FlutterFlowTheme.of(context).labelSmall.override(
                          fontFamily: FlutterFlowTheme.of(context).labelSmallFamily,
                          color: Color(0xFF8D8D8D),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelSmallFamily),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          _handleLogout(context);
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondaryBackground, // Adapt theme color
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFF3C3F43), // Adapt theme color
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF2A2E33), // Adapt theme color
                                        shape: BoxShape.circle,
                                      ),
                                      child: Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Icon(
                                          Icons.logout_rounded,
                                          color: Color(0xFFFF5963), // Adapt theme color (red)
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      FFLocalizations.of(context).getText('o8z58kus' /* Log Out */,),
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                        color: Color(0xFFFF5963), // Adapt theme color (red)
                                        letterSpacing: 0.0,
                                        useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 12)),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: Color(0xFF8D8D8D), // Adapt theme color
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ].divide(SizedBox(height: 12)),
                  ),

                  // --- CREDITS Section ---
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        FFLocalizations.of(context).getText('xhlmnyuv' /* CREDITS */,),
                        style: FlutterFlowTheme.of(context).labelSmall.override(
                          fontFamily: FlutterFlowTheme.of(context).labelSmallFamily,
                          color: Color(0xFF8D8D8D),
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelSmallFamily),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              FFLocalizations.of(context).getText('44vyrai6' /* Design & Development */,),
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).primaryText, // Adapt theme color
                                letterSpacing: 0.0,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                              child: Text(
                                FFLocalizations.of(context).getText('9swjw4fn' /* Prabit Team */,),
                                style: FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                  color: Color(0xFF8D8D8D), // Adapt theme color
                                  letterSpacing: 0.0,
                                  useGoogleFonts: GoogleFonts.asMap().containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ].divide(SizedBox(height: 8)),
                  ),
                ].divide(SizedBox(height: 24)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
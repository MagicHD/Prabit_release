import 'package:firebase_auth/firebase_auth.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_language_selector.dart'; // Needed for language selector
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart'; // Make sure this imports everything needed (SupportScreenWidget, PrivacyPolicyScreen, LoginScreenWidget etc.)
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
    // Note: Removed initialization for _model.switchValue
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // Function to show the Legal Notice Dialog
  void _viewLegalNotice(BuildContext context) {
    final theme = FlutterFlowTheme.of(context); // Access theme
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.secondaryBackground,
        title: Text(
          // Assuming you have a localization key for 'Legal Notice'
          FFLocalizations.of(context).getText('eb5xlt4v' /* Legal Notice */),
          style: theme.titleLarge.override(
            fontFamily: theme.titleLargeFamily,
            color: theme.primaryText,
            letterSpacing: 0.0,
            useGoogleFonts: GoogleFonts.asMap()
                .containsKey(theme.titleLargeFamily),
          ),
        ),
        content: Text(
          // Consider making this text localizable too if needed
          'Company Name: Paul Sammet und Levin Krieger GbR\n'
              'Address: Ölspielstraße 47, 97286 Sommerhausen, Germany\n'
              'Email: support@prabit.tech',
          style: theme.bodyMedium.override(
            fontFamily: theme.bodyMediumFamily,
            color: theme.secondaryText,
            letterSpacing: 0.0,
            useGoogleFonts: GoogleFonts.asMap()
                .containsKey(theme.bodyMediumFamily),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              // Assuming you have a localization key for 'Close'
              'Close', // Replace with FFLocalizations if needed
              style: TextStyle(color: theme.primary), // Use theme color
            ),
          ),
        ],
      ),
    );
  }

  // Function to handle Logout
  Future<void> _handleLogout(BuildContext context) async {
    final theme = FlutterFlowTheme.of(context); // Access theme
    try {
      await FirebaseAuth.instance.signOut();
      // Verify 'LoginScreenWidget.routeName' is correct
      context.goNamed(LoginScreenWidget.routeName);
    } catch (error) {
      print("Logout Error: $error");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error logging out: $error',
            style: TextStyle(color: theme.info), // Use theme color
          ),
          backgroundColor: theme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access theme once
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primary,
        appBar: AppBar(
          backgroundColor: theme.primaryBackground, // Use theme color
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 20,
            borderWidth: 1,
            buttonSize: 40,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: theme.info,
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
            style: theme.headlineSmall.override(
              fontFamily: theme.headlineSmallFamily,
              color: theme.info,
              letterSpacing: 0.0,
              useGoogleFonts:
              GoogleFonts.asMap().containsKey(theme.headlineSmallFamily),
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
                        style: theme.labelSmall.override(
                          fontFamily: theme.labelSmallFamily,
                          color: theme.secondaryText,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts:
                          GoogleFonts.asMap().containsKey(theme.labelSmallFamily),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed(SupportScreenWidget.routeName);
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: theme.secondaryBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.alternate,
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
                                        color: theme.primaryBackground,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Icon(
                                          Icons.chat_bubble_outline_rounded,
                                          color: theme.buttonBackground,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                      child: Text(
                                        FFLocalizations.of(context).getText(
                                          '0djp10fi' /* Contact Us */,
                                        ),
                                        style: theme.bodyMedium.override(
                                          fontFamily: theme.bodyMediumFamily,
                                          color: theme.primaryText,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(theme.bodyMediumFamily),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: theme.secondaryText,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ].divide(SizedBox(height: 12)),
                  ),

                  // --- LANGUAGE Section (Updated Layout) ---
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // Use the localization key you created
                        FFLocalizations.of(context).getText(
                          'settingsLanguageSectionHeader' /* LANGUAGE */,
                        ),
                        style: theme.labelSmall.override(
                          fontFamily: theme.labelSmallFamily,
                          color: theme.secondaryText,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts:
                          GoogleFonts.asMap().containsKey(theme.labelSmallFamily),
                        ),
                      ),
                      // Container for the language row, styled like others
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.secondaryBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.alternate,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding inside row
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Icon and Label part
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: theme.primaryBackground,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Align(
                                      alignment: AlignmentDirectional(0, 0),
                                      child: Icon(
                                        Icons.language_rounded,
                                        color: theme.buttonBackground,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    // Use the localization key you created
                                    FFLocalizations.of(context).getText(
                                      'settingsLanguageRowLabel' /* Language */,
                                    ),
                                    style: theme.bodyMedium.override(
                                      fontFamily: theme.bodyMediumFamily,
                                      color: theme.primaryText,
                                      letterSpacing: 0.0,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(theme.bodyMediumFamily),
                                    ),
                                  ),
                                ],
                              ),

                              // Language Selector Widget replaces the chevron
                              FlutterFlowLanguageSelector(
                                width: 150, // Adjust width as needed or remove for auto-sizing
                                height: 40, // Adjust height as needed or remove for auto-sizing
                                backgroundColor: theme.secondaryBackground, // Match row background
                                borderColor: Colors.transparent, // No border for the selector itself
                                dropdownIconColor: theme.secondaryText, // Icon color
                                borderRadius: 8.0, // Optional: round corners
                                textStyle: theme.bodyMedium.override( // Style for selected language text
                                  fontFamily: theme.bodyMediumFamily,
                                  color: theme.primaryText, // Text color
                                  letterSpacing: 0.0,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(theme.bodyMediumFamily),
                                ),
                                hideFlags: true,
                                flagSize: 24,
                                flagTextGap: 8,
                                currentLanguage:
                                FFLocalizations.of(context).languageCode,
                                languages: FFLocalizations.languages(),
                                onChanged: (lang) => setAppLanguage(context, lang),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ].divide(SizedBox(height: 12)), // Spacing after header
                  ),
                  // --- End of LANGUAGE Section ---


                  // --- LEGAL Section ---
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        FFLocalizations.of(context).getText(
                          'qg4ucjhk' /* LEGAL */,
                        ),
                        style: theme.labelSmall.override(
                          fontFamily: theme.labelSmallFamily,
                          color: theme.secondaryText,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts:
                          GoogleFonts.asMap().containsKey(theme.labelSmallFamily),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.secondaryBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.alternate,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell( // Legal Notice Row
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
                                            color: theme.primaryBackground,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Align(
                                            alignment: AlignmentDirectional(0, 0),
                                            child: Icon(
                                              Icons.menu_book_outlined,
                                              color: theme.buttonBackground,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                          child: Text(
                                            FFLocalizations.of(context).getText(
                                              'eb5xlt4v' /* Legal Notice */,
                                            ),
                                            style: theme.bodyMedium.override(
                                              fontFamily: theme.bodyMediumFamily,
                                              color: theme.primaryText,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: GoogleFonts.asMap()
                                                  .containsKey(theme.bodyMediumFamily),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      color: theme.secondaryText,
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
                              color: theme.alternate,
                            ),
                            InkWell( // Privacy Policy Row
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context.pushNamed(PrivacyPolicyScreen.routeName);
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
                                            color: theme.primaryBackground,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Align(
                                            alignment: AlignmentDirectional(0, 0),
                                            child: Icon(
                                              Icons.lock_outline_rounded,
                                              color: Color(0xFF9333EA), // Keep specific color or use theme.primary?
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                          child: Text(
                                            FFLocalizations.of(context).getText(
                                              '4vqvhygk' /* Privacy Policy */,
                                            ),
                                            style: theme.bodyMedium.override(
                                              fontFamily: theme.bodyMediumFamily,
                                              color: theme.primaryText,
                                              letterSpacing: 0.0,
                                              useGoogleFonts: GoogleFonts.asMap()
                                                  .containsKey(theme.bodyMediumFamily),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      color: theme.secondaryText,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ].divide(SizedBox(height: 12)),
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
                        style: theme.labelSmall.override(
                          fontFamily: theme.labelSmallFamily,
                          color: theme.secondaryText,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts:
                          GoogleFonts.asMap().containsKey(theme.labelSmallFamily),
                        ),
                      ),
                      InkWell( // Log Out Row
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
                            color: theme.secondaryBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.alternate,
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
                                        color: theme.primaryBackground,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Icon(
                                          Icons.logout_rounded,
                                          color: theme.error,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                                      child: Text(
                                        FFLocalizations.of(context).getText(
                                          'o8z58kus' /* Log Out */,
                                        ),
                                        style: theme.bodyMedium.override(
                                          fontFamily: theme.bodyMediumFamily,
                                          color: theme.error,
                                          letterSpacing: 0.0,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(theme.bodyMediumFamily),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: theme.secondaryText,
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
                        FFLocalizations.of(context).getText(
                          'xhlmnyuv' /* CREDITS */,
                        ),
                        style: theme.labelSmall.override(
                          fontFamily: theme.labelSmallFamily,
                          color: theme.secondaryText,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          useGoogleFonts:
                          GoogleFonts.asMap().containsKey(theme.labelSmallFamily),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              FFLocalizations.of(context).getText(
                                '44vyrai6' /* Design & Development */,
                              ),
                              style: theme.bodyMedium.override(
                                fontFamily: theme.bodyMediumFamily,
                                color: theme.primaryText,
                                letterSpacing: 0.0,
                                useGoogleFonts: GoogleFonts.asMap()
                                    .containsKey(theme.bodyMediumFamily),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  '9swjw4fn' /* Prabit Team */,
                                ),
                                style: theme.labelMedium.override(
                                  fontFamily: theme.labelMediumFamily,
                                  color: theme.secondaryText,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(theme.labelMediumFamily),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ].divide(SizedBox(height: 8)),
                  ),
                ].divide(SizedBox(height: 24)), // Spacing between major sections
              ),
            ),
          ),
        ),
      ),
    );
  }
}
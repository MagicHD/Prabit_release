import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'settings_model.dart';
export 'settings_model.dart';

/// The settings screen of the Prabit app is clean, minimal, and purposefully
/// structured, following the app’s established dark mode design language.
///
/// It uses simple yet effective visual hierarchy to separate different
/// sections—support, legal, account, and credits—making navigation intuitive
/// and user-friendly. At the very top, the screen displays the title
/// “Settings” in bold white text, left-aligned for clarity. A back arrow icon
/// to the left allows users to return to the previous screen, preserving
/// navigation consistency across the app. The screen is divided into four
/// clearly labeled sections: Support, Legal, Account, and Credits. Each
/// section label is rendered in small uppercase gray text, providing contrast
/// without dominating the visual space. Support Section Contains a single
/// item: Contact Us The button is styled with a dark background and soft
/// border, containing a blue chat bubble icon on the left, white label text,
/// and a right arrow to indicate navigation. This section offers users a way
/// to reach out for help or feedback. Legal Section Contains two items: Legal
/// Notice and Privacy Policy Each option uses a similar layout and
/// interaction pattern as the Support section, but with different icons: A
/// blue book icon for Legal Notice A purple padlock icon for Privacy Policy
/// These provide quick access to legal information while maintaining visual
/// distinction through color and iconography. Account Section Contains a
/// single item: Log Out This button is styled differently from the others to
/// reflect its critical function. It uses a red arrow icon and red text, set
/// against a dark background to stand out visually. It signals an
/// irreversible action and is visually distinct to avoid accidental taps.
/// Credits Section Located at the bottom of the screen, this section is
/// visually minimal. It contains a simple label: Design & Development with
/// the subtitle Prabit Team The section uses white text on a dark background,
/// possibly for acknowledgment or branding. Summary The settings screen is
/// designed with clarity and usability in mind. Each option is laid out in a
/// touch-friendly block with consistent padding, spacing, and visual feedback
/// cues. The use of icons and color-coded sections enhances the user
/// experience, making it easy to scan and interact with the content. The
/// visual simplicity, combined with strong organizational structure, makes
/// this screen an effective and essential part of the overall Prabit app
/// experience.
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
          backgroundColor: Color(0xFF1A1F24),
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
                          context.pushNamed(SupportScreenWidget.routeName);
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).secondary,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFF3C3F43),
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
                                        color: Color(0xFF2A2E33),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Icon(
                                          Icons.chat_bubble_outline_rounded,
                                          color: Color(0xFF3B82F6),
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
                                        fontFamily:
                                        FlutterFlowTheme.of(context)
                                            .bodyMediumFamily,
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 12)),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  color: Color(0xFF8D8D8D),
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ].divide(SizedBox(height: 12)),
                  ),
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
                          color: FlutterFlowTheme.of(context).secondary,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFF3C3F43),
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF2A2E33),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Align(
                                            alignment:
                                            AlignmentDirectional(0, 0),
                                            child: Icon(
                                              Icons.menu_book_outlined,
                                              color: Color(0xFF3B82F6),
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            'eb5xlt4v' /* Legal Notice */,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily:
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily,
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: GoogleFonts
                                                .asMap()
                                                .containsKey(
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 12)),
                                    ),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      color: Color(0xFF8D8D8D),
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 1,
                                thickness: 1,
                                indent: 16,
                                endIndent: 16,
                                color: Color(0xFF3C3F43),
                              ),
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF2A2E33),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Align(
                                            alignment:
                                            AlignmentDirectional(0, 0),
                                            child: Icon(
                                              Icons.lock_outline_rounded,
                                              color: Color(0xFF9333EA),
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          FFLocalizations.of(context).getText(
                                            '4vqvhygk' /* Privacy Policy */,
                                          ),
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                            fontFamily:
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily,
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                            useGoogleFonts: GoogleFonts
                                                .asMap()
                                                .containsKey(
                                                FlutterFlowTheme.of(
                                                    context)
                                                    .bodyMediumFamily),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 12)),
                                    ),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      color: Color(0xFF8D8D8D),
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ].divide(SizedBox(height: 12)),
                  ),
                  Switch.adaptive(
                    value: _model.switchValue!,
                    onChanged: (newValue) async {
                      safeSetState(() => _model.switchValue = newValue!);
                      if (newValue!) {
                        setDarkModeSetting(context, ThemeMode.dark);
                      }
                    },
                    activeColor: FlutterFlowTheme.of(context).primary,
                    activeTrackColor: FlutterFlowTheme.of(context).primary,
                    inactiveTrackColor: FlutterFlowTheme.of(context).alternate,
                    inactiveThumbColor:
                    FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        FFLocalizations.of(context).getText(
                          '11if3nk1' /* ACCOUNT */,
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
                          color: FlutterFlowTheme.of(context).secondary,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFF3C3F43),
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
                                      color: Color(0xFF2A2E33),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Align(
                                      alignment: AlignmentDirectional(0, 0),
                                      child: Icon(
                                        Icons.logout_rounded,
                                        color: Color(0xFFFF5963),
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    FFLocalizations.of(context).getText(
                                      'o8z58kus' /* Log Out */,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                      fontFamily:
                                      FlutterFlowTheme.of(context)
                                          .bodyMediumFamily,
                                      color: Color(0xFFFF5963),
                                      letterSpacing: 0.0,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                          FlutterFlowTheme.of(context)
                                              .bodyMediumFamily),
                                    ),
                                  ),
                                ].divide(SizedBox(width: 12)),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: Color(0xFF8D8D8D),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ].divide(SizedBox(height: 12)),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        FFLocalizations.of(context).getText(
                          'xhlmnyuv' /* CREDITS */,
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
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              FFLocalizations.of(context).getText(
                                '44vyrai6' /* Design & Development */,
                              ),
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
                            Padding(
                              padding:
                              EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                              child: Text(
                                FFLocalizations.of(context).getText(
                                  '9swjw4fn' /* Prabit Team */,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .labelMediumFamily,
                                  color: Color(0xFF8D8D8D),
                                  letterSpacing: 0.0,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(
                                      FlutterFlowTheme.of(context)
                                          .labelMediumFamily),
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

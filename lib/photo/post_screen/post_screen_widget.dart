import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'post_screen_model.dart';
export 'post_screen_model.dart';

/// Header Bar At the top of the screen, a compact header displays: A close
/// (“X”) icon on the left to cancel the check-in and return to the previous
/// screen.
///
/// The habit name (e.g., “Journaling”) in bold white text, centered alongside
/// a small colored habit icon. This bar is minimal but functional, keeping
/// the user focused on the check-in action. Preview Image Area The central
/// portion of the screen is dedicated to a photo preview: The image is
/// displayed inside a large square frame .. A small “Retake” button is
/// available in the bottom-right corner of the preview, allowing the user to
/// retake their photo if needed. The button is styled in a dark pill shape
/// with a white refresh icon and label. Caption Input Beneath the photo
/// preview is a caption input field: The input area is dark with rounded
/// corners and a placeholder that reads “Add a caption to your check-in…” It
/// supports text input, giving users the option to briefly describe their
/// mood, activity, or thoughts during the check-in. Submission Button At the
/// very bottom is a prominent “Post Check-In” button: Styled as a full-width,
/// rounded rectangle with a bright blue background and white text. This
/// button provides a clear call-to-action, completing the check-in process.
/// Summary The Post Check-In screen is fast, expressive, and clean. It
/// invites users to document their habit progress visually while offering
/// minimal friction. With the combination of a fun image interface, optional
/// emoji, caption field, and a large call-to-action button, this screen
/// perfectly captures Prabit’s aim to make habit tracking feel personal,
/// social, and enjoyable. The dark theme enhances contrast and focus, while
/// the rounded shapes and colorful accents give the screen a playful,
/// friendly feel.
class PostScreenWidget extends StatefulWidget {
  const PostScreenWidget({super.key});

  static String routeName = 'post_Screen';
  static String routePath = '/postScreen';

  @override
  State<PostScreenWidget> createState() => _PostScreenWidgetState();
}

class _PostScreenWidgetState extends State<PostScreenWidget> {
  late PostScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PostScreenModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

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
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 30.0, 16.0, 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 24.0,
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.edit_note_rounded,
                            color: Color(0xFF39D2C0),
                            size: 20.0,
                          ),
                          Text(
                            FFLocalizations.of(context).getText(
                              'qehx0rpp' /* Journaling */,
                            ),
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  fontFamily: FlutterFlowTheme.of(context)
                                      .titleMediumFamily,
                                  color: Colors.white,
                                  letterSpacing: 0.0,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .titleMediumFamily),
                                ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_back,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 24.0,
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 380.0,
                  decoration: BoxDecoration(
                    color: Color(0xFF1E2429),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw3fHxjb2ZmZWV8ZW58MHx8fHwxNzQ0MTEzOTU1fDA&ixlib=rb-4.0.3&q=80&w=1080',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(1.0, 1.0),
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: FFButtonWidget(
                              onPressed: () {
                                print('Button pressed ...');
                              },
                              text: FFLocalizations.of(context).getText(
                                'fh2g1xe2' /* Retake */,
                              ),
                              icon: Icon(
                                Icons.refresh,
                                color: Colors.white,
                                size: 18.0,
                              ),
                              options: FFButtonOptions(
                                height: 36.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    12.0, 0.0, 12.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 8.0, 0.0),
                                color: Color(0x80000000),
                                textStyle: FlutterFlowTheme.of(context)
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
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  controller: _model.textController,
                  focusNode: _model.textFieldFocusNode,
                  autofocus: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: FFLocalizations.of(context).getText(
                      'wa9zp2n7' /* Add a caption to your check-in... */,
                    ),
                    hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily:
                              FlutterFlowTheme.of(context).bodyMediumFamily,
                          color: Color(0xFF57636C),
                          letterSpacing: 0.0,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyMediumFamily),
                        ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF2D3436),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
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
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).bodyMediumFamily,
                        color: Colors.white,
                        letterSpacing: 0.0,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyMediumFamily),
                      ),
                  maxLines: 10,
                  minLines: 2,
                  cursorColor: Color(0xFF39D2C0),
                  validator:
                      _model.textControllerValidator.asValidator(context),
                ),
                Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        FFLocalizations.of(context).getText(
                          'g8d8klvf' /* Private Post */,
                        ),
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              fontFamily:
                                  FlutterFlowTheme.of(context).titleLargeFamily,
                              letterSpacing: 0.0,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context)
                                      .titleLargeFamily),
                            ),
                      ),
                      Switch.adaptive(
                        value: _model.switchValue!,
                        onChanged: (newValue) async {
                          safeSetState(() => _model.switchValue = newValue!);
                        },
                        activeColor: FlutterFlowTheme.of(context).primary,
                        activeTrackColor:
                            FlutterFlowTheme.of(context).buttonBackground,
                        inactiveTrackColor:
                            FlutterFlowTheme.of(context).alternate,
                        inactiveThumbColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                    ],
                  ),
                ),
                FFButtonWidget(
                  onPressed: () {
                    print('Button pressed ...');
                  },
                  text: FFLocalizations.of(context).getText(
                    'vo27c668' /* Post Check-In */,
                  ),
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50.0,
                    padding: EdgeInsets.all(8.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).buttonBackground,
                    textStyle: FlutterFlowTheme.of(context)
                        .titleMedium
                        .override(
                          fontFamily:
                              FlutterFlowTheme.of(context).titleMediumFamily,
                          color: Colors.white,
                          letterSpacing: 0.0,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).titleMediumFamily),
                        ),
                    elevation: 0.0,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ].divide(SizedBox(height: 16.0)),
            ),
          ),
        ),
      ),
    );
  }
}

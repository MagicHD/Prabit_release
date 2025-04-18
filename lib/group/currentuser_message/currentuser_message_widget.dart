import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for Timestamp

import 'currentuser_message_model.dart';
export 'currentuser_message_model.dart';

class CurrentuserMessageWidget extends StatefulWidget {
  // --- ADDED PARAMETERS ---
  final String? messageText;
  final Timestamp? timestamp;

  const CurrentuserMessageWidget({
    super.key,
    this.messageText,
    this.timestamp,
  });
  // --- END ADDED PARAMETERS ---

  @override
  State<CurrentuserMessageWidget> createState() =>
      _CurrentuserMessageWidgetState();
}

class _CurrentuserMessageWidgetState extends State<CurrentuserMessageWidget> {
  late CurrentuserMessageModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CurrentuserMessageModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  // Helper to format timestamp
  String _formatTimestamp(Timestamp? ts) {
    if (ts == null) return '';
    // Format to HH:mm (e.g., 20:17)
    return DateFormat('HH:mm').format(ts.toDate());
  }

  // Helper for defensive text style (copy from GroupCreation2Widget or define here)
  TextStyle _getTextStyle( BuildContext context, TextStyle baseStyle, String? fontFamilyName,
      {Color? colorOverride, double? fontSizeOverride, FontWeight? fontWeightOverride, double? letterSpacingOverride}) {
    TextStyle style = baseStyle;
    if (colorOverride != null) style = style.copyWith(color: colorOverride);
    if (fontSizeOverride != null) style = style.copyWith(fontSize: fontSizeOverride);
    if (fontWeightOverride != null) style = style.copyWith(fontWeight: fontWeightOverride);
    if (letterSpacingOverride != null) style = style.copyWith(letterSpacing: letterSpacingOverride);

    if (fontFamilyName != null && GoogleFonts.asMap().containsKey(fontFamilyName)) {
      return GoogleFonts.getFont(fontFamilyName, textStyle: style);
    } else {
      return style.copyWith(fontFamily: fontFamilyName);
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    // Apply defensive styling
    final messageTextStyle = _getTextStyle(context, theme.bodyMedium, 'Manrope', colorOverride: Colors.white, fontSizeOverride: 14.0, fontWeightOverride: FontWeight.w500);
    final timeTextStyle = _getTextStyle(context, theme.labelSmall, 'Manrope', colorOverride: Color(0xFF9E9E9E), fontSizeOverride: 12.0, fontWeightOverride: FontWeight.w500);

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 4.0), // Reduced top padding
      child: Column(
        mainAxisSize: MainAxisSize.min, // Use min to wrap content
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75), // Max width for bubble
            decoration: BoxDecoration(
              color: theme.buttonBackground, // Use theme color
              borderRadius: BorderRadius.only( // Standard bubble shape
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
                bottomLeft: Radius.circular(16.0),
                bottomRight: Radius.circular(4.0), // Less rounded corner
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // Adjusted padding
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start, // Text starts left within bubble
                children: [
                  // --- MODIFIED: Display passed message text ---
                  Text(
                    widget.messageText ?? '', // Display message text or empty string
                    style: messageTextStyle,
                  ),
                  // --- END MODIFIED ---
                  if (widget.timestamp != null) ...[ // Conditionally display timestamp
                    SizedBox(height: 4.0),
                    Align(
                      alignment: AlignmentDirectional.centerEnd, // Align time to the right
                      // --- MODIFIED: Display formatted timestamp ---
                      child: Text(
                        _formatTimestamp(widget.timestamp), // Display formatted time
                        style: timeTextStyle,
                      ),
                      // --- END MODIFIED ---
                    ),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
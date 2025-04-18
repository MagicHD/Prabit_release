import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for Timestamp
import 'package:cached_network_image/cached_network_image.dart'; // Optional for avatar

import 'friend_message_model.dart';
export 'friend_message_model.dart';

class FriendMessageWidget extends StatefulWidget {
  // --- ADDED PARAMETERS ---
  final String? messageText;
  final Timestamp? timestamp;
  final String? senderName;
  final String? senderImageUrl; // Optional sender image

  const FriendMessageWidget({
    super.key,
    this.messageText,
    this.timestamp,
    this.senderName,
    this.senderImageUrl,
  });
  // --- END ADDED PARAMETERS ---

  @override
  State<FriendMessageWidget> createState() => _FriendMessageWidgetState();
}

class _FriendMessageWidgetState extends State<FriendMessageWidget> {
  late FriendMessageModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FriendMessageModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  // Helper to format timestamp
  String _formatTimestamp(Timestamp? ts) {
    if (ts == null) return '';
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
    final bool hasSenderImage = widget.senderImageUrl != null && widget.senderImageUrl!.isNotEmpty;

    // Apply defensive styling
    final senderNameStyle = _getTextStyle(context, theme.bodyMedium, 'Manrope', colorOverride: Colors.white, fontSizeOverride: 14.0, fontWeightOverride: FontWeight.w600);
    final messageTextStyle = _getTextStyle(context, theme.bodyMedium, 'Manrope', colorOverride: Colors.white, fontSizeOverride: 14.0, fontWeightOverride: FontWeight.w500);
    final timeTextStyle = _getTextStyle(context, theme.labelSmall, 'Manrope', colorOverride: Color(0xFF9E9E9E), fontSizeOverride: 12.0, fontWeightOverride: FontWeight.w500);
    final initialTextStyle = _getTextStyle(context, theme.bodyMedium, 'Manrope', colorOverride: Colors.white, fontSizeOverride: 14.0, fontWeightOverride: FontWeight.w600);

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 4.0), // Reduced top padding
      child: Row( // Use Row for avatar + message bubble
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start, // Align avatar top left
        children: [
          // --- Sender Avatar ---
          Container(
            width: 36.0,
            height: 36.0,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Color(0xFF2A2A2A), // Fallback color
              shape: BoxShape.circle,
              image: hasSenderImage
                  ? DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.senderImageUrl!), // Use sender image URL
              )
                  : null,
            ),
            child: !hasSenderImage
                ? Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Text( // Display sender initial if no image
                widget.senderName?.isNotEmpty == true ? widget.senderName!.substring(0, 1).toUpperCase() : '?',
                style: initialTextStyle,
              ),
            )
                : null,
          ),
          // --- End Sender Avatar ---
          SizedBox(width: 8.0), // Spacing between avatar and bubble
          // --- Message Bubble ---
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7), // Max width
                decoration: BoxDecoration(
                  color: theme.secondary, // Different color for friend
                  borderRadius: BorderRadius.only( // Standard bubble shape
                    topLeft: Radius.circular(4.0), // Less rounded corner
                    topRight: Radius.circular(16.0),
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                  border: Border.all( color: theme.primaryBordercolor,),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0), // Adjusted padding
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- MODIFIED: Display Sender Name ---
                      if (widget.senderName != null) // Only show if name provided
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            widget.senderName!,
                            style: senderNameStyle,
                          ),
                        ),
                      // --- END MODIFIED ---

                      // --- MODIFIED: Display Message Text ---
                      Text(
                        widget.messageText ?? '',
                        style: messageTextStyle,
                      ),
                      // --- END MODIFIED ---

                      // --- MODIFIED: Display Timestamp ---
                      if (widget.timestamp != null) ...[
                        SizedBox(height: 4.0),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Text(
                            _formatTimestamp(widget.timestamp),
                            style: timeTextStyle,
                          ),
                        ),
                      ]
                      // --- END MODIFIED ---
                    ],
                  ),
                ),
              ),
            ],
          ),
          // --- End Message Bubble ---
        ],
      ),
    );
  }
}
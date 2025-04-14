import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'friendlistitem_model.dart';
export 'friendlistitem_model.dart';

class FriendlistitemWidget extends StatefulWidget {
  // --- Added Parameters ---
  final String friendUid;
  final String username;
  final String? profilePictureUrl; // Make nullable
  final Function(String) onRemoveFriend; // Callback function
  // --- End Added Parameters ---

  const FriendlistitemWidget({
    super.key,
    // --- Required Parameters ---
    required this.friendUid,
    required this.username,
    this.profilePictureUrl,
    required this.onRemoveFriend,
    // --- End Required Parameters ---
  });

  @override
  State<FriendlistitemWidget> createState() => _FriendlistitemWidgetState();
}

class _FriendlistitemWidgetState extends State<FriendlistitemWidget> {
  late FriendlistitemModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FriendlistitemModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine if the profile picture URL is valid
    bool hasProfilePicture = widget.profilePictureUrl != null && widget.profilePictureUrl!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondary, // Use secondary theme color
        borderRadius: BorderRadius.circular(9.5),
        border: Border.all(
          color: FlutterFlowTheme.of(context).primaryBordercolor, // Use border color from theme
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- Profile Picture ---
            ClipRRect( // Use ClipRRect for rounded corners on the image itself
              borderRadius: BorderRadius.circular(8.0),
              child: Container( // Wrap Image with Container for background color and icon
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: Color(0xFF2E353E), // Placeholder background
                  borderRadius: BorderRadius.circular(8.0), // Match ClipRRect
                ),
                child: hasProfilePicture
                    ? Image.network(
                  widget.profilePictureUrl!, // Use the passed URL
                  width: 40.0,
                  height: 40.0,
                  fit: BoxFit.cover,
                  // Add error builder for network image
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person, // Fallback icon
                      color: FlutterFlowTheme.of(context).info,
                      size: 24.0,
                    );
                  },
                )
                    : Icon( // Show icon if no picture
                  Icons.person,
                  color: FlutterFlowTheme.of(context).info,
                  size: 24.0,
                ),
              ),
            ),
            // --- End Profile Picture ---
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Username ---
                    Text(
                      // FFLocalizations.of(context).getText('jau915vf' /* Alex Fitness */,), // Remove placeholder
                      widget.username, // Use the passed username
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily:
                        FlutterFlowTheme.of(context).bodyMediumFamily,
                        color: FlutterFlowTheme.of(context).info, // Use info color from theme
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyMediumFamily),
                      ),
                    ),
                    // --- Optional: User Handle/Subtitle ---
                    // Text(
                    //   FFLocalizations.of(context).getText('sg5gny08' /* @alexfit */,),
                    //   style: FlutterFlowTheme.of(context).labelSmall.override(
                    //         fontFamily:
                    //             FlutterFlowTheme.of(context).labelSmallFamily,
                    //         color: Colors.white,
                    //         letterSpacing: 0.0,
                    //         useGoogleFonts: GoogleFonts.asMap().containsKey(
                    //             FlutterFlowTheme.of(context).labelSmallFamily),
                    //       ),
                    // ),
                    // --- End Optional Subtitle ---
                  ],
                ),
              ),
            ),
            // --- Burger Menu (PopupMenuButton) ---
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: FlutterFlowTheme.of(context).info, // Use info color
                size: 24.0,
              ),
              tooltip: 'Options', // Add tooltip
              onSelected: (String result) {
                switch (result) {
                  case 'remove':
                  // Call the callback function passed from the parent
                    widget.onRemoveFriend(widget.friendUid);
                    break;
                // Add other cases for more options if needed
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'remove',
                  child: ListTile( // Use ListTile for better layout
                    leading: Icon(Icons.person_remove_alt_1_rounded, color: FlutterFlowTheme.of(context).error),
                    title: Text('Remove Friend', style: TextStyle(color: FlutterFlowTheme.of(context).error)),
                  ),
                ),
                // Add more PopupMenuItems here for other options
              ],
              color: FlutterFlowTheme.of(context).secondaryBackground, // Menu background color
              shape: RoundedRectangleBorder( // Rounded corners for the menu
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            // --- End Burger Menu ---
          ],
        ),
      ),
    );
  }
}
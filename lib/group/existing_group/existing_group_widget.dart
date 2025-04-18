import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Optional: Import for caching

import 'existing_group_model.dart';
export 'existing_group_model.dart';

class ExistingGroupWidget extends StatefulWidget {
  const ExistingGroupWidget({
    super.key,
    String? groupname,
    this.membercount,
    this.icon, // Keep icon temporarily as fallback? Or remove if image is primary.
    this.groupImageUrl, // <-- Add this parameter
  }) : this.groupname = groupname ?? 'TestGroup';

  final String groupname;
  final String? membercount;
  final Widget? icon; // Can be removed if not used as fallback
  final String? groupImageUrl; // <-- Add this parameter

  @override
  State<ExistingGroupWidget> createState() => _ExistingGroupWidgetState();
}

class _ExistingGroupWidgetState extends State<ExistingGroupWidget> {
  late ExistingGroupModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ExistingGroupModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context); // Get theme instance

    // Determine if we have a valid image URL
    final bool hasImage = widget.groupImageUrl != null && widget.groupImageUrl!.isNotEmpty;

    return Container(
      width: double.infinity,
      height: 80.0,
      decoration: BoxDecoration(
        color: theme.secondary,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all( color: theme.primaryBordercolor,),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0), // Reduced padding slightly
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                // --- Modified Image/Icon Container ---
                Container(
                  width: 48.0,
                  height: 48.0,
                  clipBehavior: Clip.antiAlias, // Clip the image to the circle
                  decoration: BoxDecoration(
                    color: theme.buttonBackground, // Fallback background color
                    shape: BoxShape.circle,
                    // Conditionally set the image
                    image: hasImage
                        ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage( // Use NetworkImage
                        widget.groupImageUrl!,
                      ),
                      // Optional: Add error builder for NetworkImage if needed
                      // onError: (exception, stackTrace) => print('Error loading image: $exception'),
                    )
                        : null, // No image if URL is invalid
                  ),
                  // Show Icon ONLY if there's no image
                  child: !hasImage
                      ? Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    // Use the passed icon or a default one
                    child: widget.icon ?? Icon(Icons.group, color: theme.info, size: 24),
                  )
                      : null, // Show nothing if image is present
                ),
                // --- End of Modified Image/Icon Container ---

                SizedBox(width: 12.0), // Reduced spacing slightly
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center, // Center text vertically
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.groupname, // Use widget.groupname
                      style: theme.bodyLarge.override( // Use theme text style
                        fontFamily: theme.bodyLargeFamily,
                        color: Colors.white, // Or theme.info
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(theme.bodyLargeFamily),
                      ),
                    ),
                    SizedBox(height: 4.0), // Spacing
                    Row( // Keep the details row
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Public/Private Icon + Text (You might want to pass groupType here too)
                        Row( mainAxisSize: MainAxisSize.max, children: [ Icon( Icons.public_rounded, color: Color(0xFF9CA3AF), size: 14.0,), SizedBox(width: 4.0), Text( 'Public', /* Or pass type */ style: theme.labelSmall.override( fontFamily: 'Inter', color: Color(0xFF9CA3AF), fontSize: 12.0, letterSpacing: 0.0, fontWeight: FontWeight.w500, useGoogleFonts: GoogleFonts.asMap().containsKey('Inter'),),),],),
                        SizedBox(width: 12.0), // Spacing
                        // Member Count
                        Row( mainAxisSize: MainAxisSize.max, children: [ Icon( Icons.people_rounded, color: Color(0xFF9CA3AF), size: 14.0,), SizedBox(width: 4.0), Text( valueOrDefault<String>(widget.membercount, '0',), style: theme.labelSmall.override( fontFamily: 'Inter', color: Color(0xFF9CA3AF), fontSize: 12.0, letterSpacing: 0.0, fontWeight: FontWeight.w500, useGoogleFonts: GoogleFonts.asMap().containsKey('Inter'),), ),],),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Icon( // Keep chevron
              Icons.chevron_right_rounded,
              color: Color(0xFF9CA3AF),
              size: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
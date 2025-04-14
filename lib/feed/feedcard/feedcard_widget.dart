import 'package:cloud_firestore/cloud_firestore.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'feedcard_model.dart';
export 'feedcard_model.dart';

// --- Helper Widget for User Reactions Grid (Adapted from home_friendsTab.txt) ---
class UserReactionsGrid extends StatelessWidget {
  final Map<String, dynamic> userReactions;

  const UserReactionsGrid({Key? key, required this.userReactions}) : super(key: key);

  String _getReactionEmoji(String? reaction) {
    switch (reaction) {
      case 'laugh': return '😂';
      case 'celebrate': return '🎉';
      case 'heart': return '❤️';
      case 'shocked': return '😲';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (userReactions.isEmpty) {
      return const SizedBox.shrink(); // No reactions to display
    }

    // Limit to maybe 5-6 avatars for space
    final displayedReactions = userReactions.entries.take(6).toList();

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
      child: SizedBox(
        height: 40, // Adjusted height for smaller avatars
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: displayedReactions.length,
          itemBuilder: (context, index) {
            final entry = displayedReactions[index];
            final reactionData = entry.value as Map<String, dynamic>;
            final String? profilePicture = reactionData['profilePicture'] as String?;
            final String emoji = _getReactionEmoji(reactionData['reaction'] as String?);

            return Padding(
              padding: const EdgeInsets.only(right: 8.0), // Spacing between avatars
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 18, // Smaller radius
                    backgroundImage: profilePicture != null && profilePicture.isNotEmpty
                        ? NetworkImage(profilePicture)
                        : null,
                    backgroundColor: FlutterFlowTheme.of(context).secondary, // Background if no image
                    child: profilePicture == null || profilePicture.isEmpty
                        ? const Icon(Icons.person, size: 18, color: Colors.white,)
                        : null,
                  ),
                  if (emoji.isNotEmpty)
                    Positioned(
                      bottom: -2,
                      right: -5,
                      child: CircleAvatar(
                        radius: 9, // Smaller emoji circle
                        backgroundColor: Colors.white,
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 10), // Smaller emoji
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
// --- End Helper Widget ---


class FeedcardWidget extends StatefulWidget {
  const FeedcardWidget({
    super.key,
    this.withcontainer,
    required this.postId,
    required this.ownerId,
    required this.username,
    this.profilePictureUrl,
    this.imageUrl,
    this.caption,
    this.createdAt,
    this.reactions,
    this.userReactions,
    this.comments,
    required this.onReactButtonPressed, // Callback for react button press
    required this.onCommentIconPressed, // Callback for comment icon press
    required this.onProfileTap, // Callback for profile tap
    required this.onMoreOptionsTap, // Callback for more options tap
  });

  final double? withcontainer;
  final String postId;
  final String ownerId;
  final String username;
  final String? profilePictureUrl;
  final String? imageUrl;
  final String? caption;
  final Timestamp? createdAt;
  final Map<String, dynamic>? reactions;
  final Map<String, dynamic>? userReactions;
  final List<dynamic>? comments;
  final Function(BuildContext context, String postId, String ownerId, GlobalKey buttonKey) onReactButtonPressed;
  final VoidCallback onCommentIconPressed;
  final VoidCallback onProfileTap;
  final VoidCallback onMoreOptionsTap;


  @override
  State<FeedcardWidget> createState() => _FeedcardWidgetState();
}

class _FeedcardWidgetState extends State<FeedcardWidget> {
  late FeedcardModel _model;
  final GlobalKey _reactButtonKey = GlobalKey(); // Key for the react button

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FeedcardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown date';
    // Using intl package for relative time (e.g., "10h ago", "Yesterday")
    // return timeago.format(timestamp.toDate());
    // Or keep your original format:
    final dt = timestamp.toDate();
    return '${dt.day}.${dt.month}.${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 1.0,
      // Make height dynamic based on content instead of fixed fraction
      // height: MediaQuery.sizeOf(context).height * 0.784,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary, // Or secondary for card look
        borderRadius: BorderRadius.circular(12.0), // Add rounding if desired
        shape: BoxShape.rectangle,
        border: Border.all(
            color: FlutterFlowTheme.of(context).primaryBordercolor, // Use border color
            width: 1.0
        ),
      ),
      margin: EdgeInsets.only(bottom: 16.0), // Add margin between cards
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 1.0), // Adjust padding
        child: Column(
          mainAxisSize: MainAxisSize.min, // Allow column to size to content
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 14.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // --- Dynamic Profile Picture ---
                      GestureDetector(
                        onTap: widget.onProfileTap, // Use callback
                        child: CircleAvatar(
                          radius: 20.0,
                          backgroundImage: widget.profilePictureUrl != null && widget.profilePictureUrl!.isNotEmpty
                              ? NetworkImage(widget.profilePictureUrl!)
                              : null,
                          backgroundColor: FlutterFlowTheme.of(context).secondary,
                          child: widget.profilePictureUrl == null || widget.profilePictureUrl!.isEmpty
                              ? Icon(Icons.person, color: Colors.white, size: 20,)
                              : null,
                        ),
                      ),
                      // --- Dynamic Username ---
                      Padding( // Add padding around username column
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Adjust size
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.username, // Use parameter
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium // Adjusted size slightly
                                  .override(
                                fontFamily: 'Inter Tight',
                                color: Colors.white,
                                // fontSize: 23.0, // Consider slightly smaller size
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.0,
                              ),
                            ),
                            // Optionally add timestamp here if design changes
                            // Text(
                            //   formatTimestamp(widget.createdAt),
                            //   style: FlutterFlowTheme.of(context).labelSmall.override(
                            //         fontFamily: 'Inter',
                            //         color: FlutterFlowTheme.of(context).secondaryText,
                            //       ),
                            // ),
                          ],
                        ),
                      ),
                      // Remove static activity icon container if not needed
                      // Container( ... ),
                    ],
                    // removed .divide(SizedBox(width: 12.0)) - handled by Padding
                  ),
                  // --- More Options Icon ---
                  IconButton( // Make it an IconButton for easier tap handling
                    icon: FaIcon(
                      FontAwesomeIcons.ellipsisH,
                      color: Colors.white,
                      size: 20.0, // Slightly smaller
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    tooltip: 'More options',
                    onPressed: widget.onMoreOptionsTap, // Use callback
                  ),
                ],
              ),
            ),
            // --- Dynamic Image ---
            if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
              ClipRRect( // Clip image if using rounded corners on container
                borderRadius: BorderRadius.vertical(top: Radius.circular(0.0), bottom: Radius.circular(0.0)), // Adjust if container is rounded
                child: Image.network(
                  widget.imageUrl!, // Use parameter
                  width: double.infinity,
                  // Adjust height dynamically or set a max height?
                  // height: MediaQuery.sizeOf(context).height * 0.496,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container( // Placeholder while loading
                      height: 300, // Example height
                      color: FlutterFlowTheme.of(context).secondary,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                      height: 300, // Example height
                      color: FlutterFlowTheme.of(context).secondary,
                      child: Center(child: Icon(Icons.image_not_supported, color: Colors.white, size: 40,))
                  ),
                ),
              ),

            // --- Dynamic User Reactions ---
            if (widget.userReactions != null && widget.userReactions!.isNotEmpty)
              UserReactionsGrid(userReactions: widget.userReactions!),


            // --- Dynamic Caption ---
            if (widget.caption != null && widget.caption!.isNotEmpty)
              Padding(
                padding: EdgeInsets.fromLTRB(16.0, (widget.userReactions?.isEmpty ?? true) ? 16.0 : 8.0 , 16.0, 8.0), // Adjust top padding based on reactions
                child: Text(
                  widget.caption!, // Use parameter''
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),

            // --- Interaction Row ---
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0), // Adjust padding
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [ // Removed mainAxisAlignment: MainAxisAlignment.start
                    // --- Dynamic React Button ---
                    Builder( // Use Builder to get context for the key
                        builder: (buttonContext) {
                          return FFButtonWidget(
                            key: _reactButtonKey, // Assign key
                            onPressed: () {
                              // Use the callback passed from FeedscreenWidget
                              widget.onReactButtonPressed(buttonContext, widget.postId, widget.ownerId, _reactButtonKey);
                            },
                            text: 'React', // Simpler text, or use emoji if preferred
                            // icon: Icon(Icons.emoji_emotions_outlined, size: 18), // Optional icon
                            options: FFButtonOptions(
                              height: 32.0,
                              padding:
                              EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0), // Adjust padding
                              iconPadding:
                              EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 4.0, 0.0), // Padding if icon used
                              color: FlutterFlowTheme.of(context).secondary, // Use secondary for button bg
                              textStyle:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Inter',
                                color: FlutterFlowTheme.of(context).primaryText, // White text
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500, // Slightly bolder
                              ),
                              elevation: 0.0,
                              borderSide: BorderSide( // Add subtle border
                                color: FlutterFlowTheme.of(context).primaryBordercolor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          );
                        }
                    ),
                    // --- Dynamic Comment Icon/Count ---
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0), // Adjust padding
                      child: InkWell( // Make tappable
                        onTap: widget.onCommentIconPressed, // Use callback
                        borderRadius: BorderRadius.circular(16), // Match button radius
                        child: Padding( // Add padding for tap area
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                color: FlutterFlowTheme.of(context).secondaryText,
                                size: 18.0, // Slightly larger
                              ),
                              SizedBox(width: 4.0), // Space
                              Text(
                                '${widget.comments?.length ?? 0}', // Use dynamic count
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                  fontFamily: 'Inter',
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                  fontSize: 14.0, // Match button text size
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500, // Match button weight
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // --- Dynamic Timestamp ---
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional(1.0, 0.0),
                        child: Text(
                          formatTimestamp(widget.createdAt), // Use formatted timestamp
                          style: FlutterFlowTheme.of(context).labelSmall.override(
                            fontFamily: 'Inter',
                            color: FlutterFlowTheme.of(context).secondaryText, // Use secondary text color
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ]
                // Removed .addToStart/End - using Row's natural layout
              ),
            ),
            // --- Placeholder for Comments List & Input ---
            // This logic is complex for a simple component. It's often better handled
            // in the parent screen (FeedscreenWidget) which manages the state (_expandedComments, _commentController)
            // and passes down only the necessary display widgets or handles navigation to a detail screen.
            // If you need comments directly here, you'd add a stateful part to this widget
            // or pass down more state/callbacks.
            // Example placeholder:
            // if (widget.comments != null && widget.comments!.isNotEmpty)
            //    Padding(
            //      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            //      child: Text('Comments section would go here...', style: TextStyle(color: Colors.grey)),
            //    ),
          ],
        ),
      ),
    );
  }
}
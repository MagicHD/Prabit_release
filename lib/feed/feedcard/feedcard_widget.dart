import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'feedcard_model.dart'; // Assuming FeedcardModel exists or adapt as needed

export 'feedcard_model.dart';

// --- Helper Widget for User Reactions Grid ---
// (Keep this widget as it was in your original file)
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
// --- End UserReactionsGrid ---

// **** MODIFIED: Changed to StatefulWidget ****
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
    // **** ADDED habitIcon and habitName (Nullable) ****
    this.habitIcon,
    this.habitName,
    // **** END ADDED ****
    required this.onReactButtonPressed,
    required this.onCommentIconPressedWithData,
    required this.onProfileTap,
    required this.onMoreOptionsTap,
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
  // **** ADDED habitIcon and habitName fields (Nullable) ****
  final String? habitIcon; // Name of the icon (e.g., "sports_soccer")
  final String? habitName; // Name of the habit (e.g., "Football")
  // **** END ADDED ****
  final Function(BuildContext context, String postId, String ownerId, GlobalKey buttonKey) onReactButtonPressed;
  final Function(String postId, String ownerId, List<dynamic> comments) onCommentIconPressedWithData;
  final VoidCallback onProfileTap;
  final VoidCallback onMoreOptionsTap;

  @override
  State<FeedcardWidget> createState() => _FeedcardWidgetState();
}

// **** MODIFIED: State class for StatefulWidget ****
class _FeedcardWidgetState extends State<FeedcardWidget> {
  late FeedcardModel _model; // Keep if used by FlutterFlow helpers
  final GlobalKey _reactButtonKey = GlobalKey(); // Key for the react button

  // **** ADDED: State for habit expansion ****
  bool _isHabitExpanded = false;
  // **** END ADDED ****

  @override
  void initState() {
    super.initState();
    // Assuming createModel is a FlutterFlow utility or similar
    _model = createModel(context, () => FeedcardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose(); // Keep if used
    super.dispose();
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown date';
    final dt = timestamp.toDate();
    // Consider using the 'intl' package for more robust relative time formatting
    return '${dt.day}.${dt.month}.${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  // **** ADDED: Helper function to map icon name to IconData ****
  // --->> IMPORTANT: COMPLETE THIS MAPPING! <<---
  IconData _getHabitIcon(String? iconName) {
    switch (iconName?.toLowerCase()) {
    // --- Add your mappings here ---
      case 'sports_soccer': // From your screenshot
        return Icons.sports_soccer;
      case 'fitness_center': // Example
        return Icons.fitness_center;
      case 'book': case 'menu_book': // Example
      return Icons.book;
      case 'self_improvement': // Example
        return Icons.self_improvement;
      case 'monitor_heart': // Example
        return Icons.monitor_heart;
      case 'directions_run': // Example
        return Icons.directions_run;
      case 'code': // Example
        return Icons.code;
    // Add more cases for ALL your habit icons from Firestore here!
    // --- End your mappings ---
      default:
      // Fallback icon if habitIcon is null, empty, or not found in map
        return Icons.task_alt;
    }
  }
  // **** END ADDED ****


  @override
  Widget build(BuildContext context) {
    // Determine if habit info is available and valid to display
    final bool hasHabitInfo = widget.habitIcon != null && widget.habitName != null && widget.habitName!.isNotEmpty;

    return Container(
      width: MediaQuery.sizeOf(context).width * 1.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primary,
        shape: BoxShape.rectangle,
        border: Border.all(
            color: FlutterFlowTheme.of(context).primaryBordercolor,
            width: 1.0),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 14.0, 0.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Size column to content
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Top Row: Profile Pic, User/Habit Info, More Options ---
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 0.0, 16, 14.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center, // Vertically align items
                children: [
                  // --- Left Side: Profile Pic and User/Habit Info ---
                  Expanded( // Allow this row to take up available space
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Keep content compact
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile Picture
                        GestureDetector(
                          onTap: widget.onProfileTap,
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundImage: widget.profilePictureUrl != null &&
                                widget.profilePictureUrl!.isNotEmpty
                                ? NetworkImage(widget.profilePictureUrl!)
                                : null,
                            backgroundColor: FlutterFlowTheme.of(context).secondary,
                            child: widget.profilePictureUrl == null ||
                                widget.profilePictureUrl!.isEmpty
                                ? Icon(Icons.person, color: Colors.white, size: 20)
                                : null,
                          ),
                        ),
                        SizedBox(width: 12.0), // Spacing

                        // Username and Habit Info Column
                        Flexible( // Allow text/habit info to shrink/wrap if needed
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Username
                              Text(
                                widget.username,
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                  fontFamily: 'Inter Tight',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.0,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              SizedBox(width: 8.0), // Adjust spacing as needed

                              // **** ADDED: Habit Icon and Animated Name Row ****
                              // Only build this section if habit info is valid
                              if (hasHabitInfo)
                                SizedBox(height: 2), // Small space below username
                              if (hasHabitInfo)
                                GestureDetector(
                                  onTap: () {
                                    // Toggle the expansion state on tap
                                    setState(() {
                                      _isHabitExpanded = !_isHabitExpanded;
                                    });
                                  },
                                  child: Container(
                                    color: Colors.transparent, // Essential for tap detection on empty space
                                    padding: EdgeInsets.symmetric(vertical: 2), // Increase tap area slightly
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min, // Keep row compact
                                      children: [
                                        // Habit Icon
                                        Icon(
                                          _getHabitIcon(widget.habitIcon), // Use helper
                                          color: FlutterFlowTheme.of(context).buttonBackground,
                                          size: 16.0, // Icon size
                                        ),
                                        // **** ADDED: Animated Arrow Icon ****
                                        Padding(
                                          padding: const EdgeInsets.only(left: 2.0), // Small space after habit icon
                                          child: AnimatedRotation(
                                            turns: _isHabitExpanded ? 0.50 : 0, // 0 turns = right, 0.25 turns = down (90 deg)
                                            duration: const Duration(milliseconds: 300), // Match animation speed
                                            child: Icon(
                                              Icons.keyboard_arrow_right, // Arrow icon
                                              color: FlutterFlowTheme.of(context).buttonBackground,
                                              size: 18.0, // Adjust size slightly larger than habit icon?
                                            ),
                                          ),
                                        ),
                                        // **** END ADDED ****
                                        // AnimatedSwitcher for the Habit Name
                                        AnimatedSwitcher(
                                          duration: const Duration(milliseconds: 350), // Animation speed
                                          transitionBuilder: (Widget child, Animation<double> animation) {
                                            // Create a slide + fade transition
                                            final offsetAnimation = Tween<Offset>(
                                              begin: const Offset(0.3, 0.0), // Start sliding from right
                                              end: Offset.zero,
                                            ).animate(CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.easeInOut, // Smooth curve
                                            ));
                                            final fadeAnimation = Tween<double>(
                                              begin: 0.0, // Start faded out
                                              end: 1.0, // End fully opaque
                                            ).animate(CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.easeIn, // Fade in quickly
                                            ));
                                            // Apply both transitions
                                            return FadeTransition(
                                              opacity: fadeAnimation,
                                              child: SlideTransition(
                                                position: offsetAnimation,
                                                child: child,
                                              ),
                                            );
                                          },
                                          // LayoutBuilder helps prevent layout jumps during animation
                                          layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
                                            return Stack(
                                              alignment: Alignment.centerLeft,
                                              children: <Widget>[
                                                ...previousChildren, // Keep previous children for fade-out
                                                if (currentChild != null) currentChild, // Display current child
                                              ],
                                            );
                                          },
                                          // Conditionally display the habit name or an empty space
                                          child: _isHabitExpanded
                                          // --- Expanded State: Show Habit Name ---
                                              ? Padding(
                                            // Unique key tells AnimatedSwitcher which child is which
                                            key: ValueKey<String>('habitName_${widget.postId}'),
                                            padding: const EdgeInsets.only(left: 6.0), // Space icon and text
                                            child: Text(
                                              widget.habitName!, // Display the habit name
                                              style: FlutterFlowTheme.of(context)
                                                  .labelSmall // Use a smaller text style
                                                  .override(
                                                fontFamily: 'Inter',
                                                color: FlutterFlowTheme.of(context).secondaryText,
                                                fontSize: 12.0, // Adjust size as needed
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              overflow: TextOverflow.ellipsis, // Prevent long names overflowing
                                              maxLines: 1,
                                            ),
                                          )
                                          // --- Collapsed State: Show nothing (SizedBox.shrink is efficient) ---
                                              : SizedBox.shrink(key: ValueKey<String>('emptyHabit_${widget.postId}')),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              // **** END ADDED ****
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- Right Side: More Options Icon ---
                  IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.ellipsisH,
                      color: Colors.white,
                      size: 20.0,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(), // Remove default padding
                    tooltip: 'More options',
                    onPressed: widget.onMoreOptionsTap, // Trigger callback
                  ),
                ],
              ),
            ),

            // --- Dynamic Image Display ---
            if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
              Image.network( // Using Image.network directly for simplicity
                widget.imageUrl!,
                width: double.infinity, // Take full width
                fit: BoxFit.cover, // Cover the area
                // Add loading and error builders for better UX
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child; // Image loaded
                  return Container( // Placeholder while loading
                    height: 300, // Estimate a reasonable height
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    child: Center(child: CircularProgressIndicator(
                      color: FlutterFlowTheme.of(context).primary,
                    )),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container( // Placeholder on error
                    height: 300,
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    child: Center(
                        child: Icon(Icons.broken_image,
                            color: FlutterFlowTheme.of(context).secondaryText, size: 40))),
              ),

            // --- Dynamic User Reactions Grid ---
            // Only show if there are reactions
            if (widget.userReactions != null && widget.userReactions!.isNotEmpty)
              UserReactionsGrid(userReactions: widget.userReactions!),

            // --- Dynamic Caption ---
            // Only show if caption exists and is not empty
            if (widget.caption != null && widget.caption!.isNotEmpty)
              Padding(
                padding: EdgeInsets.fromLTRB(
                    16.0,
                    // Adjust top padding based on whether reactions are shown
                    (widget.userReactions?.isEmpty ?? true) ? 16.0 : 8.0,
                    16.0,
                    8.0),
                child: Text(
                  widget.caption!,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    color: Colors.white, // Use primary text color
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),

            // --- Interaction Row (React, Comment, Timestamp) ---
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0), // Consistent padding
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // --- React Button ---
                  Builder(builder: (buttonContext) {
                    // Use Builder to get context for key if needed by callback
                    return FFButtonWidget(
                      key: _reactButtonKey, // Assign key
                      onPressed: () {
                        // Call the provided callback function
                        widget.onReactButtonPressed(buttonContext, widget.postId, widget.ownerId, _reactButtonKey);
                      },
                      text: 'React',
                      options: FFButtonOptions(
                        height: 32.0, // Button height
                        padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                        iconPadding: EdgeInsetsDirectional.zero,
                        color: FlutterFlowTheme.of(context).secondary, // Button color
                        textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Inter',
                          color: FlutterFlowTheme.of(context).primaryText,
                          fontSize: 14.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                        elevation: 0.0, // No shadow
                        borderSide: BorderSide( // Subtle border
                          color: FlutterFlowTheme.of(context).primaryBordercolor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(16.0), // Rounded corners
                      ),
                    );
                  }),

                  // --- Comment Icon & Count ---
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0), // Space from react button
                    child: InkWell( // Make it tappable
                      onTap: () => widget.onCommentIconPressedWithData(
                          widget.postId, widget.ownerId, widget.comments ?? []), // Callback
                      borderRadius: BorderRadius.circular(16), // Match button shape for ripple effect
                      child: Padding( // Padding for visual spacing and tap area
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Row takes minimum space
                          children: [
                            Icon(
                              Icons.chat_bubble_outline, // Comment icon
                              color: FlutterFlowTheme.of(context).secondaryText,
                              size: 18.0,
                            ),
                            SizedBox(width: 4.0), // Space between icon and count
                            Text(
                              '${widget.comments?.length ?? 0}', // Display comment count
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

                  // --- Timestamp (Aligned Right) ---
                  Expanded( // Takes remaining space to push timestamp right
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd, // Align text to the end (right)
                      child: Text(
                        formatTimestamp(widget.createdAt), // Use formatted timestamp
                        style: FlutterFlowTheme.of(context).labelSmall.override(
                          fontFamily: 'Inter',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          fontSize: 12.0, // Smaller size for timestamp
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
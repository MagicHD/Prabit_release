import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';

import '../../flutter_flow/flutter_flow_icon_button.dart';
import '/feed/feedcard/feedcard_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'feedscreen_model.dart';
export 'feedscreen_model.dart';
import "commentsBottomSheet.dart";

/// The feed screen of the Prabit app features a modern, dark-themed design
/// with a clean structure and minimalist aesthetic.
///
/// The background is a deep black or dark gray, creating strong contrast and
/// allowing individual UI elements to stand out clearly. At the top of the
/// screen, there is a navigation bar displaying the title “Feed” in bold
/// white text. Just below the title, a smaller label with the same word
/// “Feed” appears inside a rounded blue pill-shaped background, serving as a
/// subtle visual highlight. In the top-right corner, there is a circular
/// profile icon, likely providing access to user settings or the personal
/// profile.
///
/// Beneath the title section is a toggle-style tab switcher that allows the
/// user to choose between two feed types: “Friends” and “Friends of Friends.”
/// The active tab, “Friends,” is visually emphasized with a solid blue
/// background and rounded corners, while the inactive tab has a dark
/// background with no highlight.
///
/// Each post in the feed is displayed inside a rounded rectangular card,
/// which stands out gently from the background. The top section of each card
/// includes the user’s circular profile picture, the username (“sarah”) in
/// bold white text, and a timestamp on the right side indicating how long ago
/// the post was made (e.g., “9d ago”). Next to the username is a small, dark
/// circular chip with an activity icon (in this case, a running symbol),
/// representing the nature of the post.
///
/// The main focus of the card is a large, full-width image that visually
/// represents the user’s activity. In this example, the image shows someone’s
/// legs while running on a street, directly reinforcing the post’s content.
/// Overlaid on the bottom part of the image is a semi-transparent reaction
/// panel showing a pill-shaped icon with two overlapping user avatars and a
/// small activity-related symbol (like a drop), indicating that the post has
/// received two reactions.
///
/// Below the image, the post text is displayed in clear white font, reading:
/// “Completed my morning run! 5km in 25 minutes, a new personal best!” The
/// typography is simple and easy to read, ensuring good accessibility.
///
/// At the very bottom of the post card, there’s a footer bar with interactive
/// elements: a “React” button, a comment count (in this case, 2), and a
/// timestamp showing the exact date of the post (“25.3.2025”) aligned to the
/// right in small gray text.
///
/// Overall, the design conveys a modern, well-organized impression with a
/// clear visual hierarchy. The use of blue accent colors against a dark
/// background, along with rounded UI elements and subtle visual effects,
/// evokes contemporary UI trends such as soft neumorphism or light
/// glassmorphism. The interface feels thoughtfully designed,
/// mobile-optimized, and user-friendly.

class FeedscreenWidget extends StatefulWidget {
  const FeedscreenWidget({super.key});

  static String routeName = 'Feedscreen';
  static String routePath = '/feedscreen';

  @override
  State<FeedscreenWidget> createState() => _FeedscreenWidgetState();
}

class _FeedscreenWidgetState extends State<FeedscreenWidget>
    with TickerProviderStateMixin {
  late FeedscreenModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // --- State Variables ---
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = true;
  String? _currentUserId;
  String? _currentUserUsername; // Store current user's username
  String? _currentUserProfilePic; // Store current user's profile pic

  bool _isShowingReactions = false;
  String? _reactingToPostId;
  String? _reactingToOwnerId;

  // State for interactions directly in this screen
  // Track comment visibility


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FeedscreenModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2, // Keep as 2 if you have 'Friends' and 'Friends of Friends'
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    _currentUserId = _auth.currentUser?.uid;
    _fetchCurrentUserInfoAndPosts(); // Fetch user info first, then posts
  }

  @override
  void dispose() {
    _model.dispose();
     // Dispose focus node
    super.dispose();
  }

  // --- Fetch Current User Info ---
  Future<void> _fetchCurrentUserInfoAndPosts() async {
    if (_currentUserId == null) {
      setState(() => _isLoading = false); // Not logged in
      return;
    }
    try {
      final userDoc = await _firestore.collection('users').doc(_currentUserId).get();
      if(userDoc.exists) {
        final data = userDoc.data();
        _currentUserUsername = data?['username'] ?? 'You';
        _currentUserProfilePic = data?['profilePicture'];
      } else {
        _currentUserUsername = 'You'; // Fallback
      }
    } catch (e) {
      print("Error fetching current user info: $e");
      _currentUserUsername = 'You'; // Fallback on error
    }
    // Now fetch posts after getting user info (or concurrently if preferred)
    _fetchFriendsPosts();
  }


  // --- Firebase Fetch Logic (Adapted from home_friendsTab.txt) ---
  Future<void> _fetchFriendsPosts() async {
    if (!mounted) return; // Ensure widget is still mounted
    setState(() => _isLoading = true);

    if (_currentUserId == null) {
      setState(() => _isLoading = false); // Not logged in
      return;
    }

    try {
      List<Map<String, dynamic>> allPosts = [];

      // --- Fetch user's own posts ---
      final userPostsSnapshot = await _firestore
          .collection('users')
          .doc(_currentUserId)
          .collection('shareWithFriendsPosts')
          .orderBy('createdAt', descending: true)
          .get();

      for (var post in userPostsSnapshot.docs) {
        final postData = post.data();
        allPosts.add({
          "id": post.id,
          'username': _currentUserUsername,
          "ownerId": _currentUserId,
          "profilePictureUrl": _currentUserProfilePic,
          "imageUrl": postData['url'],
          "caption": postData['caption'],
          "createdAt": postData['createdAt'],
          "reactions": postData['reactions'] as Map<String, dynamic>? ?? {},
          "userReactions": postData['userReactions'] as Map<String, dynamic>? ?? {},
          "comments": postData['comments'] as List<dynamic>? ?? [],
          // **** ADD THESE TWO LINES for user's own posts ****
          "habitIcon": postData['habitIcon'] as String?, // Fetches the icon name string
          "habitName": postData['habitName'] as String?, // Fetches the habit name string
          // **** END ADDED LINES ****
        });
      }

      // --- Fetch friends' posts ---
      final friendsSnapshot = await _firestore
          .collection('users')
          .doc(_currentUserId)
          .collection('addedFriends')
          .get();
      List<String> friendIds = friendsSnapshot.docs.map((doc) => doc.id).toList();

      for (var friendId in friendIds) {
        final friendDoc = await _firestore.collection('users').doc(friendId).get();
        if (friendDoc.exists) {
          final friendData = friendDoc.data();
          final username = friendData?['username'] ?? "Unknown";
          final profilePicture = friendData?['profilePicture'];

          final postsSnapshot = await _firestore
              .collection('users')
              .doc(friendId)
              .collection('shareWithFriendsPosts')
              .orderBy('createdAt', descending: true)
              .get();

          for (var post in postsSnapshot.docs) {
            final postData = post.data();
            allPosts.add({
              "id": post.id,
              'username': username,
              "ownerId": friendId,
              "profilePictureUrl": profilePicture,
              "imageUrl": postData['url'],
              "caption": postData['caption'],
              "createdAt": postData['createdAt'],
              "reactions": postData['reactions'] as Map<String, dynamic>? ?? {},
              "userReactions": postData['userReactions'] as Map<String, dynamic>? ?? {},
              "comments": postData['comments'] as List<dynamic>? ?? [],
              // **** ADD THESE TWO LINES for friends' posts ****
              "habitIcon": postData['habitIcon'] as String?, // Fetches the icon name string
              "habitName": postData['habitName'] as String?, // Fetches the habit name string
              // **** END ADDED LINES ****
            });
          }
        }
      }

      // Sort posts
      allPosts.sort((a, b) {
        final timeA = a['createdAt'] as Timestamp?;
        final timeB = b['createdAt'] as Timestamp?;
        return (timeB?.seconds ?? 0).compareTo(timeA?.seconds ?? 0);
      });

      if (mounted) {
        setState(() {
          _posts = allPosts;
          // Initialize comment expansion state (only expand if few comments)

        });
      }
    } catch (e) {
      print("ERROR: Failed to fetch posts - $e");
      // Optionally show an error message
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // --- Interaction Handlers (Adapted from home_friendsTab.txt) ---

  // Get Emoji Helper
  String _getReactionEmoji(String? reaction) {
    switch (reaction) {
      case 'laugh': return '😂';
      case 'celebrate': return '🎉';
      case 'heart': return '❤️';
      case 'shocked': return '😲';
      default: return '';
    }
  }

  // Handle React Post
  Future<void> _handleReactPost(String postId, String ownerId, String selectedReaction) async {
    if (_currentUserId == null) return;

    try {
      final postRef = _firestore
          .collection('users')
          .doc(ownerId) // Use owner's UID
          .collection('shareWithFriendsPosts')
          .doc(postId);

      final postSnapshot = await postRef.get();
      if (!postSnapshot.exists) {
        print("Error: Post not found.");
        return;
      }

      final postData = postSnapshot.data() ?? {};
      // Use ?? {} to provide default empty maps
      final Map<String, dynamic> reactions = Map<String, dynamic>.from(postData['reactions'] ?? {});
      final Map<String, dynamic> userReactions = Map<String, dynamic>.from(postData['userReactions'] ?? {});

      // Decrement old reaction count if user reacted before
      if (userReactions.containsKey(_currentUserId)) {
        String oldReaction = userReactions[_currentUserId]['reaction'];
        if (reactions.containsKey(oldReaction)) {
          reactions[oldReaction] = (reactions[oldReaction] is int && reactions[oldReaction] > 0)
              ? reactions[oldReaction] - 1
              : 0;
        }
      }

      // Increment new reaction count
      reactions[selectedReaction] = (reactions[selectedReaction] is int ? reactions[selectedReaction] : 0) + 1;

      // Update or add user's reaction details
      userReactions[_currentUserId!] = {
        'reaction': selectedReaction,
        'username': _currentUserUsername, // Use fetched username
        'profilePicture': _currentUserProfilePic, // Use fetched profile pic
      };

      // Update Firestore
      await postRef.update({
        "reactions": reactions,
        "userReactions": userReactions,
      });

      print("Reaction added: $selectedReaction by $_currentUserUsername");

      // --- Update UI Immediately ---
      if (mounted) {
        setState(() {
          // Find the post in the local list and update its reaction data
          final postIndex = _posts.indexWhere((p) => p['id'] == postId);
          if (postIndex != -1) {
            _posts[postIndex]['reactions'] = reactions;
            _posts[postIndex]['userReactions'] = userReactions;
          }
        });
      }
      // No need to call _fetchFriendsPosts() here, update local state directly

    } catch (e) {
      print("Error reacting to post: $e");
      // Optionally show error to user
    }
  }

  // Show Reaction Picker (Needs BuildContext from where it's called)
  void _showReactionPicker(BuildContext buttonContext, String postId, String ownerId, GlobalKey buttonKey) {
    final RenderBox? buttonRenderBox = buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (buttonRenderBox == null) return;

    final Offset buttonPosition = buttonRenderBox.localToGlobal(Offset.zero);
    final Size buttonSize = buttonRenderBox.size;

    showDialog(
      context: context, // Use the main context here
      barrierColor: Colors.black.withOpacity(0.1), // Make barrier less intrusive
      builder: (BuildContext dialogContext) { // Use a different context name
        return Stack(
          children: [
            Positioned(
              // Adjust positioning logic as needed
              left: buttonPosition.dx - 50, // Center roughly above button
              top: buttonPosition.dy - 60, // Position above the button
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white, // Or a dark color matching theme
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: ["😂", "🎉", "❤️", "😲"].map((emoji) {
                      String reactionType;
                      switch(emoji) {
                        case "😂": reactionType = 'laugh'; break;
                        case "🎉": reactionType = 'celebrate'; break;
                        case "❤️": reactionType = 'heart'; break;
                        case "😲": reactionType = 'shocked'; break;
                        default: reactionType = '';
                      }
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(dialogContext); // Close the dialog
                          _handleReactPost(postId, ownerId, reactionType);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(emoji, style: const TextStyle(fontSize: 26)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  Future<void> _handleAddCommentFromSheet(String postId, String ownerId, String commentText) async {
    if (commentText.isEmpty || _currentUserId == null || _currentUserUsername == null) return;

    final newComment = {
      "username": _currentUserUsername,
      "uid": _currentUserId,
      "commentText": commentText,
      "createdAt": Timestamp.now(),
    };

    try {
      final postRef = _firestore
          .collection('users')
          .doc(ownerId)
          .collection('shareWithFriendsPosts')
          .doc(postId);

      await postRef.update({
        "comments": FieldValue.arrayUnion([newComment])
      });

      print("Comment added successfully via BottomSheet!");

      if (mounted) {
        setState(() {
          final postIndex = _posts.indexWhere((p) => p['id'] == postId);
          if (postIndex != -1) {
            List<dynamic> currentComments = List<dynamic>.from(_posts[postIndex]['comments'] ?? []);
            currentComments.add(newComment); // Add locally for feed count update
            _posts[postIndex]['comments'] = currentComments;
          }
        });
        // Note: Sheet refresh relies on its own state management
      }

    } catch (e) {
      print("Error adding comment from sheet: $e");
      _showSnackbar("Failed to add comment.");
    }
  }


  // Handle Add Comment

  // Toggle Comment Visibility


  // Handle tapping on comment icon - sets focus and remembers post ID
  void _handleCommentIconPressed(String postId, String ownerId, List<dynamic> comments) {
    if (_currentUserId == null || _currentUserUsername == null) {
      _showSnackbar("Please login to view comments.");
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground, // Adjust color if needed
      builder: (context) {
        return CommentsBottomSheet(
          postId: postId,
          ownerId: ownerId,
          comments: comments,
          currentUserId: _currentUserId!,
          currentUserUsername: _currentUserUsername!,
          currentUserProfilePic: _currentUserProfilePic,
          onCommentAdded: (String postId, String ownerId, String commentText) {
            _handleAddCommentFromSheet(postId, ownerId, commentText);
          },
        );
      },
    );
  }


  // --- Handle Profile Tap ---
  void _handleProfileTap(String userId) {
    print("Profile tapped for user: $userId");
    // Implement navigation or popup show logic here
    // Example using a hypothetical ProfilePopup:
    // ProfilePopup.show(context, profileImageUrl, username, userId);
    // Or navigate:
    // context.push('/profileDetail', extra: {'userId': userId});
  }


  // Add this new method inside _FeedscreenWidgetState class in feedscreen_widget.dart

  // Inside _FeedscreenWidgetState class in feedscreen_widget.dart

  Widget _buildReactionOverlay() {
    // Define your reaction options
    final reactions = {
      'laugh': '😂',
      'celebrate': '🎉',
      'heart': '❤️',
      'shocked': '😲',
    };

    return Stack(
      children: [
        // --- Blurred Background & Dismiss ---
        GestureDetector(
          onTap: () {
            // Dismiss the overlay when tapping anywhere in the blurred area
            setState(() {
              _isShowingReactions = false;
              _reactingToPostId = null;
              _reactingToOwnerId = null;
            });
          },
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              // **** MODIFICATION: Increased opacity for darker background ****
              color: Colors.black.withOpacity(0.5), // Changed from 0.3 to 0.5
              // **** END MODIFICATION ****
            ),
          ),
        ),

        // --- Centered Reaction Options ---
        Center(
          child: Material( // Wrap in Material for visual consistency (optional)
            color: Colors.transparent, // Make Material background transparent
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              decoration: BoxDecoration(
                // Optional: Add a background to the options container if needed
                // color: FlutterFlowTheme.of(context).secondary.withOpacity(0.8),
                // borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column( // Display reactions vertically
                mainAxisSize: MainAxisSize.min, // Take minimum space needed
                children: reactions.entries.map((entry) {
                  final reactionType = entry.key;
                  final emoji = entry.value;
                  return GestureDetector(
                    onTap: () {
                      if (_reactingToPostId != null && _reactingToOwnerId != null) {
                        _handleReactPost(_reactingToPostId!, _reactingToOwnerId!, reactionType);
                      }
                      // Hide overlay after selecting a reaction
                      setState(() {
                        _isShowingReactions = false;
                        _reactingToPostId = null;
                        _reactingToOwnerId = null;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0), // Spacing between reactions
                      child: Text(
                        emoji,
                        style: TextStyle(fontSize: 48), // Make emojis larger
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- Handle More Options Tap ---
  void _handleMoreOptionsTap(String postId, String ownerId) {
    print("More options tapped for post: $postId by $ownerId");
    // Implement options menu (e.g., showModalBottomSheet or PopupMenuButton)
    // Options could include: Report, View Profile (if not owner), Delete (if owner)
    showModalBottomSheet(
      context: context,
      backgroundColor: FlutterFlowTheme.of(context).secondary,
      builder: (context) => Wrap(
        children: <Widget>[
          if (ownerId != _currentUserId) // Only show report if not own post
            ListTile(
              leading: Icon(Icons.flag_outlined, color: FlutterFlowTheme.of(context).error),
              title: Text('Report Post', style: TextStyle(color: FlutterFlowTheme.of(context).error)),
              onTap: () {
                Navigator.pop(context); // Close bottom sheet
                _reportPost(postId, ownerId); // Call report function
              },
            ),
          if (ownerId == _currentUserId) // Only show delete if own post
            ListTile(
              leading: Icon(Icons.delete_outline, color: FlutterFlowTheme.of(context).error),
              title: Text('Delete Post', style: TextStyle(color: FlutterFlowTheme.of(context).error)),
              onTap: () {
                Navigator.pop(context);
                _confirmDeletePost(postId); // Ask for confirmation
              },
            ),
          ListTile(
            leading: Icon(Icons.cancel_outlined, color: Colors.white),
            title: Text('Cancel', style: TextStyle(color: Colors.white)),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // --- Report Post Logic (Adapted) ---
  Future<void> _reportPost(String postId, String ownerId) async {
    if (_currentUserId == null) return; // Should not happen if logged in

    // Show reason dialog (implement _showReportDialog similar to home_friendsTab.txt)
    String? reason = await _showReportReasonDialog(); // Assumes this dialog exists
    if (reason == null || reason.isEmpty) return; // User cancelled

    try {
      final reportCollection = _firestore
          .collection('feedback') // Central feedback collection
          .doc('post_reports')     // Document for post reports
          .collection(reason.toLowerCase().replaceAll(' ', '_')); // Subcollection by reason

      await reportCollection.add({
        'postId': postId,
        'ownerId': ownerId,
        'reportedBy': _currentUserId,
        'reporterUsername': _currentUserUsername, // Add reporter username
        'reason': reason,
        'reportedAt': Timestamp.now(),
        'postContentPreview': _posts.firstWhere((p) => p['id'] == postId)['caption'] ?? 'No caption', // Add preview
      });

      _showSnackbar('Post reported. Thank you.'); // Use a Snackbar for feedback
      print("Report successfully added to Firestore.");

    } catch (e) {
      _showSnackbar('Error reporting post. Please try again.'); // Use Snackbar
      print("ERROR: Failed to report post - $e");
    }
  }

  // --- Delete Post Logic ---
  Future<void> _deletePost(String postId) async {
    if (_currentUserId == null) return;
    try {
      await _firestore
          .collection('users')
          .doc(_currentUserId)
          .collection('shareWithFriendsPosts')
          .doc(postId)
          .delete();

      // Remove from local state
      if (mounted) {
        setState(() {
          _posts.removeWhere((post) => post['id'] == postId);
        });
      }
      _showSnackbar('Post deleted successfully.');
      print("Post deleted: $postId");
    } catch (e) {
      _showSnackbar('Error deleting post.');
      print("Error deleting post $postId: $e");
    }
  }

  void _confirmDeletePost(String postId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Post?"),
          content: Text("Are you sure you want to permanently delete this post?"),
          backgroundColor: FlutterFlowTheme.of(context).secondary,
          titleTextStyle: FlutterFlowTheme.of(context).headlineSmall.override(fontFamily: 'Inter Tight', color: Colors.white),
          contentTextStyle: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Inter', color: Colors.white),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Delete", style: TextStyle(color: FlutterFlowTheme.of(context).error)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deletePost(postId); // Proceed with deletion
              },
            ),
          ],
        );
      },
    );
  }


  // --- Helper: Show Report Reason Dialog ---
  Future<String?> _showReportReasonDialog() async {
    // Implement this dialog similar to how it was in home_friendsTab.txt
    // Return the selected reason string or null if cancelled.
    // Example structure:
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Report Post"),
        content: Text("Why are you reporting this post?"), // Add options here
        actions: [ /* Cancel/Submit Buttons */ ],
      ),
    );
  }

  // --- Helper: Show Snackbar ---
  void _showSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: FlutterFlowTheme.of(context).secondary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }


  // --- Widget Build Method ---
  @override
  Widget build(BuildContext context) {
    // Main GestureDetector to handle unfocusing, but allows taps on the overlay
    return GestureDetector(
      onTap: () {
        // Only unfocus if the reaction overlay isn't showing
        if (!_isShowingReactions) {
          FocusScope.of(context).unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        }
        // If reactions are showing, tapping outside is handled by the overlay's GestureDetector
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primary,
        appBar:
        // Generated code for this AppBar Widget...
        AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            FFLocalizations.of(context).getText(
              'j2028ukr' /* Prabit */,
            ),
            style: FlutterFlowTheme.of(context).displaySmall.override(
              fontFamily: FlutterFlowTheme.of(context).displaySmallFamily,
              letterSpacing: 0.0,
              useGoogleFonts: GoogleFonts.asMap()
                  .containsKey(FlutterFlowTheme.of(context).displaySmallFamily),
            ),
          ),
          actions: [
            Align(
              alignment: AlignmentDirectional(0, 0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                child: FlutterFlowIconButton(
                  borderRadius: 40,
                  buttonSize: 40,
                  icon: Icon(
                    FontAwesomeIcons.solidBell,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    print('IconButton pressed ...');
                  },
                ),
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          // Use Stack to layer the reaction overlay on top of the feed
          child: Stack(
            children: [
              // --- Original Body Content (Feed View) ---
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary,
                ),
                child: Column(
                  children: [
                    // --- TabBar ---
                    Align(
                      alignment: Alignment(0, 0),
                      child: TabBar(
                        labelColor: FlutterFlowTheme.of(context).primaryText,
                        unselectedLabelColor:
                        FlutterFlowTheme.of(context).secondaryText,
                        labelStyle: FlutterFlowTheme.of(context)
                            .titleLarge
                            .override(
                          fontFamily:
                          FlutterFlowTheme.of(context).titleLargeFamily,
                          letterSpacing: 0.0,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).titleLargeFamily),
                        ),
                        unselectedLabelStyle: FlutterFlowTheme.of(context)
                            .titleMedium
                            .override(
                          fontFamily:
                          FlutterFlowTheme.of(context).titleMediumFamily,
                          letterSpacing: 0.0,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).titleMediumFamily),
                        ),
                        indicatorColor:
                        FlutterFlowTheme.of(context).buttonBackground,
                        indicatorWeight: 3.5,
                        tabs: [
                          Tab(
                            text: FFLocalizations.of(context).getText(
                              '40uc9yol' /* Friends */,
                            ),
                          ),
                          Tab(
                            text: FFLocalizations.of(context).getText(
                              '9sgbuu77' /* Discover */,
                            ),
                          ),
                        ],
                        controller: _model.tabBarController,
                        onTap: (i) async {
                          // Prevent tab switching if overlay is shown
                          if (!_isShowingReactions) {
                            [() async {}, () async {}][i]();
                          }
                        },
                      ),
                    ),
                    // --- TabBarView ---
                    Expanded(
                      child: TabBarView(
                        controller: _model.tabBarController,
                        // Disable swiping between tabs when the reaction overlay is visible
                        physics: _isShowingReactions ? NeverScrollableScrollPhysics() : null,
                        children: [
                          // --- Friends Tab Content ---
                          _buildFriendsFeed(), // Your feed content builder

                          // --- Discover Tab Content (Placeholder) ---
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock_outline,
                                color: FlutterFlowTheme.of(context).secondaryText,
                                size: 60.0,
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 10.0),
                                child: Text(
                                  'Coming Soon',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                                    fontFamily: 'Inter Tight',
                                    color: FlutterFlowTheme.of(context).primaryText,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                                child: Text(
                                  'This feature will be available in an upcoming update.',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // --- Comment Input Area (Conditionally Visible) ---

                  ],
                ),
              ), // --- End Original Body Content ---

              // --- Reaction Overlay (Conditionally Visible on Top) ---
              if (_isShowingReactions)
                _buildReactionOverlay(), // The overlay widget you created
            ],
          ),
        ),
      ),
    );
  }


  // --- Helper Method to Build Friends Feed ---
  Widget _buildFriendsFeed() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: FlutterFlowTheme.of(context).buttonBackground));
    }

    if (_posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No posts from friends yet.\nGo add some friends!',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyLarge.override(
                fontFamily: 'Inter',
                color: FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
              ),
            ),
            SizedBox(height: 16),
            // Optionally add an "Add Friends" button here
            // FFButtonWidget(...)
          ],
        ),
      );
    }

    // Use RefreshIndicator for pull-to-refresh
    return RefreshIndicator(
      onRefresh: _fetchFriendsPosts, // Call fetch function on refresh
      color: FlutterFlowTheme.of(context).buttonBackground,
      backgroundColor: FlutterFlowTheme.of(context).primary,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 16.0), // Add padding around list
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          // Extract data safely
          final postId = post['id'] as String? ?? 'unknown_id_${index}';
          final ownerId = post['ownerId'] as String? ?? 'unknown_owner';
          final username = post['username'] as String? ?? 'Unknown User';
          final profilePic = post['profilePictureUrl'] as String?;
          final imageUrl = post['imageUrl'] as String?;
          final caption = post['caption'] as String?;
          final createdAt = post['createdAt'] as Timestamp?;
          final reactions = post['reactions'] as Map<String, dynamic>? ?? {};
          final userReactions = post['userReactions'] as Map<String, dynamic>? ?? {};
          final comments = post['comments'] as List<dynamic>? ?? [];
          // **** ADD THESE TWO LINES to extract the data ****
          final habitIcon = post['habitIcon'] as String?;
          final habitName = post['habitName'] as String?;

          return FeedcardWidget(
            key: ValueKey(postId), // Use post ID as key
            postId: postId,
            ownerId: ownerId,
            username: username,
            profilePictureUrl: profilePic,
            imageUrl: imageUrl,
            caption: caption,
            createdAt: createdAt,
            reactions: reactions,
            userReactions: userReactions,
            comments: comments,
            // **** ADD THESE TWO PARAMETERS ****
            habitIcon: habitIcon, // Pass the icon name string
            habitName: habitName, // Pass the habit name string
            // **** END ADDED PARAMETERS ****
            // Pass interaction callbacks
            onReactButtonPressed: (BuildContext context, String postId, String ownerId, GlobalKey buttonKey) {
              // Don't need context or buttonKey for the new implementation
              setState(() {
                _isShowingReactions = true;
                _reactingToPostId = postId;
                _reactingToOwnerId = ownerId;
              });
            },
            // **** MODIFICATION END ****
            onCommentIconPressedWithData: (postId, ownerId, commentsList) =>
                _handleCommentIconPressed(postId, ownerId, commentsList),
            onProfileTap: () => _handleProfileTap(ownerId),
            onMoreOptionsTap: () => _handleMoreOptionsTap(postId, ownerId),
          );
        },
      ),
    );
  }

  // --- Helper Method to Build Comment Input Area ---


} // End of _FeedscreenWidgetState
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import '/flutter_flow/flutter_flow_theme.dart'; // Adjust import path if needed

class CommentsBottomSheet extends StatefulWidget {
  final String postId;
  final String ownerId;
  final List<dynamic> comments;
  final String currentUserId;
  final String currentUserUsername;
  final String? currentUserProfilePic;
  final Function(String postId, String ownerId, String commentText) onCommentAdded;

  const CommentsBottomSheet({
    Key? key,
    required this.postId,
    required this.ownerId,
    required this.comments,
    required this.currentUserId,
    required this.currentUserUsername,
    required this.currentUserProfilePic,
    required this.onCommentAdded,
  }) : super(key: key);

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  late List<dynamic> _currentComments; // Local copy to update UI instantly

  @override
  void initState() {
    super.initState();
    _currentComments = List.from(widget.comments); // Initialize local list

    // --- FIX 1: REMOVE the automatic focus request ---
    /*
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_commentFocusNode);
    });
    */
    // --- END FIX 1 ---
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  // Helper to format timestamp (relative time)
  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final now = DateTime.now();
    final date = timestamp.toDate();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('dd MMM').format(date); // e.g., 15 Apr
    }
  }

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isNotEmpty) {
      // Call the callback passed from FeedscreenWidget
      widget.onCommentAdded(widget.postId, widget.ownerId, text);

      // --- Optimistic UI Update ---
      final newComment = {
        "username": widget.currentUserUsername,
        "uid": widget.currentUserId,
        "commentText": text,
        "createdAt": Timestamp.now(),
      };
      setState(() {
        _currentComments.insert(0, newComment); // Add to local list
      });
      _commentController.clear();
      _commentFocusNode.unfocus();
    }
  }


  @override
  @override
  Widget build(BuildContext context) {
    // Apply padding to the bottom, controlled by the keyboard visibility.
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Make column height fit content initially
        children: [
          // --- FIX: Add space above the drag handle ---
          SizedBox(height: 16.0), // Adjust height as needed (e.g., 16, 20)
          // --- END FIX ---

          // --- Optional: Drag Handle ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0), // Keep this padding too
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // --- Header ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Comments (${_currentComments.length})',
              style: FlutterFlowTheme.of(context).titleMedium.override(
                  fontFamily: 'Inter',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.0
              ),
            ),
          ),
          Divider(color: Colors.grey[700], height: 1),

          // --- Comments List ---
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _currentComments.length,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              itemBuilder: (context, index) {
                // ... Comment item builder code remains the same ...
                final comment = _currentComments[index];
                final username = comment['username'] as String? ?? 'Unknown';
                final text = comment['commentText'] as String? ?? '';
                final timestamp = comment['createdAt'] as Timestamp?;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: FlutterFlowTheme.of(context).secondary,
                        child: Icon(Icons.person, size: 18, color: Colors.white,),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  username,
                                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.0
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  formatTimestamp(timestamp),
                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                      fontFamily: 'Inter',
                                      color: Colors.grey[500],
                                      letterSpacing: 0.0
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              text,
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  fontFamily: 'Inter',
                                  color: Colors.white,
                                  letterSpacing: 0.0
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // --- Input Field ---
          Divider(color: Colors.grey[700], height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              // ... Input field Row content remains the same ...
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: widget.currentUserProfilePic != null
                      ? NetworkImage(widget.currentUserProfilePic!)
                      : null,
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  child: widget.currentUserProfilePic == null
                      ? Icon(Icons.person, size: 18, color: Colors.white,)
                      : null,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    focusNode: _commentFocusNode,
                    textCapitalization: TextCapitalization.sentences,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Inter', color: Colors.white, letterSpacing: 0.0),
                    decoration: InputDecoration(
                      hintText: "Add a comment...",
                      hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(fontFamily: 'Inter', color: Colors.grey[500], letterSpacing: 0.0),
                      filled: true,
                      fillColor: FlutterFlowTheme.of(context).primaryBackground,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: FlutterFlowTheme.of(context).buttonBackground, width: 1),
                      ),
                    ),
                    onSubmitted: (text) => _submitComment(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: FlutterFlowTheme.of(context).buttonBackground),
                  onPressed: _submitComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
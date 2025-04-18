import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/group/currentuser_message/currentuser_message_widget.dart';
import '/group/friend_message/friend_message_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// ** ADDED IMPORTS **
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Optional for image caching

import 'group_chat_model.dart';
export 'group_chat_model.dart';


class GroupChatWidget extends StatefulWidget {
  // ** ADDED PARAMETERS **
  final String groupId;
  final String groupName;
  final String? groupImageUrl; // Optional image URL

  const GroupChatWidget({
    super.key,
    required this.groupId,
    required this.groupName,
    this.groupImageUrl,
  });

  static String routeName = 'group_chat';
  // Note: Route path might need adjustment if you pass ID via path segment like '/groupChat/:groupId'
  static String routePath = '/groupChat';

  @override
  State<GroupChatWidget> createState() => _GroupChatWidgetState();
}

class _GroupChatWidgetState extends State<GroupChatWidget> {
  late GroupChatModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // ** ADDED STATE **
  User? currentUser;
  Stream<QuerySnapshot>? _messageStream; // Stream for messages

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GroupChatModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    // ** ADDED INITIALIZATION **
    currentUser = FirebaseAuth.instance.currentUser;
    _initializeMessageStream();
  }

  // ** ADDED: Initialize Firestore Stream **
  void _initializeMessageStream() {
    if (widget.groupId.isNotEmpty) {
      _messageStream = FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupId)
          .collection('messages') // Assumes a 'messages' subcollection
          .orderBy('timestamp', descending: true) // Order by timestamp, newest first
          .snapshots();
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // ** ADDED: Send Message Function **
  Future<void> _sendMessage() async {
    final messageText = _model.textController.text.trim();
    if (messageText.isEmpty || currentUser == null || widget.groupId.isEmpty) {
      return; // Don't send empty messages or if user/group info is missing
    }

    final messageData = {
      'text': messageText,
      'senderId': currentUser!.uid,
      'senderName': currentUser!.displayName ?? 'User', // Optional: Store display name
      'timestamp': FieldValue.serverTimestamp(),
      // Add other fields if needed (e.g., sender photo URL)
    };

    try {
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupId)
          .collection('messages')
          .add(messageData);

// --- Inside _sendMessage in GroupChatWidget ---
      _model.textController?.clear(); // Use the ?. operator
// --- End of modification ---      FocusScope.of(context).unfocus(); // Dismiss keyboard (optional)

    } catch (e) {
      print('Error sending message: $e');
      // Show error SnackBar (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context); // Use theme instance
    final bool hasGroupImage = widget.groupImageUrl != null && widget.groupImageUrl!.isNotEmpty;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFF121212), // Or theme.primary
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            backgroundColor: Color(0xFF1A1A1A), // Or theme background?
            automaticallyImplyLeading: false,
            leading: FlutterFlowIconButton(
              borderRadius: 20.0, buttonSize: 40.0,
              icon: Icon( Icons.arrow_back, color: Colors.white, size: 24.0,),
              onPressed: () async {
                // Navigate back appropriately (pop or go to group list)
                context.pop();
                // context.pushNamed(GroupWidget.routeName); // Or navigate to list
              },
            ),
            title: Row( // ** MODIFIED AppBar Title **
              mainAxisSize: MainAxisSize.max,
              children: [
                // Group Icon/Image
                Container(
                  width: 40.0, height: 40.0,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: theme.buttonBackground, // Fallback color
                    shape: BoxShape.circle,
                    image: hasGroupImage
                        ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.groupImageUrl!), // Use NetworkImage
                    )
                        : null,
                  ),
                  child: !hasGroupImage // Show initials or default icon if no image
                      ? Align( alignment: AlignmentDirectional(0.0, 0.0),
                    child: Text( // Display initials (optional)
                      widget.groupName.isNotEmpty ? widget.groupName.substring(0, 1).toUpperCase() : 'G',
                      style: theme.titleMedium.override(fontFamily: 'Manrope', color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )
                      : null,
                ),
                SizedBox(width: 12),
                // Group Name & Member Count (Fetch member count later if needed)
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.groupName, // Use parameter
                      style: theme.titleMedium.override( fontFamily: 'Manrope', color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                    // Text( // Fetch/Pass member count dynamically later
                    //   FFLocalizations.of(context).getText('35tjdagv' /* 5 members */,),
                    //   style: theme.labelSmall.override( fontFamily: 'Manrope', color: Color(0xFF9E9E9E), fontSize: 12.0, fontWeight: FontWeight.w500),
                    // ),
                  ],
                ),
              ],
            ),
            actions: [ // Keep actions
              Padding( padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                child: Row( mainAxisSize: MainAxisSize.max, children: [
                  FlutterFlowIconButton( borderRadius: 20.0, buttonSize: 40.0, icon: Icon( Icons.emoji_events, color: Colors.white, size: 24.0,),
                    onPressed: () async { context.pushNamed(GroupLeaderboardWidget.routeName); },
                  ),
                  FlutterFlowIconButton( borderRadius: 20.0, buttonSize: 40.0, icon: Icon( Icons.more_vert, color: Colors.white, size: 24.0,),
                    onPressed: () async { context.pushNamed(GroupDetailsWidget.routeName, queryParameters: {'groupId': widget.groupId}); }, // Pass groupId
                  ),
                ].divide(SizedBox(width: 8.0)),
                ),
              ),
            ],
            centerTitle: false,
            elevation: 0.0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: Container(
            decoration: BoxDecoration( color: theme.primary,),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Divider
                Container( width: double.infinity, height: 1.0, decoration: BoxDecoration( color: Color(0xFF2A2A2A),),),

                // --- ** MODIFIED: Message List Area ** ---
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _messageStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error loading messages: ${snapshot.error}'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(child: Text('No messages yet. Start the conversation!', style: theme.bodyMedium));
                      }

                      // We have messages, display them in a ListView
                      final messages = snapshot.data!.docs;

                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                        reverse: true, // Show newest messages at the bottom
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final messageDoc = messages[index];
                          final messageData = messageDoc.data() as Map<String, dynamic>? ?? {};

                          final senderId = messageData['senderId'] as String?;
                          final messageText = messageData['text'] as String? ?? '';
                          final senderName = messageData['senderName'] as String?; // Optional
                          final timestamp = messageData['timestamp'] as Timestamp?; // Optional

                          final bool isCurrentUser = senderId == currentUser?.uid;

                          // ** IMPORTANT: Modify child widgets to accept data **
                          // You will need to update CurrentuserMessageWidget and FriendMessageWidget
                          // to accept parameters like messageText, timestamp, senderName etc.
                          if (isCurrentUser) {
                            // Use CurrentuserMessageWidget
                            // TODO: Pass actual data to CurrentuserMessageWidget
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: wrapWithModel( // Keep wrapWithModel if needed
                                model: _model.currentuserMessageModel, // Reuse model instance if appropriate or create new ones
                                updateCallback: () => setState(() {}),
                                // Pass data:
                                child: CurrentuserMessageWidget(
                                  messageText: messageText, // Example parameter
                                  // timestamp: timestamp, // Example parameter
                                ),
                              ),
                            );
                          } else {
                            // Use FriendMessageWidget
                            // TODO: Pass actual data to FriendMessageWidget
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: wrapWithModel( // Keep wrapWithModel if needed
                                model: _model.friendMessageModel, // Reuse model instance if appropriate or create new ones
                                updateCallback: () => setState(() {}),
                                // Pass data:
                                child: FriendMessageWidget(
                                  messageText: messageText, // Example parameter
                                  senderName: senderName, // Example parameter
                                  // timestamp: timestamp, // Example parameter
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                // --- ** END: Message List Area ** ---


                // --- Message Input Area (Connect Send Button) ---
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration( color: Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(24.0),), // Rounded container
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 4), // Padding around input row
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Text Input
                          Expanded(
                            child: TextFormField(
                              controller: _model.textController,
                              focusNode: _model.textFieldFocusNode,
                              obscureText: false,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                hintText: FFLocalizations.of(context).getText('8w3nbhcn' /* Type a message... */,),
                                hintStyle: theme.bodyMedium.override( fontFamily: 'Manrope', color: Color(0xFF9E9E9E), fontSize: 14.0, fontWeight: FontWeight.w500),
                                // Remove borders within the outer container
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                                filled: true, // Keep fill
                                fillColor: Color(0xFF2A2A2A), // Match icon button background
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Adjust padding
                              ),
                              style: theme.bodyMedium.override( fontFamily: 'Manrope', color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.w500),
                              maxLines: 5, // Allow multi-line input
                              minLines: 1,
                              validator: _model.textControllerValidator.asValidator(context),
                            ),
                          ),
                          // Send Button
                          FlutterFlowIconButton(
                            borderRadius: 20.0, buttonSize: 40.0, fillColor: Color(0xFF2797FF),
                            icon: Icon( Icons.send, color: Colors.white, size: 20.0,), // Smaller icon
                            onPressed: _sendMessage, // ** CONNECTED SEND FUNCTION **
                          ),
                        ].divide(SizedBox(width: 8.0)), // Spacing in input row
                      ),
                    ),
                  ),
                ),
                // --- End Message Input Area ---

              ],
            ),
          ),
        ),
      ),
    );
  }
}
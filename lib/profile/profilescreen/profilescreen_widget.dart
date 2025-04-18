import 'dart:io'; // Added for File
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Added for Storage
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart'; // Added for Image Picker
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
// Import the modified FriendlistitemWidget
import '/profile/friendlistitem/friendlistitem_widget.dart';
import 'dart:ui';
import '/index.dart'; // Assuming this includes navigation routes

import 'profilescreen_model.dart';
export 'profilescreen_model.dart';


class ProfilescreenWidget extends StatefulWidget {
  const ProfilescreenWidget({super.key});

  static String routeName = 'Profilescreen';
  static String routePath = '/profilescreen';

  @override
  State<ProfilescreenWidget> createState() => _ProfilescreenWidgetState();
}

class _ProfilescreenWidgetState extends State<ProfilescreenWidget> {
  late ProfilescreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // --- State Variables ---
  final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Map<String, dynamic>> _searchResults = [];

  // --- User Profile Data State Variables ---
  String? _profilePictureUrl;
  String _username = 'Username';
  String _memberSince = 'Member since...';
  String _bio = 'No bio yet.';
  bool _isLoadingProfile = true;
  bool _isUploadingPicture = false; // Added for upload loading state

  final ImagePicker _picker = ImagePicker(); // Added ImagePicker instance

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfilescreenModel());

    _model.textController ??= _searchController;
    _model.textFieldFocusNode ??= FocusNode();

    _searchController.addListener(() {
      if (mounted) {
        setState(() {
          _searchQuery = _searchController.text.trim().toLowerCase();
        });
      }
    });

    _fetchProfileData();
  }

  @override
  void dispose() {
    _searchController.removeListener(() {});
    _searchController.dispose();
    _model.dispose();
    super.dispose();
  }

  // --- Function to Fetch Current User's Profile Data ---
  Future<void> _fetchProfileData() async {
    if (currentUserId.isEmpty) {
      if (mounted) {
        setState(() => _isLoadingProfile = false);
      }
      return;
    }
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(currentUserId);
      final userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data();
        if (mounted) {
          setState(() {
            _profilePictureUrl = userData?['profilePicture'];
            _username = userData?['username'] ?? 'Username';
            _bio = userData?['bio'] ?? 'No bio yet.';

            Timestamp? creationTimestamp = userData?['createdAt'];
            if (creationTimestamp != null) {
              _memberSince = 'Member since ${DateFormat.yMMMd().format(creationTimestamp.toDate())}';
            } else {
              User? currentUser = FirebaseAuth.instance.currentUser;
              if (currentUser?.metadata.creationTime != null) {
                _memberSince = 'Member since ${DateFormat.yMMMd().format(currentUser!.metadata.creationTime!)}';
              } else {
                _memberSince = 'Member since Unknown';
              }
            }
            _isLoadingProfile = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoadingProfile = false;
            _username = 'User Not Found';
          });
        }
        print("User document does not exist.");
      }
    } catch (e) {
      print('Error fetching profile data: $e');
      if (mounted) {
        setState(() {
          _isLoadingProfile = false;
          _username = 'Error Loading';
        });
      }
    }
  }

  // --- Function to Pick and Upload Profile Picture --- (Adapted from friend_socialScreen.dart)
  Future<void> _pickAndUploadProfilePicture() async {
    if (_isUploadingPicture) return; // Prevent multiple uploads

    if (mounted) {
      setState(() => _isUploadingPicture = true);
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) {
        if (mounted) {
          setState(() => _isUploadingPicture = false); // Reset loading state if cancelled
        }
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null || currentUserId.isEmpty) {
        throw Exception("User not logged in properly.");
      }

      // Define storage reference
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures/${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg'); // Added timestamp for uniqueness

      // Upload file
      final uploadTask = storageRef.putFile(File(pickedFile.path));
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Update Firestore
      await FirebaseFirestore.instance.collection('users').doc(currentUserId).update({
        'profilePicture': downloadUrl,
      });

      // Update UI state
      if (mounted) {
        setState(() {
          _profilePictureUrl = downloadUrl;
          _isUploadingPicture = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture updated!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      print("Error uploading profile picture: $e");
      if (mounted) {
        setState(() => _isUploadingPicture = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile picture: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }


  // --- Helper Functions for Friends/Search (Keep as is) ---
  Future<String?> getUidFromUsername(String username) async {
    // ... (Existing implementation) ...
    try {
      final usernameDoc = await FirebaseFirestore.instance
          .collection('usernames') // Assuming you have a 'usernames' collection mapping usernames to UIDs
          .doc(username)
          .get();
      if (usernameDoc.exists) { //
        return usernameDoc.data()?['uid']; //
      } else {
        // Fallback: Search the 'users' collection if 'usernames' doesn't exist or doesn't contain the user
        final querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: username)
            .limit(1)
            .get();
        if (querySnapshot.docs.isNotEmpty) {
          return querySnapshot.docs.first.id; // Return the document ID (which is the UID)
        }
        return null; //
      }
    } catch (e) {
      print('Error fetching UID for $username: $e'); //
      return null; //
    }
  }
  Future<List<Map<String, dynamic>>> _fetchFriends() async {
    // ... (Existing implementation) ...
    if (currentUserId.isEmpty) return []; // Added check
    try {
      final friendsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('addedFriends')
          .get(); //
      final List<Map<String, dynamic>> friendsData = []; //

      for (var doc in friendsSnapshot.docs) {
        final friendUid = doc.id;
        final friendDoc = await FirebaseFirestore.instance.collection('users').doc(friendUid).get(); //

        if (friendDoc.exists) { //
          final friendData = friendDoc.data();
          if (friendData != null) { //
            friendsData.add({
              'uid': friendUid, //
              'username': friendData['username'] ?? 'Unknown', //
              // Use a placeholder if profilePicture is missing or null
              'profilePicture': friendData['profilePicture'] ?? '', //
            });
          }
        }
      }
      return friendsData; //
    } catch (e) {
      print('Error fetching friends: $e'); //
      return []; //
    }
  }
  Future<void> _removeFriend(String friendUid) async {
    // ... (Existing implementation) ...
    if (friendUid.isEmpty || currentUserId.isEmpty) { // Added checks
      print('Error: Invalid UIDs for removing friend.');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to remove friend. Invalid user.")),
        );
      }
      return;
    }

    // Confirmation Dialog
    bool confirm = await showDialog(
      context: context,
      builder: (alertDialogContext) {
        return AlertDialog(
          title: Text('Remove Friend'),
          content: Text('Are you sure you want to remove this friend?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(alertDialogContext, false), // Dismiss and return false
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(alertDialogContext, true), // Dismiss and return true
              child: Text('Remove'),
            ),
          ],
        );
      },
    ) ?? false; // Default to false if dialog is dismissed

    if (!confirm) {
      return; // User cancelled
    }


    try {
      // Remove from current user's list
      await FirebaseFirestore.instance.collection('users').doc(currentUserId).collection('addedFriends').doc(friendUid).delete(); //
      // Remove from friend's list
      await FirebaseFirestore.instance.collection('users').doc(friendUid).collection('addedFriends').doc(currentUserId).delete(); //

      if (mounted) {
        setState(() {}); // Refresh UI to reflect removal
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Friend removed."), backgroundColor: Colors.green), //
        );
      }
    } catch (e) {
      print('Error removing friend: $e'); //
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to remove friend.")), //
        );
      }
    }
  }
  Future<List<Map<String, dynamic>>> _searchUsers(String query) async {
    // ... (Existing implementation) ...
    if (query.isEmpty) return []; //
    if (currentUserId.isEmpty) return []; // Added check

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username_lowercase', isGreaterThanOrEqualTo: query) // Search lowercase field
          .where('username_lowercase', isLessThanOrEqualTo: query + '\uf8ff')
          .orderBy('username_lowercase') // Order by lowercase field
          .limit(10)
          .get(); //

      // Filter out the current user and existing friends
      final friendsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('addedFriends')
          .get();
      final friendUids = friendsSnapshot.docs.map((doc) => doc.id).toSet(); // Set for efficient lookup

      return querySnapshot.docs
          .where((doc) => doc.id != currentUserId && !friendUids.contains(doc.id)) // Filter out self and existing friends
          .map((doc) { //
        final userData = doc.data();
        return {
          'uid': doc.id, //
          'username': userData['username'] ?? 'Unknown', //
          'profilePicture': userData['profilePicture'] ?? '', //
        };
      }).toList();
    } catch (e) {
      print('Error searching users: $e'); //
      return []; //
    }
  }
  Future<void> _sendFriendRequest(String targetUid) async {
    // ... (Existing implementation) ...
    if (targetUid.isEmpty || targetUid == currentUserId) { //
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cannot add yourself.")), //
        );
      }
      return; //
    }
    if (currentUserId.isEmpty) { // Added check
      print('Error: Current user ID is empty.');
      return;
    }

    try {
      final targetUserRef = FirebaseFirestore.instance.collection('users').doc(targetUid); //
      final targetUserSnapshot = await targetUserRef.get(); //

      if (!targetUserSnapshot.exists) { //
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User not found.")), //
          );
        }
        return; //
      }

      // Check if a request was already sent or if they are already friends
      final sentRequestDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('sentRequests')
          .doc(targetUid)
          .get();
      final pendingRequestDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('pending')
          .doc(targetUid)
          .get();
      final friendDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('addedFriends')
          .doc(targetUid)
          .get();

      if (sentRequestDoc.exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Friend request already sent.")),
          );
        }
        return;
      }
      if (pendingRequestDoc.exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("This user already sent you a request. Check your requests tab.")),
          );
        }
        return;
      }
      if (friendDoc.exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("You are already friends with this user.")),
          );
        }
        return;
      }


      // Add to target user's pending requests
      await FirebaseFirestore.instance
          .collection('users')
          .doc(targetUid)
          .collection('pending')
          .doc(currentUserId)
          .set({'uid': currentUserId, 'timestamp': FieldValue.serverTimestamp()}); // Added timestamp

      // Add to current user's sent requests
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .collection('sentRequests')
          .doc(targetUid)
          .set({'uid': targetUid, 'timestamp': FieldValue.serverTimestamp()}); // Added timestamp

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Friend request sent successfully!"), //
            backgroundColor: Colors.green, //
          ),
        );
      }
    } catch (e) {
      print('Error sending friend request: $e'); //
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to send friend request.")), //
        );
      }
    }
  }

  // --- End Helper Functions ---


  // --- Helper Widget Builders ---
  Widget _buildFriendsList() {
    // ... (Existing implementation) ...
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchFriends(), //
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator( color: FlutterFlowTheme.of(context).info)); //
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error loading friends', style: TextStyle(color: Colors.red)));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No friends yet. Add some!', style: FlutterFlowTheme.of(context).bodyMedium));
        }

        final friends = snapshot.data!;

        return ListView.separated( // Use separated for dividers
          padding: EdgeInsets.zero,
          primary: false, // Important if nested in another scroll view
          shrinkWrap: true, // Important if nested
          scrollDirection: Axis.vertical,
          itemCount: friends.length, //
          itemBuilder: (context, index) {
            final friend = friends[index]; //
            // Use the modified FriendlistitemWidget
            return FriendlistitemWidget(
              key: ValueKey(friend['uid']), // Add key for better state management
              friendUid: friend['uid'] ?? '', // Pass UID
              username: friend['username'] ?? 'Unknown', // Pass username
              profilePictureUrl: friend['profilePicture'], // Pass profile picture URL
              onRemoveFriend: (uid) => _removeFriend(uid), // Pass the remove function callback
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 12.0), // Use SizedBox as separator
        );
      },
    );
  }
  Widget _buildSearchResultsList() {
    // ... (Existing implementation) ...
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _searchUsers(_searchQuery), // Pass the search query
      builder: (context, snapshot) {
        if (_searchQuery.isEmpty) {
          return Container(); // Don't show anything if search is empty
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(); // Show nothing while waiting
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error searching users', style: TextStyle(color: Colors.red)));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No users found.', style: FlutterFlowTheme.of(context).bodyMedium));
        }

        final searchResults = snapshot.data!; //

        return ListView.builder( //
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: searchResults.length, //
          itemBuilder: (context, index) {
            final user = searchResults[index]; //
            // Build list tile for search results
            return Container( // Wrap with Container for styling
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondary, // Use secondary color
                borderRadius: BorderRadius.circular(9.5),
                border: Border.all(
                  color: FlutterFlowTheme.of(context).primaryBordercolor,
                ),
              ),
              margin: const EdgeInsets.only(bottom: 8.0), // Add margin between items
              child: ListTile( //
                leading: CircleAvatar( //
                  radius: 20, // Match friend list item size
                  backgroundImage: (user['profilePicture'] != null && user['profilePicture'].isNotEmpty) // Check if URL is valid
                      ? NetworkImage(user['profilePicture']!)
                      : null, //
                  backgroundColor: Color(0xFF2E353E), // Placeholder background
                  child: (user['profilePicture'] == null || user['profilePicture'].isEmpty)
                      ? Icon(Icons.person, size: 24.0, color: FlutterFlowTheme.of(context).info) // Placeholder icon
                      : null,
                ),
                title: Text( //
                  user['username'] ?? 'Unknown', //
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                    color: FlutterFlowTheme.of(context).info,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.bold,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                        FlutterFlowTheme.of(context).bodyMediumFamily),
                  ),
                ),
                trailing: IconButton( //
                  icon: Icon(
                    Icons.person_add_alt_1_rounded, // Use a suitable add icon
                    color: FlutterFlowTheme.of(context).secondaryColor, // Use accent color
                    size: 24.0,
                  ),
                  tooltip: 'Send Friend Request', // Add tooltip
                  onPressed: () async { //
                    _sendFriendRequest(user['uid'] ?? ''); // Pass UID
                  },
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0), // Adjust padding
              ),
            );
          },
        );
      },
    );
  }
  // --- End Helper Widget Builders ---


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
        appBar: AppBar(
          // ... (AppBar remains the same) ...
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            FFLocalizations.of(context).getText(
              'qfklgi1u' /* My Profile */,
            ),
            style: FlutterFlowTheme.of(context).displaySmall.override(
              fontFamily: FlutterFlowTheme.of(context).displaySmallFamily,
              color: FlutterFlowTheme.of(context).info,
              letterSpacing: 0.0,
              useGoogleFonts: GoogleFonts.asMap().containsKey(
                  FlutterFlowTheme.of(context).displaySmallFamily),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  FlutterFlowIconButton(
                    borderRadius: 20.0,
                    buttonSize: 40.0,
                    icon: Icon(
                      Icons.calendar_today_rounded,
                      color: FlutterFlowTheme.of(context).info,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      context.pushNamed('Calendar'); // Use correct route name if different
                    },
                  ),
                  FlutterFlowIconButton(
                    borderRadius: 20.0,
                    buttonSize: 40.0,
                    icon: Icon(
                      Icons.settings_rounded,
                      color: FlutterFlowTheme.of(context).info,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      context.pushNamed('Settings'); // Use correct route name if different
                    },
                  ),
                ].divide(SizedBox(width: 8.0)),
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0.0),
                bottomRight: Radius.circular(0.0),
                topLeft: Radius.circular(0.0),
                topRight: Radius.circular(0.0),
              ),
              border: Border.all(
                color: FlutterFlowTheme.of(context).primary,
                width: 0.0,
              ),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Profile Header Section ---
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: _isLoadingProfile
                            ? Center(child: CircularProgressIndicator(color: FlutterFlowTheme.of(context).info))
                            : Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // --- User Avatar (Now Tappable) ---
                            GestureDetector( // Added GestureDetector
                              onTap: _pickAndUploadProfilePicture, // Call picker function on tap
                              child: Stack( // Use Stack to overlay loading indicator
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF2E353E),
                                      image: (_profilePictureUrl != null && _profilePictureUrl!.isNotEmpty)
                                          ? DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(_profilePictureUrl!),
                                      )
                                          : null,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context).secondaryColor,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: (_profilePictureUrl == null || _profilePictureUrl!.isEmpty)
                                        ? Icon(
                                      Icons.person,
                                      size: 60.0,
                                      color: FlutterFlowTheme.of(context).info,
                                    )
                                        : null,
                                  ),
                                  // --- Loading Indicator during Upload ---
                                  if (_isUploadingPicture)
                                    Container(
                                      width: 100.0,
                                      height: 100.0,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(FlutterFlowTheme.of(context).info),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (!_isUploadingPicture) // Only show text if not uploading
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Tap to change picture',
                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                    color: Colors.grey[400],
                                    letterSpacing: 0.0,
                                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                                        FlutterFlowTheme.of(context).bodySmallFamily),
                                  ),
                                ),
                              ),
                            SizedBox(height: 16.0),

                            // --- User Info ---
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _username,
                                  style: FlutterFlowTheme.of(context).titleLarge.override(
                                    fontFamily: FlutterFlowTheme.of(context).titleLargeFamily,
                                    color: FlutterFlowTheme.of(context).info,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                                        FlutterFlowTheme.of(context).titleLargeFamily),
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  _memberSince,
                                  style: FlutterFlowTheme.of(context).labelMedium.override(
                                    fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                                        FlutterFlowTheme.of(context).labelMediumFamily),
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  _bio,
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                                        FlutterFlowTheme.of(context).bodySmallFamily),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.0),

                    // --- Search Bar ---
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 16.0),
                      child: Container(
                        // ... (Search Bar remains the same) ...
                        width: double.infinity,
                        child: TextFormField(
                          controller: _model.textController,
                          focusNode: _model.textFieldFocusNode,
                          autofocus: false,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: FFLocalizations.of(context).getText(
                              '3nqlkwra' /* Search users... */,
                            ),
                            hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                              color: Color(0xFF888888),
                              letterSpacing: 0.0,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context).bodyMediumFamily),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF333333),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).secondaryColor,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            filled: true,
                            fillColor: Color(0xFF1A1A1A),
                            contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xFF888888),
                              size: 24.0,
                            ),
                            suffixIcon: _model.textController!.text.isNotEmpty
                                ? IconButton(
                              icon: Icon(Icons.clear, color: Color(0xFF888888), size: 20.0,),
                              onPressed: () {
                                _model.textController?.clear();
                                setState(() { _searchQuery = ''; });
                                FocusScope.of(context).unfocus();
                              },
                            )
                                : null,
                          ),
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                            color: Colors.white,
                            letterSpacing: 0.0,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyMediumFamily),
                          ),
                          cursorColor: FlutterFlowTheme.of(context).secondaryColor,
                          validator: _model.textControllerValidator.asValidator(context),
                        ),
                      ),
                    ),

                    // --- Conditional Content: Search Results or Friends List ---
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 8.0, 0.0),
                      child: AnimatedSwitcher(
                        // ... (Remains the same) ...
                        duration: const Duration(milliseconds: 300),
                        child: _searchQuery.isEmpty
                            ? _buildFriendsList() // Show friends list if search is empty
                            : _buildSearchResultsList(), // Show search results otherwise
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// File: prabit_design/lib/photo/post_screen/post_screen_widget.dart
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../habit/congrats/congrats_screen_widget.dart';
import '../../photo/post_screen/post_screen_model.dart';
import '../../congrats/congrats_screen_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:io'; // Import dart:io for File
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:path_provider/path_provider.dart'; // Import path_provider

import 'post_screen_model.dart';
export 'post_screen_model.dart';
import '/index.dart'; // Import for navigation routes


class HabitPostScreenWidget extends StatefulWidget { // Renamed class
  // Receive image path and habit data
  final String? imageUrl; // Make nullable to handle potential routing issues
  final Map<String, dynamic>? habit; // Make nullable

  const HabitPostScreenWidget({
    Key? key,
    this.imageUrl,
    this.habit,
  }) : super(key: key);

  // Define routeName and routePath
  static const String routeName = 'HabitPostScreen';
  static const String routePath = '/habitPostScreen';


  @override
  State<HabitPostScreenWidget> createState() => _HabitPostScreenWidgetState();
}

class _HabitPostScreenWidgetState extends State<HabitPostScreenWidget> {
  late PostScreenModel _model; // Declared
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // State from habit_postScreen.txt
  bool _isPublic = true; // Default to public/share with friends
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PostScreenModel()); // Initialized

    // Use _model's controller and focus node
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    // Check if habit data is available
    if (widget.habit == null || widget.imageUrl == null) {
      print("⚠️ Warning: Habit data or image URL is missing on Post Screen init.");
      // Optionally show an error or navigate back immediately
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Show snackbar after build
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: Missing data for post screen.")),
        );
        Navigator.of(context).pop(); // Go back if data is missing
      });
    } else {
      // Determine initial switch state based on habit type
      _isPublic = !(widget.habit!['isGroupHabit'] == true); // Group habits default to NOT public friends feed
      _model.switchValue = _isPublic; // Sync with FF model's switch state
    }
  }

  @override
  void dispose() {
    _model.dispose(); // Dispose FlutterFlow model (includes text controller & focus node)
    super.dispose();
  }

  // --- Functions from habit_postScreen.txt ---

  Future<String> _uploadImageToFirebase(String localPath) async {
    //
    try {
      final fileName = '${FirebaseAuth.instance.currentUser?.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File(localPath);
      if (!await file.exists()) {
        throw Exception('File does not exist at path: $localPath');
      }
      final storageRef = FirebaseStorage.instance.ref().child('habit_images/$fileName'); // Use a specific folder

      print("Uploading image to ${storageRef.fullPath}...");
      await storageRef.putFile(file);
      final downloadURL = await storageRef.getDownloadURL();
      print("Image uploaded successfully: $downloadURL");
      return downloadURL;
    } catch (e) {
      print("Error uploading image: $e");
      throw Exception('Error uploading image: $e');
    }
  }

  // Saving locally might be redundant if just uploaded, but kept logic
  Future<void> _saveImageLocally(String localPath) async {
    //- Consider if this is truly needed after uploading
    try {
      final directory = await getApplicationDocumentsDirectory();
      final now = DateTime.now();
      final fileName = 'Photo_${now.year}_${now.month.toString().padLeft(2, '0')}_${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}_${now.minute.toString().padLeft(2, '0')}_${now.second.toString().padLeft(2, '0')}.jpg';
      final localFile = File('${directory.path}/$fileName');
      await File(localPath).copy(localFile.path);
      print("DEBUG: Image saved locally at ${localFile.path}");
    } catch (e) {
      print('Error saving image locally: $e');
      // Don't throw, local save failure shouldn't block the post
    }
  }

  Future<void> _updateStreak() async {
    //
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('DEBUG: User not authenticated for streak update.');
      return;
    }
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final userDoc = await transaction.get(userRef);
        final data = userDoc.data();
        int currentStreak = 0;
        DateTime? lastPostDate;
        int highestStreak = 0;

        if (userDoc.exists && data != null) {
          currentStreak = data['streak'] ?? 0;
          highestStreak = data['highestStreak'] ?? 0;
          final lastPostDateStr = data['lastPostDate'] as String?;
          if (lastPostDateStr != null) {
            lastPostDate = DateTime.tryParse(lastPostDateStr);
          }
        } else {
          print('DEBUG: User document does not exist. Initializing streak.');
          transaction.set(userRef, {
            'streak': 1,
            'lastPostDate': DateTime.now().toIso8601String(),
            'highestStreak': 1,
          }, SetOptions(merge: true)); // Use merge option
          return 1; // Return new streak
        }

        final currentDate = DateTime.now();
        final todayStart = DateTime(currentDate.year, currentDate.month, currentDate.day);
        final yesterdayStart = todayStart.subtract(const Duration(days: 1));

        int newStreak = currentStreak;
        bool updated = false;

        if (lastPostDate != null) {
          final lastPostDayStart = DateTime(lastPostDate.year, lastPostDate.month, lastPostDate.day);

          if (lastPostDayStart.isAtSameMomentAs(todayStart)) {
            print('DEBUG: Streak unchanged. Already posted today.');
            // No update needed, just update lastPostDate to now if wanted? Maybe not.
            // transaction.update(userRef, {'lastPostDate': currentDate.toIso8601String()}); // Optional: update timestamp
            return currentStreak; // Return current streak
          } else if (lastPostDayStart.isAtSameMomentAs(yesterdayStart)) {
            // Last post was yesterday, increment streak
            newStreak = currentStreak + 1;
            updated = true;
            print('DEBUG: Streak increased to $newStreak.');
          } else {
            // Last post was before yesterday, reset streak
            newStreak = 1;
            updated = true;
            print('DEBUG: Streak reset to 1.');
          }
        } else {
          // No last post date, start streak at 1
          newStreak = 1;
          updated = true;
          print('DEBUG: Initializing streak to 1.');
        }

        if (updated) {
          final newHighestStreak = newStreak > highestStreak ? newStreak : highestStreak;
          transaction.update(userRef, {
            'streak': newStreak,
            'lastPostDate': currentDate.toIso8601String(),
            'highestStreak': newHighestStreak,
          });
        }
        return newStreak; // Return the potentially updated streak
      });
    } catch (e) {
      print("Error updating streak: $e");
    }
  }


  Future<void> _handlePost() async {
    //
    // --- Basic Validation ---
    if (widget.imageUrl == null || widget.imageUrl!.isEmpty) {
      _showSnackbar("Error: Image is missing.");
      return;
    }
    if (widget.habit == null || widget.habit!.isEmpty) {
      _showSnackbar("Error: Habit data is missing.");
      return;
    }
    if (_model.textController.text.trim().isEmpty) {
      _showSnackbar("Please enter a caption.");
      _model.textFieldFocusNode?.requestFocus(); // Focus on caption field
      return;
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnackbar("Error: Not logged in.");
      return;
    }

    setState(() => _loading = true);

    try {
      print("📸 Uploading post for UID: ${user.uid}");

      // 1. Upload Image
      final downloadURL = await _uploadImageToFirebase(widget.imageUrl!);
      print("✅ Image uploaded: $downloadURL");

      // 2. Save Image Locally (Optional - consider removing if not needed)
      // await _saveImageLocally(widget.imageUrl!);
      // print("✅ Image saved locally (optional step)");

      // 3. Prepare Post Data
      final postData = {
        'url': downloadURL,
        'habitId': widget.habit!['id'], // Store habit ID
        'habitName': widget.habit!['name'], // Store habit name
        'habitIcon': widget.habit!['iconStringName'] as String?, // <-- Get the icon STRING from the habit definition data
        'caption': _model.textController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'reactions': {}, // Initialize reactions map
        'userReactions': {}, // Initialize user reactions map
        'comments': [], // Initialize comments list
        'ownerId': user.uid, // Use 'ownerId' for clarity
        'ownerUsername': (await user.reload().then((_) => FirebaseAuth.instance.currentUser?.displayName)) ?? 'Unknown User', // Fetch latest display name
        'ownerProfilePic': user.photoURL, // Use user's photo URL
        'isPublic': _isPublic, // Save visibility status
      };
      print("📝 Post Data Prepared: ${postData['caption']}");

      // 4. Save to Firestore
      WriteBatch batch = FirebaseFirestore.instance.batch();
      DocumentReference? groupMessageRef; // For group posts
      DocumentReference? userPublicPostRef; // For user's public feed
      DocumentReference? userPrivatePostRef; // For user's private store (if needed)

      // --- Determine where to post ---
      bool isGroupHabit = widget.habit!['isGroupHabit'] == true;
      String? groupId = widget.habit!['groupId'];

      if (isGroupHabit && groupId != null && groupId.isNotEmpty) {
        print("📢 Posting to Group: $groupId");
        groupMessageRef = FirebaseFirestore.instance
            .collection('groups')
            .doc(groupId)
            .collection('messages')
            .doc(); // Generate doc ref for batch
        batch.set(groupMessageRef, {
          ...postData,
          'type': 'photo', // Specific type for group messages
        });

        // Add to Leaderboard (consider if this logic belongs here or cloud function)
        DocumentReference leaderboardRef = FirebaseFirestore.instance
            .collection('leaderboard') // Top-level leaderboard collection
            .doc(groupId)             // Document per group
            .collection('members')      // Subcollection for members
            .doc(user.uid);             // Document per user
        batch.set(leaderboardRef, {
          'uid': user.uid, // Add user UID
          // Consider fetching user details like username/pic here or store separately
          'amount_completed': FieldValue.increment(1),
        }, SetOptions(merge: true)); // Increment count, merge other fields if they exist

      }

      // Post to user's 'shareWithFriendsPosts' if it's public or if it's a non-group habit shared with friends
      if (_isPublic) {
        print("🌎 Posting publicly (to user's shareWithFriendsPosts)");
        userPublicPostRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('shareWithFriendsPosts') // Collection for friend feed
            .doc(); // Generate doc ref
        batch.set(userPublicPostRef, postData);
      } else if (!isGroupHabit) {
        // Handle private personal habit posts if needed (e.g., save locally or specific private collection)
        print("🔒 Posting personal habit privately");
        // Example: Save to a 'privatePosts' collection (only metadata, maybe?)
        // userPrivatePostRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('privatePosts').doc();
        // batch.set(userPrivatePostRef, Map.of(postData)..remove('url')); // Example: Don't store URL for private
      }


      // 5. Save to User's Calendar Subcollection
      final calendarDate = DateTime.now().toIso8601String().split('T').first; // YYYY-MM-DD format
      DocumentReference calendarPhotoRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('calendar') // User-specific calendar
          .doc(calendarDate)     // Document for the day
          .collection('photos')  // Subcollection for photos on that day
          .doc();                // Generate doc ref
      batch.set(calendarPhotoRef, {
        'habitName': widget.habit!['name'],
        // Store the public URL, not the local path
        'imageUrl': downloadURL,
        'timestamp': FieldValue.serverTimestamp(),
        // Link back to the main post if needed
        'groupPostRef': groupMessageRef?.path, // Store path if group post
        'userPostRef': userPublicPostRef?.path, // Store path if public post
      });
      print("📅 Added to calendar for $calendarDate");

      // 6. Commit Batch
      await batch.commit();
      print("✅ Firestore Batch Commit Successful!");

      // 7. Update Streak (after successful post)
      await _updateStreak();
      print("🔥 Streak updated!");

      // 8. Navigate to Congrats Screen
      if (mounted) {
        context.pushNamed(CongratsScreenWidget.routeName); // Navigate to Congrats
      }

    } catch (e) {
      print("🚨 ERROR in _handlePost(): $e");
      if (mounted) _showSnackbar("Error posting: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: FlutterFlowTheme.of(context).error, // Use error color for errors
      ),
    );
  }

  // --- Build Method ---
  @override
  Widget build(BuildContext context) {
    final bool isGroupHabit = widget.habit?['isGroupHabit'] == true;
    final String habitName = widget.habit?['name'] ?? 'Post Check-In';
    // Determine the label for the switch based on habit type
    final String switchLabel = isGroupHabit ? 'Share to Friends Feed Too?' : 'Share with Friends';

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primary, // Dark background
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false, // Remove default back button
          leading: FlutterFlowIconButton( // Custom back button
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.close, // Use Close icon
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () async {
              context.pop(); // Simple pop back
            },
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Optional: Add habit icon here if available in habit data
              // Icon( _getIconData(widget.habit?['icon'], widget.habit?['iconFontFamily']), color: Colors.white, size: 20),
              // SizedBox(width: 8),
              Text(
                habitName,
                style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Inter Tight',
                  color: Colors.white,
                  fontSize: 20.0, // Slightly smaller title
                  letterSpacing: 0.0,
                ),
              ),
            ],
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.0, // No shadow
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView( // Allow scrolling if content overflows
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children horizontally
                children: [
                  // --- Image Preview ---
                  if (widget.imageUrl != null)
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width - 32, // Square aspect ratio based on width
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondary, // Darker bg for image frame
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.file(
                          File(widget.imageUrl!), // Display the image from local path
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(child: Icon(Icons.error, color: Colors.red, size: 40)), // Show error icon if file fails
                        ),
                      ),
                    )
                  else // Show placeholder if image URL is missing
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width - 32,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondary,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Center(child: Text("Image not found", style: TextStyle(color: Colors.white))),
                    ),

                  SizedBox(height: 16.0),

                  // --- Caption Input ---
                  TextFormField(
                    controller: _model.textController,
                    focusNode: _model.textFieldFocusNode,
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Add a caption...',
                      hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).alternate, // Subtle border
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).buttonBackground, // Highlight border on focus
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).error,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context).error,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      fillColor: FlutterFlowTheme.of(context).secondary, // Darker input background
                      contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      letterSpacing: 0.0,
                    ),
                    maxLines: 4, // Allow multiple lines for caption
                    minLines: 1,
                    cursorColor: FlutterFlowTheme.of(context).buttonBackground,
                    validator: _model.textControllerValidator.asValidator(context),
                  ),

                  SizedBox(height: 16.0),

                  // --- Share Toggle ---
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondary, // Match input background
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: FlutterFlowTheme.of(context).alternate, width: 1.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          switchLabel, // Dynamic label
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            color: Colors.white,
                            letterSpacing: 0.0,
                          ),
                        ),
                        Switch.adaptive(
                          value: _isPublic, // Use internal state
                          onChanged: (newValue) async {
                            setState(() {
                              _isPublic = newValue!; // Update internal state
                              _model.switchValue = newValue; // Sync FF model state if needed
                            });
                          },
                          activeColor: FlutterFlowTheme.of(context).buttonBackground, // Theme color for active
                          activeTrackColor: FlutterFlowTheme.of(context).buttonBackground.withOpacity(0.5),
                          inactiveTrackColor: FlutterFlowTheme.of(context).alternate,
                          inactiveThumbColor: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.0), // More space before button

                  // --- Post Button ---
                  FFButtonWidget(
                    onPressed: _loading ? null : _handlePost, // Disable button when loading
                    text: _loading ? 'Posting...' : 'Post Check-In',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50.0,
                      padding: EdgeInsets.all(8.0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).buttonBackground,
                      textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                      elevation: 2.0, // Slight elevation
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                      disabledColor: Colors.grey[700], // Grey out when loading
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
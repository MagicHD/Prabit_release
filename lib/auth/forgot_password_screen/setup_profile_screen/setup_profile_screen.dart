import 'dart:io'; // Required for File type
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:google_fonts/google_fonts.dart';

// Import the model
import 'setup_profile_screen_model.dart';
export 'setup_profile_screen_model.dart'; // Export model for potential use elsewhere

class SetupProfileScreenWidget extends StatefulWidget {
  const SetupProfileScreenWidget({Key? key}) : super(key: key);

  static String routeName = 'setupProfile_screen';
  static String routePath = '/setupProfileScreen';

  @override
  _SetupProfileScreenWidgetState createState() =>
      _SetupProfileScreenWidgetState();
}

class _SetupProfileScreenWidgetState extends State<SetupProfileScreenWidget> {
  // Use the model
  late SetupProfileScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>(); // Optional: for form validation

  @override
  void initState() {
    super.initState();
    // Create the model instance using FlutterFlow's utility
    _model = createModel(context, () => SetupProfileScreenModel());

    // Initialize the text controller here, linking it to the model's controller
    _model.bioController ??= TextEditingController();

    // It's generally better practice to initialize focus nodes here too if needed
    // _model.bioFocusNode ??= FocusNode();
  }


  @override
  void dispose() {
    // Dispose of the model, which handles controller disposal internally
    _model.dispose();
    super.dispose();
  }

  // --- Image Picking Logic ---
  // Accesses model.picker and updates model.profileImageFile
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _model.picker.pickImage( // Use model's picker
        source: source,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (pickedFile != null) {
        safeSetState(() { // Use safeSetState for updates
          _model.profileImageFile = File(pickedFile.path); // Update model state
        });
      }
    } catch (e) {
      print("Image picker error: $e");
      if (!mounted) return; // Check if widget is still mounted before showing Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: ${e.toString()}')),
      );
    }
  }

  // --- Show Image Source Options ---
  // This logic remains largely the same, just calls _pickImage
  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop(); // Close bottom sheet first
                  _pickImage(ImageSource.gallery);
                }),
            ListTile(
              leading: Icon(Icons.photo_camera),
              title: Text('Camera'),
              onTap: () {
                Navigator.of(context).pop(); // Close bottom sheet first
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- Navigation Logic (Using go_router) ---
  // This logic remains the same
  void _navigateToHome() {
    // Make sure 'FeedscreenWidget.routeName' is correctly defined in your FeedscreenWidget file
    // and registered in nav.dart
    context.goNamed(FeedscreenWidget.routeName);
  }

  // --- Save Profile Logic ---
  // Accesses model.isLoading, model.profileImageFile, model.bioController
  Future<void> _saveProfile() async {
    if (_model.isLoading) return; // Check model's loading state
    safeSetState(() => _model.isLoading = true); // Update model's loading state

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return; // Check mount status
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Not logged in.')),
      );
      safeSetState(() => _model.isLoading = false);
      // Make sure 'LoginScreenWidget.routeName' is correctly defined in your LoginScreenWidget file
      // and registered in nav.dart
      context.goNamed(LoginScreenWidget.routeName);
      return;
    }

    String? profilePicUrl;
    String bio = _model.bioController!.text.trim(); // Get text from model's controller

    try {
      // 1. Upload Image if selected
      if (_model.profileImageFile != null) { // Check model's image file
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_pics')
            .child('${user.uid}.jpg');
        UploadTask uploadTask = storageRef.putFile(_model.profileImageFile!); // Upload model's file
        TaskSnapshot snapshot = await uploadTask;
        profilePicUrl = await snapshot.ref.getDownloadURL();
      }

      // 2. Update Firestore Document
      Map<String, dynamic> dataToUpdate = {};
      if (profilePicUrl != null) {
        dataToUpdate['profilePicture'] = profilePicUrl;
      }
      if (bio.isNotEmpty) {
        dataToUpdate['bio'] = bio;
      }

      if (dataToUpdate.isNotEmpty) {
        final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
        final userDoc = await userDocRef.get();
        if (userDoc.exists) {
          await userDocRef.update(dataToUpdate);
        } else {
          print("Error: User document for ${user.uid} not found during profile setup.");
          // Create the document if it's missing (adjust fields as needed)
          await userDocRef.set({
            ...dataToUpdate,
            'email': user.email,
            'username': user.displayName ?? user.email?.split('@')[0],
            'uid': user.uid,
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      }

      // 3. Navigate to Home
      _navigateToHome();

    } catch (e) {
      print("Error saving profile: $e");
      if (!mounted) return; // Check mount status
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: ${e.toString()}')),
      );
    } finally {
      // Use safeSetState here as well
      if (mounted) {
        safeSetState(() => _model.isLoading = false); // Update model's loading state
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Unfocus using the model's focus node if you add one, otherwise use general unfocus
        // if (_model.bioFocusNode?.hasFocus ?? false) {
        //   _model.unfocusNode.requestFocus();
        // }
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'Setup Your Profile',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: FlutterFlowTheme.of(context).headlineMediumFamily,
              color: Colors.white,
              fontSize: 22.0,
              letterSpacing: 0.0,
              useGoogleFonts: GoogleFonts.asMap().containsKey(
                  FlutterFlowTheme.of(context).headlineMediumFamily),
            ),
          ),
          actions: [
            TextButton(
              onPressed: _navigateToHome,
              child: Text(
                'Skip',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                  color: Colors.white,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                  useGoogleFonts: GoogleFonts.asMap().containsKey(
                      FlutterFlowTheme.of(context).bodyMediumFamily),
                ),
              ),
            ),
            SizedBox(width: 10),
          ],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Add a profile picture and bio',
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: FlutterFlowTheme.of(context).titleMediumFamily,
                        color: FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).titleMediumFamily),
                      ),
                    ),
                    SizedBox(height: 24.0),

                    // --- Profile Picture ---
                    // Access model.profileImageFile for display
                    InkWell(
                      onTap: () => _showImageSourceActionSheet(context),
                      child: CircleAvatar(
                        radius: 60.0,
                        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
                        backgroundImage: _model.profileImageFile != null
                            ? FileImage(_model.profileImageFile!) // Use model's file
                            : null,
                        child: _model.profileImageFile == null
                            ? Icon(
                          Icons.camera_alt,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 50.0,
                        )
                            : null,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    TextButton(
                      onPressed: () => _showImageSourceActionSheet(context),
                      child: Text(
                        _model.profileImageFile == null ? 'Add Photo' : 'Change Photo', // Check model's file
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                          color: FlutterFlowTheme.of(context).primary,
                          letterSpacing: 0.0,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyMediumFamily),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.0),

                    // --- Bio TextField ---
                    // Use model's controller
                    TextFormField(
                      controller: _model.bioController,
                      // focusNode: _model.bioFocusNode, // Assign focus node if created in initState
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Your Bio (Optional)',
                        labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                          fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).labelMediumFamily),
                        ),
                        hintText: 'Tell us a little about yourself...',
                        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                          fontFamily: FlutterFlowTheme.of(context).labelMediumFamily,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).labelMediumFamily),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                        contentPadding: EdgeInsets.all(16.0),
                      ),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                        color: FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyMediumFamily),
                      ),
                      maxLines: 4,
                      maxLength: 150,
                      keyboardType: TextInputType.multiline,
                      cursorColor: FlutterFlowTheme.of(context).primary,
                      validator: _model.bioControllerValidator.asValidator(context), // Use model's validator if defined
                    ),

                    SizedBox(height: 32.0),

                    // --- Save Button ---
                    // Uses model.isLoading for indicator state
                    FFButtonWidget(
                      onPressed: _saveProfile,
                      text: 'Save & Continue',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 50.0,
                        padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: FlutterFlowTheme.of(context).titleSmallFamily,
                          color: Colors.white,
                          letterSpacing: 0.0,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).titleSmallFamily),
                        ),
                        elevation: 3.0,
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                        disabledColor: Colors.grey,
                      ),
                      showLoadingIndicator: _model.isLoading, // Use model's loading state
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
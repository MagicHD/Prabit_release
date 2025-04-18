import 'dart:io'; // Required for File type
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For ImagePicker instance
import '/flutter_flow/flutter_flow_util.dart'; // Import FlutterFlow utilities

class SetupProfileScreenModel extends FlutterFlowModel {
  /// State fields for stateful widgets in this page.

  // State field for Bio TextField.
  TextEditingController? bioController;
  String? Function(BuildContext, String?)? bioControllerValidator;

  // State field for managing the selected profile image file.
  File? profileImageFile;

  // State field for loading indicator.
  bool isLoading = false;

  // Instance of the image picker.
  final ImagePicker picker = ImagePicker();

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {
    // Initialize controllers or other state here if needed upon model creation.
    // bioController is initialized implicitly by the framework when used in a TextFormField.
  }

  @override
  void dispose() {
    // Dispose of the text controller when the model is discarded.
    bioController?.dispose();
  }

/// Action blocks are not typically placed in the model in FlutterFlow.
/// Keep actions like _pickImage, _saveProfile in the Widget's State class.

/// Additional helper methods are optional here.
}


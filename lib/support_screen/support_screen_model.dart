import '../flutter_flow/form_field_controller.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'support_screen_widget.dart' show SupportScreenWidget;
import 'package:flutter/material.dart';
// Import validator package if you need more complex validation, or use basic checks.
// import 'package:validators/validators.dart' as validator;

class SupportScreenModel extends FlutterFlowModel<SupportScreenWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>(); // Add form key for validation

  // State field(s) for RadioButton group
  String? reasonValue; // To store the selected reason
  FormFieldController<String>? reasonValueController;

  // State field(s) for Email TextField
  FocusNode? emailFocusNode;
  TextEditingController? emailController;
  String? Function(BuildContext, String?)? emailControllerValidator;

  // State field(s) for Message TextField
  FocusNode? messageFocusNode;
  TextEditingController? messageController;
  String? Function(BuildContext, String?)? messageControllerValidator;

  // Flag to indicate if submission is in progress
  bool isSubmitting = false;

  @override
  void initState(BuildContext context) {
    // Initialize validators
    emailControllerValidator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'Email address is required.';
      }
      // Basic email format check
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
        return 'Please enter a valid email address.';
      }
      return null;
    };

    messageControllerValidator = (context, value) {
      if (value == null || value.isEmpty) {
        return 'Message cannot be empty.';
      }
      if (value.length < 10) { // Example: Minimum length
        return 'Message must be at least 10 characters long.';
      }
      return null;
    };
  }

  @override
  void dispose() {
    emailFocusNode?.dispose();
    emailController?.dispose();

    messageFocusNode?.dispose();
    messageController?.dispose();
  }

  // --- Helper Methods ---

  /// Validates the form and returns true if valid.
  bool validateForm() {
    if (reasonValue == null) {
      // Show error if no reason is selected (handle this in the UI feedback)
      return false;
    }
    return formKey.currentState?.validate() ?? false;
  }
}
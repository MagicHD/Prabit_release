// File: prabit_design/lib/photo/post_screen/post_screen_model.dart (If it was missing)
import '/flutter_flow/flutter_flow_model.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart'; // Usually needed for form elements
import 'post_screen_widget.dart' show HabitPostScreenWidget; // Corrected import name
import 'package:flutter/material.dart';

class PostScreenModel extends FlutterFlowModel<HabitPostScreenWidget> { // Corrected Widget name
  /// State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // State field(s) for Switch widget.
  bool? switchValue; // FlutterFlow often uses this name

  @override
  void initState(BuildContext context) {
    // Initialize any default values if needed, e.g., switchValue
    switchValue = true; // Default based on previous code
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
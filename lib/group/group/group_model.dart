// group_model.dart
import 'dart:async';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'group_widget.dart' show GroupWidget; // Keep if needed, otherwise remove
import 'package:flutter/material.dart';
// Add other necessary imports if missing based on your project setup

class GroupModel extends FlutterFlowModel<GroupWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // --- Search State ---
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  bool showSearch = false; // To toggle search bar visibility
  String searchQuery = ''; // To store the current search query
  List<Map<String, dynamic>> searchResults = []; // To store search results from Firebase
  bool isSearching = false; // To indicate if a search is in progress

  // --- Group Data State ---
  List<Map<String, dynamic>> userGroups = []; // To store user's groups from Firebase
  List<Map<String, dynamic>> recommendedGroups = []; // To store recommended groups from Firebase
  bool isLoadingMyGroups = true; // Loading state for user groups
  bool isLoadingRecommendedGroups = true; // Loading state for recommended groups
  bool isLoadingSearchResults = false; // Loading state specifically for search results
  Timer? debounceTimer;

  @override
  void initState(BuildContext context) {
    // Initialize controllers if they are used directly in the model (often done in the widget's initState)
    textController ??= TextEditingController();
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }

/// Action blocks are added here.
/// Additional helper methods can also be added here.
}
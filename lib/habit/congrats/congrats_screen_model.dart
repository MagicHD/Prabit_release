// File: prabit_design/lib/habit/congrats_screen/congrats_screen_model.dart
import '/flutter_flow/flutter_flow_model.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'congrats_screen_widget.dart' show CongratsScreenWidget; // Import the widget
import 'package:flutter/material.dart';

class CongratsScreenModel extends FlutterFlowModel<CongratsScreenWidget> {
  /// State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
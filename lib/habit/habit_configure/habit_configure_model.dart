import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'habit_configure_widget.dart' show HabitConfigureWidget;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HabitConfigureModel extends FlutterFlowModel<HabitConfigureWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  // State for selected Time (using FlutterFlow's DateTime)
  DateTime? selectedTime; // FlutterFlow often uses DateTime for time pickers

  // State for selected Category
  String? selectedCategory;

  // State for selected Days (Map to track selection)
  Map<String, bool> selectedDays = {
    'M': false,
    'T': false,
    'W': false,
    'Th': false, // Adjust keys based on your UI labels if needed
    'F': false,
    'Sa': false,
    'Su': false,
  };

  // State for selected Icon (Store IconData)
  IconData? selectedIcon = FontAwesomeIcons.faceSmile; // Default Icon

  // State for selected Color (Store Color)
  Color? selectedColor = Color(0xFFFFD700);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}

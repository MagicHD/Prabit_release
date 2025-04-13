import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/habit/habitcard/habitcard_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'habit_selection_screen_widget.dart' show HabitSelectionScreenWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HabitSelectionScreenModel
    extends FlutterFlowModel<HabitSelectionScreenWidget> {
  ///  State fields for stateful widgets in this page.
  ///
  ///
  ///
  ///
  ///




  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Model for Habitcard component.


  @override
  void initState(BuildContext context) {

  }

  @override
  void dispose() {
    tabBarController?.dispose();
  }


}

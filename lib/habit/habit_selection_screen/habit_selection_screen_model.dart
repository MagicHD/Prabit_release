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

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Model for Habitcard component.
  late HabitcardModel habitcardModel1;
  // Model for Habitcard component.
  late HabitcardModel habitcardModel2;
  // Model for Habitcard component.
  late HabitcardModel habitcardModel3;
  // Model for Habitcard component.
  late HabitcardModel habitcardModel4;
  // Model for Habitcard component.
  late HabitcardModel habitcardModel5;
  // Model for Habitcard component.
  late HabitcardModel habitcardModel6;
  // Model for Habitcard component.
  late HabitcardModel habitcardModel7;
  // Model for Habitcard component.
  late HabitcardModel habitcardModel8;

  @override
  void initState(BuildContext context) {
    habitcardModel1 = createModel(context, () => HabitcardModel());
    habitcardModel2 = createModel(context, () => HabitcardModel());
    habitcardModel3 = createModel(context, () => HabitcardModel());
    habitcardModel4 = createModel(context, () => HabitcardModel());
    habitcardModel5 = createModel(context, () => HabitcardModel());
    habitcardModel6 = createModel(context, () => HabitcardModel());
    habitcardModel7 = createModel(context, () => HabitcardModel());
    habitcardModel8 = createModel(context, () => HabitcardModel());
  }

  @override
  void dispose() {
    tabBarController?.dispose();
    habitcardModel1.dispose();
    habitcardModel2.dispose();
    habitcardModel3.dispose();
    habitcardModel4.dispose();
    habitcardModel5.dispose();
    habitcardModel6.dispose();
    habitcardModel7.dispose();
    habitcardModel8.dispose();
  }
}

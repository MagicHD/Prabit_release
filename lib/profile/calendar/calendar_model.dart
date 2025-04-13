import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/profile/calender/calender_widget.dart';
import 'dart:ui';
import 'calendar_widget.dart' show CalendarWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CalendarModel extends FlutterFlowModel<CalendarWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Calender component.
  late CalenderModel calenderModel;

  @override
  void initState(BuildContext context) {
    calenderModel = createModel(context, () => CalenderModel());
  }

  @override
  void dispose() {
    calenderModel.dispose();
  }
}
